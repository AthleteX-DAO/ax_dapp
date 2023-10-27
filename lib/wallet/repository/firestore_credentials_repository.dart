import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wallet_repository/wallet_repository.dart';

class FireStoreCredentialsRepository {
  FireStoreCredentialsRepository({
    required FirebaseFirestore fireStore,
    required WalletRepository walletRepository,
  })  : _firestore = fireStore,
        _walletRepository = walletRepository;

  final FirebaseFirestore _firestore;
  final WalletRepository _walletRepository;

  /// This function encrypts & stores a users credentials in firestor
  Future<void> storeCredentials(String email) async {
    // Setup encryption keys

    final key = Key.fromUtf8(email);
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final hashedKey = encrypter.encrypt(_walletRepository.privateKey, iv: iv);

    // Store relevant data
    await _firestore.collection('credentials').doc(email).set({
      'email': email,
      'encrypted-key': hashedKey.base64,
    });
  }

  /// This function loads and decrypts a [EthPrivateKey] based on an email
  Future<String> loadCredentials(String email) async {
    // Setup encryption keys
    final key = Key.fromUtf8(email);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    // Fetch relevant data
    final listOfCredentials =
        await _firestore.collection('credentials').doc(email).get();
    final data = listOfCredentials.data();
    final hashedKey = data?['encrypted-key'] as String;

    final encrypted = Encrypted.fromBase64(hashedKey);
    final decryptedPrivateKey = encrypter.decrypt(encrypted, iv: iv);
    return decryptedPrivateKey;
  }
}
