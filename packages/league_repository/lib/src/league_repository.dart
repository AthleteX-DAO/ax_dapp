import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:league_repository/src/models/models.dart';
import 'package:shared/shared.dart';

/// {@template tokens_repository}
/// Repository that manages the league domain.
/// {@endtemplate}
class LeagueRepository {
  /// {@macro league_repository}
  LeagueRepository({required FirebaseFirestore fireStore})
      : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  /// Creates a new [League] from the instance.
  Future<void> createLeague({
    required League league,
  }) async {
    try {
      await _fireStore.collection('Leagues').add(league.toJson());
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  /// Streams the current list of [League]s.
  Stream<List<League>> fetchLeagues() =>
      _fireStore.collection('Leagues').snapshots().map(
            (querySnapShot) => querySnapShot.docs
                .map((e) => League.fromJson(e.data()))
                .toList(),
          );

  /// Stream a list of [Pair]s that holds [League] and a list of [LeagueTeam]s.
  Stream<List<Pair<League, List<LeagueTeam>>>> getLeaguesWithTeams() {
    final leaguesStream = fetchLeagues();
    final teamsStream = leaguesStream.switchMap(
      (leagues) => Rx.combineLatestList(
        leagues.map((league) => getLeagueTeams(leagueID: league.leagueID)),
      ),
    );

    return Rx.combineLatest2(
      leaguesStream,
      teamsStream,
      (List<League> leagues, List<List<LeagueTeam>> teams) {
        return [
          for (var pair in IterableZip([leagues, teams]))
            Pair(first: pair[0] as League, second: pair[1] as List<LeagueTeam>)
        ];
      },
    );
  }

  /// Deleted a [League] from the [leagueID].
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

  /// Updates the current league by its [leagueID].
  /// Takes in the updated [League].
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

  /// Retrieves the [LeagueTeam] based on its [leagueID].
  Future<List<LeagueTeam>> fetchLeagueTeams({
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

  /// Streams the current list of [LeagueTeam]s based on the [leagueID].
  Stream<List<LeagueTeam>> getLeagueTeams({required String leagueID}) {
    final leagueRef = _fireStore
        .collection('Leagues')
        .where('leagueID', isEqualTo: leagueID)
        .snapshots()
        .map((querySnapShot) => querySnapShot.docs.first.reference);
    return leagueRef.flatMap((ref) => ref.collection('Teams').snapshots()).map(
          (querySnapShot) => querySnapShot.docs
              .map((e) => LeagueTeam.fromJson(e.data()))
              .toList(),
        );
  }

  /// Updates the [LeagueTeam] of the user.
  Future<void> updateRoster({
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

      final teamRef = (await leagueRef
              .collection('Teams')
              .where('userWalletID', isEqualTo: team.userWalletID)
              .get())
          .docs[0]
          .reference;

      await teamRef.update(team.toJson());
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  /// Enrolls a user in a league.
  /// Adds the users' [LeagueTeam].
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

  /// Removes a user from the league.
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
              .where('userWalletID', isEqualTo: userWallet)
              .get())
          .docs[0]
          .reference;

      await teamRef.delete();
    } on FirebaseException catch (e) {
      debugPrint('$e');
    }
  }

  /// Updates the [winnerWallet] of the league once it ends.
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
