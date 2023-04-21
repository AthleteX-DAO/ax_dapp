import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
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
      final leagueRef = (await _fireStore
              .collection('Leagues')
              .where('leagueID', isEqualTo: leagueID)
              .get())
          .docs[0]
          .reference;

      await leagueRef.collection('Teams').get().then((snapshot) {
        for (final team in snapshot.docs) {
          team.reference.delete();
        }
      });

      await leagueRef.delete();
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateLeague({
    required String leagueID,
    required League league,
  }) async {
    try {
      final leagueRef = (await _fireStore
              .collection('Leagues')
              .where('leagueID', isEqualTo: leagueID)
              .get())
          .docs[0]
          .reference;

      await leagueRef.update(league.toJson());
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<List<LeagueTeam>> getLeagueTeams({
    required String leagueID,
  }) async {
    try {
      final leagueRef = (await _fireStore
              .collection('Leagues')
              .where('leagueID', isEqualTo: leagueID)
              .get())
          .docs[0]
          .reference;

      final leagueTeams = await leagueRef.collection('Teams').get();
      return leagueTeams.docs
          .map((e) => LeagueTeam.fromJson(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  Future<void> updateRoster({
    required String leagueID,
    required LeagueTeam team,
  }) async {
    print('UPDATING THE ROSTER');
    print(leagueID);
    print(team.userWalletID);
    try {
      final leagueRef = (await _fireStore
              .collection('Leagues')
              .where('leagueID', isEqualTo: leagueID)
              .get())
          .docs[0]
          .reference;

      print(leagueRef.id);

      final teamRef = (await leagueRef
              .collection('Teams')
              .where('userWalletID', isEqualTo: team.userWalletID)
              .get())
          .docs[0]
          .reference;
      
      print(teamRef.id);

      await teamRef.update(
        {'roster': team.roster, 'teamAppreciation': team.teamAppreciation},
      );
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> enrollUser({
    required String leagueID,
    required LeagueTeam team,
  }) async {
    try {
      final leagueRef = (await _fireStore
              .collection('Leagues')
              .where('leagueID', isEqualTo: leagueID)
              .get())
          .docs[0]
          .reference;

      await leagueRef.collection('Teams').add(team.toJson());
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> removeUser({
    required String leagueID,
    required String userWallet,
  }) async {
    try {
      final leagueRef = (await _fireStore
              .collection('Leagues')
              .where('leagueID', isEqualTo: leagueID)
              .get())
          .docs[0]
          .reference;

      final teamRef = (await leagueRef
              .collection('Teams')
              .where('userWallet', isEqualTo: userWallet)
              .get())
          .docs[0]
          .reference;

      await teamRef.delete();
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateWinnner({
    required String leagueID,
    required String winnerWallet,
  }) async {
    try {
      final leagueRef = (await _fireStore
              .collection('Leagues')
              .where('leagueID', isEqualTo: leagueID)
              .get())
          .docs[0]
          .reference;

      await leagueRef.update({'winner': winnerWallet});
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }
}
