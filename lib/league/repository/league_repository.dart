import 'package:ax_dapp/league/models/league.dart';
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
      await _fireStore
          .collection('Leagues')
          .where('leagueID', isEqualTo: leagueID)
          .get()
          .then((querySnapshot) => querySnapshot.docs[0].reference.delete());
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
          .where('leagueID', isEqualTo: leagueID)
          .get()
          .then(
            (querySnapshot) =>
                querySnapshot.docs[0].reference.update(league.toJson()),
          );
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateRoster({
    required String leagueID,
    required String userWallet,
    required Map<String, double> roster,
  }) async {
    try {
      await _fireStore
          .collection('Leagues')
          .where('leagueID', isEqualTo: leagueID)
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs[0].reference
                .update({'rosters.$userWallet': roster}),
          );
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> enrollUser({
    required String leagueID,
    required String userWallet,
    required Map<String, double> roster,
  }) async {
    try {
      await _fireStore
          .collection('Leagues')
          .where('leagueID', isEqualTo: leagueID)
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs[0].reference
                .update({'rosters.$userWallet': roster}),
          );
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
          .where('leagueID', isEqualTo: leagueID)
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs[0].reference
                .update({'rosters.$userWallet': FieldValue.delete()}),
          );
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }
}
