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
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(
    AES(Key.fromSecureRandom(32), mode: AESMode.cbc, padding: null),
  );

  /// This function encrypts and then stores a users private key on firebase
  /// It returns a [String] of the encrypted key.
  Future<String> storeCredentials(String email) async {
    final hashedKey = encrypter.encrypt(_walletRepository.privateKey, iv: iv);
    final payload = <String, String>{
      'email': email,
      'encrypted-key': hashedKey.base64,
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

    final encrypted = Encrypted.fromBase64(hashedKey);
    final decryptedPrivateKey = encrypter.decrypt(encrypted, iv: iv);

    return decryptedPrivateKey;
  }
}
