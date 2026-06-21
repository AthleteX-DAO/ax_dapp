import 'package:ax_dapp/predict/livestream/livestream_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveStreamRepository {
  const LiveStreamRepository({required FirebaseFirestore fireStore})
      : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  CollectionReference get _collection => _fireStore.collection('livestreams');

  /// Returns a stream of all active (live or upcoming) streams,
  /// ordered by isFeatured desc, then isLive desc.
  Stream<List<LiveStreamModel>> getActiveStreams() {
    return _collection
        .orderBy('isFeatured', descending: true)
        .orderBy('isLive', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(LiveStreamModel.fromFirestore).toList(),
        );
  }

  /// Returns streams filtered by sport category.
  Stream<List<LiveStreamModel>> getStreamsBySport(String sport) {
    return _collection
        .where('sport', isEqualTo: sport)
        .where('isLive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(LiveStreamModel.fromFirestore).toList(),
        );
  }

  /// One-shot fetch of all active streams.
  Future<List<LiveStreamModel>> fetchActiveStreams() async {
    try {
      final snapshot = await _collection
          .orderBy('isFeatured', descending: true)
          .orderBy('isLive', descending: true)
          .get();
      return snapshot.docs.map(LiveStreamModel.fromFirestore).toList();
    } catch (_) {
      return [];
    }
  }
}
