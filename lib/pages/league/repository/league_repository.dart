import 'package:ax_dapp/pages/league/models/league.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LeagueRepository {
  LeagueRepository({required FirebaseFirestore fireStore})
      : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  Future<void> createLeague({
    required League league,
  }) async {
    try {
      await _fireStore.collection('Leagues').add(league.toJson());
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<List<League>> fetchLeagues() async {
    try {
      final leagues = await _fireStore.collection('Leagues').get();
      return leagues.docs.map((e) => League.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  Future<void> deleteLeague({required String leagueID}) async {
    try {
      await _fireStore.collection('Leagues').doc(leagueID).delete();
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateLeague({
    required String leagueID,
    required League league,
  }) async {
    try {
      await _fireStore
          .collection('Leagues')
          .doc(leagueID)
          .update(league.toJson());
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateRoster({
    required String leagueID,
    required String userWallet,
    required List<String> roster,
  }) async {
    try {
      await _fireStore
          .collection('Leagues')
          .doc(leagueID)
          .update({'rosters.$userWallet': roster});
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> enrollUser({
    required String leagueID,
    required String userWallet,
    required List<String> roster,
  }) async {
    try {
      await _fireStore
          .collection('Leagues')
          .doc(leagueID)
          .set({'rosters.$userWallet': roster});
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> removeUser({
    required String leagueID,
    required String userWallet,
  }) async {
    try {
      await _fireStore
          .collection('Leagues')
          .doc(leagueID)
          .update({'rosters.$userWallet': FieldValue.delete()});
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }
}
