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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email');
      } else {
        debugPrint('$e');
      }
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user');
      } else {
        debugPrint('$e');
      }
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
