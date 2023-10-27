import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
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
  /// It returns a [void]
  Future<String> storeCredentials(String email) async {
    // Setup encryption keys

    final hashedKey = encrypter.encrypt(_walletRepository.privateKey, iv: iv);

    // Store relevant data
    final payload = <String, String>{
      'email': email,
      'encrypted-key': hashedKey.base64,
    };
    await _firestore.collection('credentials').doc('$email').set(payload);
    return hashedKey.base64;
  }

  /// This function loads and decrypts a [EthPrivateKey] based on an email
  /// This returns a [String] of the unloaded & decrypted private key
  Future<String> loadCredentials(String email) async {
    // Setup encryption keys

    // Fetch relevant data
    final listOfCredentials =
        await _firestore.collection('credentials').doc('$email').get();
    final data = listOfCredentials.data();
    final hashedKey = data?['encrypted-key'] as String;

    final encrypted = Encrypted.fromBase64(hashedKey);
    final decryptedPrivateKey = encrypter.decrypt(encrypted, iv: iv);

    return decryptedPrivateKey;
  }
}
