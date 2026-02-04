import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:wallet_repository/wallet_repository.dart';

class FireStoreCredentialsRepository {
  FireStoreCredentialsRepository({
    required FirebaseFirestore fireStore,
    required WalletRepository walletRepository,
  })  : _firestore = fireStore;

  final FirebaseFirestore _firestore;

  /// Encrypts private key with user's password and stores in Firebase
  /// Uses PBKDF2 to derive encryption key from password
  /// Returns the encrypted key string
  Future<String> storeCredentials(String email, String password, String privateKeyHex) async {
    try {
      debugPrint('🔐 storeCredentials: Step 1 - About to derive key from password');
      // Derive encryption key from password using PBKDF2
      final encryptionKey = _deriveKeyFromPassword(password, email);
      debugPrint('🔐 storeCredentials: Step 2 - Key derived successfully');
      
      debugPrint('🔐 storeCredentials: Step 3 - About to encrypt private key (${privateKeyHex.length} chars)');
      // Encrypt private key
      final encrypter = Encrypter(AES(encryptionKey));
      final iv = IV.fromSecureRandom(16);
      final encrypted = encrypter.encrypt(privateKeyHex, iv: iv);
      debugPrint('🔐 storeCredentials: Step 4 - Private key encrypted (${encrypted.base64.length} chars)');
      
      final currentUser = FirebaseAuth.instance.currentUser;
      debugPrint(
        '🔐 storeCredentials: Step 5 - About to store in Firestore collection=encrypted_wallets, doc=$email, authUser=${currentUser?.uid}');
      // Store ONLY encrypted data and IV (NO password or key)
      final payload = <String, String>{
        'email': email,
        'encryptedKey': encrypted.base64,
        'iv': iv.base64,
        // Password is NEVER stored!
      };
      debugPrint('🔐 storeCredentials: Step 5a - Payload created: ${payload.keys.join(", ")}');
      
        await _firestore
          .collection('encrypted_wallets')
          .doc(email)
          .set(payload)
          .timeout(const Duration(seconds: 10));
      debugPrint('🔐 storeCredentials: Step 6 - Successfully stored in Firestore!');
      return encrypted.base64;
    } catch (e, st) {
      debugPrint('🔐 storeCredentials ERROR: $e');
      debugPrint('🔐 storeCredentials STACK: $st');
      rethrow;
    }
  }

  /// Decrypts private key using user's password
  /// Returns the decrypted private key hex string
  Future<String> loadCredentials(String email, String password) async {
    final doc = await _firestore.collection('encrypted_wallets').doc(email).get();
    
    if (!doc.exists) {
      throw Exception('No wallet found for this email');
    }
    
    final data = doc.data()!;
    final encryptedKeyBase64 = data['encryptedKey'] as String;
    final ivBase64 = data['iv'] as String;
    
    // Derive same encryption key from password
    final encryptionKey = _deriveKeyFromPassword(password, email);
    
    // Decrypt private key
    final encrypter = Encrypter(AES(encryptionKey));
    final encrypted = Encrypted.fromBase64(encryptedKeyBase64);
    final iv = IV.fromBase64(ivBase64);
    
    try {
      final decryptedPrivateKey = encrypter.decrypt(encrypted, iv: iv);
      return decryptedPrivateKey;
    } catch (e) {
      throw Exception('Invalid password or corrupted wallet data');
    }
  }

  /// Derives a 256-bit encryption key from password using PBKDF2
  /// Uses email as salt for deterministic key derivation
  Key _deriveKeyFromPassword(String password, String salt) {
    final saltBytes = Uint8List.fromList(utf8.encode(salt));
    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    debugPrint('🔐 deriveKey: saltBytes=${saltBytes.length}, passwordBytes=${passwordBytes.length}');

    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(saltBytes, 100000, 32));

    final keyBytes = derivator.process(passwordBytes);
    return Key(Uint8List.fromList(keyBytes));
  }
}
