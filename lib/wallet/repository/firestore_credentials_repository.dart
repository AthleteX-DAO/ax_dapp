import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:wallet_repository/wallet_repository.dart';

class FireStoreCredentialsRepository {
  FireStoreCredentialsRepository({
    required FirebaseFirestore fireStore,
    required WalletRepository walletRepository,
  })  : _firestore = fireStore,
        _walletRepository = walletRepository;

  final FirebaseFirestore _firestore;
  final WalletRepository _walletRepository;

  /// This function encrypts and then stores a users private key on firebase
  /// It returns a [String] of the encrypted key.
  Future<String> storeCredentials(String email) async {
    final key = Key.fromSecureRandom(32);
    final encrypter = Encrypter(
      AES(key, mode: AESMode.cbc, padding: null),
    );
    final iv = IV.fromLength(16);
    final hashedKey = encrypter.encrypt(_walletRepository.privateKey, iv: iv);
    final payload = <String, String>{
      'email': email,
      'encrypted-key': hashedKey.base64,
      'base-64-key': key.base64,
      'base-64-iv': iv.base64,
    };
    await _firestore.collection('credentials').doc(email).set(payload);
    return hashedKey.base64;
  }

  /// This function loads and decrypts an already encrypted-key that is linked to an email
  /// This returns a [String] of the unloaded & decrypted private key
  Future<String> loadCredentials(String email) async {
    final listOfCredentials =
        await _firestore.collection('credentials').doc(email).get();
    final data = listOfCredentials.data();
    final hashedKey = data?['encrypted-key'] as String;
    final ivBase64 = data?['base-64-iv'] as String;
    final keyBase64 = data?['base-64-key'] as String;
    final iv = IV.fromBase64(ivBase64);
    final key = Key.fromBase64(keyBase64);
    final encrypter = Encrypter(
      AES(key, mode: AESMode.cbc, padding: null),
    );
    final encrypted = Encrypted.fromBase64(hashedKey);
    final decryptedPrivateKey = encrypter.decrypt(encrypted, iv: iv);
    return decryptedPrivateKey;
  }
}
