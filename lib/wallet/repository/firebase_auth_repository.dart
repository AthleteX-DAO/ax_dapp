import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class FireBaseAuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Cannot create user: $e');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Cannot sign in: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Cannot sign out: $e');
    }
  }
}
