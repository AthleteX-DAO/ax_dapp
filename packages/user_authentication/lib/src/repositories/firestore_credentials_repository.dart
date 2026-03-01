import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// Manages encrypted storage of wallet private keys in Firestore.
///
/// ## Encryption scheme versions
///
/// ### v2 (current — all new accounts)
/// - **KDF**: PBKDF2-SHA256, 100,000 iterations, 32-byte cryptographically
///   random salt (generated fresh on every store).
/// - **Cipher**: AES-256-GCM (authenticated encryption). Provides both
///   confidentiality and integrity — tampering with the ciphertext causes
///   decryption to fail with an authentication error before any plaintext
///   is exposed.
/// - **IV**: 12-byte random (NIST-recommended for GCM).
/// - **Stored fields**: `encryptedKey`, `iv`, `salt`, `v=2`.
///   The password, plaintext key, and email are **never** stored.
///
/// ### v1 (legacy — read-only, not used for new stores)
/// - KDF: PBKDF2-SHA256, email-as-salt (predictable, known).
/// - Cipher: AES-256-CBC (no authentication tag).
/// - Kept only as a decryption fallback so existing users are not locked out.
class FireStoreCredentialsRepository {
  FireStoreCredentialsRepository({
    required FirebaseFirestore fireStore,
    required WalletRepository walletRepository,
  }) : _firestore = fireStore;

  final FirebaseFirestore _firestore;

  // Bump this when the storage scheme changes.
  static const int _currentSchemeVersion = 2;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Encrypts [privateKeyHex] with [password] and stores the result in
  /// Firestore under [email] (used only as a document key — not stored in the
  /// document body).
  ///
  /// Returns the base64-encoded ciphertext.
  Future<String> storeCredentials(
    String email,
    String password,
    String privateKeyHex,
  ) async {
    // Random 32-byte salt — never predictable, never derived from email.
    final salt = IV.fromSecureRandom(32);
    final encryptionKey = _deriveKey(password, salt.bytes);

    // AES-256-GCM: authenticated encryption (confidentiality + integrity).
    // 12-byte IV is the NIST-recommended nonce size for GCM.
    final iv = IV.fromSecureRandom(12);
    final encrypter = Encrypter(AES(encryptionKey, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(privateKeyHex, iv: iv);

    // Store only the ciphertext, IV, salt, and scheme version.
    // Password, plaintext key, and email are NEVER stored in the document body.
    await _firestore
        .collection('encrypted_wallets')
        .doc(email)
        .set({
          'encryptedKey': encrypted.base64,
          'iv': iv.base64,
          'salt': salt.base64,
          'v': _currentSchemeVersion,
        })
        .timeout(const Duration(seconds: 10));

    return encrypted.base64;
  }

  /// Loads and decrypts the wallet private key for [email].
  ///
  /// Supports v2 (random salt, AES-GCM) for new accounts and legacy v1
  /// (email-as-salt, AES-CBC) for accounts created before the upgrade so
  /// existing users are not locked out.
  Future<String> loadCredentials(String email, String password) async {
    final doc = await _firestore
        .collection('encrypted_wallets')
        .doc(email)
        .get();

    if (!doc.exists) {
      throw Exception('No wallet found for this email');
    }

    final data = doc.data()!;
    final version = data['v'] as int? ?? 1;

    try {
      return version >= 2
          ? _decryptV2(data, password)
          : _decryptV1(data, password, email);
    } catch (_) {
      throw Exception('Invalid password or corrupted wallet data');
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Decrypts a v2 record: random salt + AES-256-GCM.
  String _decryptV2(Map<String, dynamic> data, String password) {
    final salt = IV.fromBase64(data['salt'] as String);
    final iv = IV.fromBase64(data['iv'] as String);
    final encryptionKey = _deriveKey(password, salt.bytes);
    final encrypter = Encrypter(AES(encryptionKey, mode: AESMode.gcm));
    return encrypter.decrypt(
      Encrypted.fromBase64(data['encryptedKey'] as String),
      iv: iv,
    );
  }

  /// Decrypts a legacy v1 record: email-as-salt + AES-256-CBC.
  String _decryptV1(
    Map<String, dynamic> data,
    String password,
    String email,
  ) {
    final saltBytes = Uint8List.fromList(utf8.encode(email));
    final encryptionKey = _deriveKey(password, saltBytes);
    final encrypter = Encrypter(AES(encryptionKey));
    final iv = IV.fromBase64(data['iv'] as String);
    return encrypter.decrypt(
      Encrypted.fromBase64(data['encryptedKey'] as String),
      iv: iv,
    );
  }

  /// Derives a 256-bit AES key from [password] using PBKDF2-SHA256.
  ///
  /// [saltBytes] must be a cryptographically random value for v2, or the
  /// email bytes for legacy v1 decryption. 100,000 iterations makes
  /// brute-force attacks ~100ms per guess on modern hardware.
  Key _deriveKey(String password, Uint8List saltBytes) {
    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(saltBytes, 100000, 32));
    return Key(Uint8List.fromList(derivator.process(passwordBytes)));
  }
}
