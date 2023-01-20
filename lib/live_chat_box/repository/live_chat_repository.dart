import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LiveChatRepository {
  LiveChatRepository({required FirebaseFirestore fireStore})
      : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  Future<void> sendMessage(String text) async {
    try {
      await _fireStore
          .collection('livechat')
          .doc('1')
          .collection('comments')
          .doc()
          .set({
        'message': text,
        'createdAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }
}
