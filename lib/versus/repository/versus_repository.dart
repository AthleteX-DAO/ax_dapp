import 'dart:math' as math;

import 'package:ax_dapp/versus/models/athlete_elo.dart';
import 'package:ax_dapp/versus/models/versus_match_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for managing versus battles, ELO rankings, and matchmaking
class VersusRepository {
  const VersusRepository({
    required FirebaseFirestore fireStore,
  }) : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  static const String _votesCollection = 'battle_votes';
  static const double _eloMatchRange = 200.0; // Match athletes within ±200 ELO

  // ---------------------------------------------------------------------------
  // Rapper seed data — written to Firestore once when collection is empty
  // ---------------------------------------------------------------------------
  static const List<Map<String, dynamic>> _rapperSeedData = [
    {'athleteId': 101, 'athleteName': 'Kendrick Lamar', 'sport': 'Music', 'team': 'TDE / pgLang', 'elo': 1450.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 102, 'athleteName': 'Drake', 'sport': 'Music', 'team': 'OVO Sound', 'elo': 1400.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 103, 'athleteName': 'Jay-Z', 'sport': 'Music', 'team': 'Roc Nation', 'elo': 1430.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 104, 'athleteName': 'Eminem', 'sport': 'Music', 'team': 'Aftermath', 'elo': 1420.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 105, 'athleteName': 'Lil Wayne', 'sport': 'Music', 'team': 'Young Money', 'elo': 1380.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 106, 'athleteName': 'Kanye West', 'sport': 'Music', 'team': 'GOOD Music', 'elo': 1390.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 107, 'athleteName': 'Nas', 'sport': 'Music', 'team': 'Mass Appeal', 'elo': 1370.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 108, 'athleteName': 'J. Cole', 'sport': 'Music', 'team': 'Dreamville', 'elo': 1360.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 109, 'athleteName': 'Tyler, the Creator', 'sport': 'Music', 'team': 'Odd Future', 'elo': 1340.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 110, 'athleteName': 'Nicki Minaj', 'sport': 'Music', 'team': 'Young Money', 'elo': 1350.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 111, 'athleteName': 'Cardi B', 'sport': 'Music', 'team': 'Atlantic Records', 'elo': 1320.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 112, 'athleteName': 'Future', 'sport': 'Music', 'team': 'A1 / Freebandz', 'elo': 1310.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 113, 'athleteName': 'Travis Scott', 'sport': 'Music', 'team': 'Cactus Jack', 'elo': 1330.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 114, 'athleteName': 'Megan Thee Stallion', 'sport': 'Music', 'team': '300 Entertainment', 'elo': 1300.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 115, 'athleteName': 'Lil Baby', 'sport': 'Music', 'team': '4PF / Quality Control', 'elo': 1280.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 116, 'athleteName': 'A\$AP Rocky', 'sport': 'Music', 'team': 'A\$AP Mob / AWGE', 'elo': 1290.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 117, 'athleteName': 'Lil Uzi Vert', 'sport': 'Music', 'team': 'Generation Now', 'elo': 1260.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 118, 'athleteName': 'Post Malone', 'sport': 'Music', 'team': 'Republic Records', 'elo': 1270.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 119, 'athleteName': 'Playboi Carti', 'sport': 'Music', 'team': 'Opium', 'elo': 1240.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 120, 'athleteName': 'Gunna', 'sport': 'Music', 'team': 'YSL Records', 'elo': 1230.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
  ];

  // ---------------------------------------------------------------------------
  // Finance Bro seed data — written to Firestore once when collection is empty
  // ---------------------------------------------------------------------------
  static const List<Map<String, dynamic>> _financeBroSeedData = [
    {'athleteId': 201, 'athleteName': 'Elon Musk', 'sport': 'Finance', 'team': 'Tesla / SpaceX', 'elo': 1500.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 202, 'athleteName': 'Warren Buffett', 'sport': 'Finance', 'team': 'Berkshire Hathaway', 'elo': 1480.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 203, 'athleteName': 'Jamie Dimon', 'sport': 'Finance', 'team': 'JPMorgan Chase', 'elo': 1460.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 204, 'athleteName': 'Ray Dalio', 'sport': 'Finance', 'team': 'Bridgewater Associates', 'elo': 1440.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 205, 'athleteName': 'Michael Burry', 'sport': 'Finance', 'team': 'Scion Asset Management', 'elo': 1420.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 206, 'athleteName': 'Larry Fink', 'sport': 'Finance', 'team': 'BlackRock', 'elo': 1400.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 207, 'athleteName': 'Carl Icahn', 'sport': 'Finance', 'team': 'Icahn Enterprises', 'elo': 1380.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 208, 'athleteName': 'Cathie Wood', 'sport': 'Finance', 'team': 'ARK Invest', 'elo': 1360.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 209, 'athleteName': 'Bill Ackman', 'sport': 'Finance', 'team': 'Pershing Square', 'elo': 1340.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 210, 'athleteName': 'Ken Griffin', 'sport': 'Finance', 'team': 'Citadel', 'elo': 1350.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 211, 'athleteName': 'David Tepper', 'sport': 'Finance', 'team': 'Appaloosa Management', 'elo': 1320.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 212, 'athleteName': 'Steve Cohen', 'sport': 'Finance', 'team': 'Point72 Asset Management', 'elo': 1310.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 213, 'athleteName': 'Paul Tudor Jones', 'sport': 'Finance', 'team': 'Tudor Investment Corp', 'elo': 1330.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 214, 'athleteName': 'Stanley Druckenmiller', 'sport': 'Finance', 'team': 'Duquesne Family Office', 'elo': 1300.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 215, 'athleteName': 'George Soros', 'sport': 'Finance', 'team': 'Soros Fund Management', 'elo': 1470.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 216, 'athleteName': 'Jim Simons', 'sport': 'Finance', 'team': 'Renaissance Technologies', 'elo': 1490.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 217, 'athleteName': 'Peter Thiel', 'sport': 'Finance', 'team': 'Founders Fund', 'elo': 1370.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 218, 'athleteName': 'Marc Andreessen', 'sport': 'Finance', 'team': 'Andreessen Horowitz', 'elo': 1290.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 219, 'athleteName': 'Chamath Palihapitiya', 'sport': 'Finance', 'team': 'Social Capital', 'elo': 1280.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
    {'athleteId': 220, 'athleteName': 'Sam Bankman-Fried', 'sport': 'Finance', 'team': 'FTX (RIP)', 'elo': 900.0, 'wins': 0, 'losses': 0, 'totalBattles': 0},
  ];

  /// Seeds rapper_elo_rankings with default data if the collection is empty.
  Future<void> _seedRappersIfNeeded() async {
    const collection = 'rapper_elo_rankings';
    final snapshot = await _fireStore.collection(collection).limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // already seeded

    final batch = _fireStore.batch();
    for (final data in _rapperSeedData) {
      final ref = _fireStore.collection(collection).doc();
      batch.set(ref, data);
    }
    await batch.commit();
  }

  /// Seeds finance_bro_elo_rankings with default data if the collection is empty.
  Future<void> _seedFinanceBrosIfNeeded() async {
    const collection = 'finance_bro_elo_rankings';
    final snapshot = await _fireStore.collection(collection).limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // already seeded

    final batch = _fireStore.batch();
    for (final data in _financeBroSeedData) {
      final ref = _fireStore.collection(collection).doc();
      batch.set(ref, data);
    }
    await batch.commit();
  }

  /// Get collection name for market and sport
  String _getCollectionForMarket({required String marketName, String? sport}) {
    if (marketName == 'Who is the #1 Ranked Rapper?' || sport == 'Music') {
      return 'rapper_elo_rankings';
    }
    if (marketName == 'Who is the #1 Ranked Finance Bro?' || sport == 'Finance') {
      return 'finance_bro_elo_rankings';
    }
    return 'athlete_elo_rankings';
  }

  /// Get all athletes with ELO rankings for a specific market
  Future<List<AthleteElo>> getAllAthletes({
    required String marketName,
    String? sport,
  }) async {
    try {
      final collection = _getCollectionForMarket(marketName: marketName, sport: sport);
      final snapshot = await _fireStore.collection(collection).get();
      return snapshot.docs
          .map((doc) => AthleteElo.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch athletes: $e');
    }
  }

  /// Get top athletes by ELO ranking for a specific market
  Stream<List<AthleteElo>> getLeaderboard({
    required String marketName,
    String? sport,
    int limit = 100,
  }) {
    final collection = _getCollectionForMarket(marketName: marketName, sport: sport);
    return _fireStore
        .collection(collection)
        .orderBy('elo', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AthleteElo.fromJson(doc.data()))
              .toList(),
        );
  }

  /// Get a specific athlete's ELO data for a specific market
  Future<AthleteElo?> getAthleteElo(
    int athleteId, {
    required String marketName,
    String? sport,
  }) async {
    try {
      final collection = _getCollectionForMarket(marketName: marketName, sport: sport);
      final snapshot = await _fireStore
          .collection(collection)
          .where('athleteId', isEqualTo: athleteId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) return null;
      return AthleteElo.fromJson(snapshot.docs.first.data());
    } catch (e) {
      throw Exception('Failed to fetch athlete ELO: $e');
    }
  }

  /// Create or update athlete ELO record for a specific market
  Future<void> upsertAthleteElo(
    AthleteElo athlete, {
    required String marketName,
    String? sport,
  }) async {
    try {
      final collection = _getCollectionForMarket(marketName: marketName, sport: sport);
      
      // Check if athlete already exists
      final existing = await _fireStore
          .collection(collection)
          .where('athleteId', isEqualTo: athlete.athleteId)
          .limit(1)
          .get();
      
      if (existing.docs.isNotEmpty) {
        // Update existing document
        await existing.docs.first.reference.set(
          athlete.toJson(),
          SetOptions(merge: true),
        );
      } else {
        // Create new document with auto-generated ID
        await _fireStore
            .collection(collection)
            .add(athlete.toJson());
      }
    } catch (e) {
      throw Exception('Failed to update athlete ELO: $e');
    }
  }

  /// Generate a random skill-based matchup
  /// Pairs athletes within ±200 ELO range for balanced battles
  Future<VersusMatchModel?> generateMatchup({
    required String marketName,
    String? sport,
  }) async {
    try {
      // Auto-seed rappers on first load
      if (marketName == 'Who is the #1 Ranked Rapper?' || sport == 'Music') {
        await _seedRappersIfNeeded();
      }

      // Auto-seed finance bros on first load
      if (marketName == 'Who is the #1 Ranked Finance Bro?' || sport == 'Finance') {
        await _seedFinanceBrosIfNeeded();
      }

      final athletes = await getAllAthletes(marketName: marketName, sport: sport);
      
      if (athletes.length < 2) {
        throw Exception('Not enough athletes for matchup');
      }

      // Filter by sport if provided (additional safety check)
      final filteredAthletes = sport != null
          ? athletes.where((a) => a.sport.toLowerCase() == sport.toLowerCase()).toList()
          : athletes;

      if (filteredAthletes.length < 2) {
        throw Exception('Not enough athletes in sport: $sport');
      }

      // Randomly select first athlete
      final random = math.Random();
      final athlete1 = filteredAthletes[random.nextInt(filteredAthletes.length)];

      // Find athletes within ELO range
      final eligibleOpponents = filteredAthletes.where((a) {
        return a.athleteId != athlete1.athleteId &&
            (a.elo - athlete1.elo).abs() <= _eloMatchRange;
      }).toList();

      // If no opponents in range, use any athlete
      final athlete2 = eligibleOpponents.isNotEmpty
          ? eligibleOpponents[random.nextInt(eligibleOpponents.length)]
          : filteredAthletes.firstWhere((a) => a.athleteId != athlete1.athleteId);

      final matchId =
          '${athlete1.athleteId}_vs_${athlete2.athleteId}_${DateTime.now().millisecondsSinceEpoch}';

      return VersusMatchModel(
        matchId: matchId,
        athlete1: athlete1,
        athlete2: athlete2,
        marketName: marketName,
      );
    } catch (e) {
      throw Exception('Failed to generate matchup: $e');
    }
  }

  /// Submit a vote and update ELO ratings
  Future<void> submitVote({
    required String matchId,
    required String walletAddress,
    required int winnerId,
    required int loserId,
    required String marketName,
    String? sport,
  }) async {
    try {
      // Get current ELO data for both athletes
      final winner = await getAthleteElo(
        winnerId,
        marketName: marketName,
        sport: sport,
      );
      final loser = await getAthleteElo(
        loserId,
        marketName: marketName,
        sport: sport,
      );

      if (winner == null || loser == null) {
        throw Exception('Athlete not found');
      }

      // Calculate new ELO ratings
      final (newWinnerElo, newLoserElo) = EloCalculator.calculateNewRatings(
        winnerRating: winner.elo,
        loserRating: loser.elo,
      );

      final winnerEloChange = newWinnerElo - winner.elo;
      final loserEloChange = newLoserElo - loser.elo;

      // Create vote record
      final vote = VersusVote(
        matchId: matchId,
        walletAddress: walletAddress,
        winnerId: winnerId,
        loserId: loserId,
        timestamp: DateTime.now(),
        winnerEloChange: winnerEloChange,
        loserEloChange: loserEloChange,
      );

      // Get collection and document references for winner and loser
      final collection = _getCollectionForMarket(marketName: marketName, sport: sport);
      
      final winnerSnapshot = await _fireStore
          .collection(collection)
          .where('athleteId', isEqualTo: winnerId)
          .limit(1)
          .get();
      
      final loserSnapshot = await _fireStore
          .collection(collection)
          .where('athleteId', isEqualTo: loserId)
          .limit(1)
          .get();
      
      if (winnerSnapshot.docs.isEmpty || loserSnapshot.docs.isEmpty) {
        throw Exception('Athlete documents not found');
      }
      
      // Batch update: vote record + both athlete ELOs
      final batch = _fireStore.batch();

      // Add vote record
      final voteRef = _fireStore.collection(_votesCollection).doc();
      batch.set(voteRef, vote.toJson());

      // Update winner
      final winnerRef = winnerSnapshot.docs.first.reference;
      batch.set(
        winnerRef,
        winner
            .copyWith(
              elo: newWinnerElo,
              wins: winner.wins + 1,
              totalBattles: winner.totalBattles + 1,
            )
            .toJson(),
        SetOptions(merge: true),
      );

      // Update loser
      final loserRef = loserSnapshot.docs.first.reference;
      batch.set(
        loserRef,
        loser
            .copyWith(
              elo: newLoserElo,
              losses: loser.losses + 1,
              totalBattles: loser.totalBattles + 1,
            )
            .toJson(),
        SetOptions(merge: true),
      );

      // Commit batch
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to submit vote: $e');
    }
  }

  /// Get vote history for a wallet
  Stream<List<VersusVote>> getUserVotes(String walletAddress) {
    return _fireStore
        .collection(_votesCollection)
        .where('walletAddress', isEqualTo: walletAddress)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VersusVote.fromJson(doc.data()))
              .toList(),
        );
  }

  /// Initialize athlete ELO if not exists (helper method for testing)
  Future<void> initializeAthleteIfNeeded({
    required int athleteId,
    required String athleteName,
    required String sport,
    required String team,
    required String marketName,
  }) async {
    final existing = await getAthleteElo(
      athleteId,
      marketName: marketName,
      sport: sport,
    );
    if (existing == null) {
      await upsertAthleteElo(
        AthleteElo(
          athleteId: athleteId,
          athleteName: athleteName,
          sport: sport,
          team: team,
        ),
        marketName: marketName,
        sport: sport,
      );
    }
  }
}
