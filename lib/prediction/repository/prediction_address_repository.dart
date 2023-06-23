import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PredictionAddressRepository {
  PredictionAddressRepository({required FirebaseFirestore fireStore})
      : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  Future<List<String>> fetchMarketAddresses(String id) async {
    try {
      final documentSnapshot =
          await _fireStore.collection('EventMarket').doc(id).get();
      if (documentSnapshot.exists) {
        final documentSnapshotData = documentSnapshot.data();
        final yesAddress = documentSnapshotData?['YesAddress'].toString();
        final noAddress = documentSnapshotData?['NoAddress'].toString();
        debugPrint('$yesAddress, $noAddress');
        return [yesAddress!, noAddress!];
      }
      return [];
    } on FirebaseException catch (e) {
      debugPrint('$e');
      return [];
    }
  }
}
