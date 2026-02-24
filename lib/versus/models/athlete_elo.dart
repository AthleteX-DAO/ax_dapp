import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// Represents an athlete's ELO rating and battle statistics
class AthleteElo extends Equatable {
  const AthleteElo({
    required this.athleteId,
    required this.athleteName,
    required this.sport,
    required this.team,
    this.elo = 1200.0,
    this.wins = 0,
    this.losses = 0,
    this.totalBattles = 0,
  });

  final int athleteId;
  final String athleteName;
  final String sport;
  final String team;
  final double elo;
  final int wins;
  final int losses;
  final int totalBattles;

  /// Calculate win rate percentage
  double get winRate {
    if (totalBattles == 0) return 0.0;
    return (wins / totalBattles) * 100;
  }

  /// Format wins-losses as "W-L"
  String get record => '$wins-$losses';

  /// Create a copy with updated values
  AthleteElo copyWith({
    int? athleteId,
    String? athleteName,
    String? sport,
    String? team,
    double? elo,
    int? wins,
    int? losses,
    int? totalBattles,
  }) {
    return AthleteElo(
      athleteId: athleteId ?? this.athleteId,
      athleteName: athleteName ?? this.athleteName,
      sport: sport ?? this.sport,
      team: team ?? this.team,
      elo: elo ?? this.elo,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      totalBattles: totalBattles ?? this.totalBattles,
    );
  }

  /// Create from JSON (Firestore document)
  factory AthleteElo.fromJson(Map<String, dynamic> json) {
    return AthleteElo(
      athleteId: json['athleteId'] as int,
      athleteName: json['athleteName'] as String,
      sport: json['sport'] as String,
      team: json['team'] as String,
      elo: (json['elo'] as num?)?.toDouble() ?? 1200.0,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      totalBattles: json['totalBattles'] as int? ?? 0,
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'athleteId': athleteId,
      'athleteName': athleteName,
      'sport': sport,
      'team': team,
      'elo': elo,
      'wins': wins,
      'losses': losses,
      'totalBattles': totalBattles,
    };
  }

  @override
  List<Object?> get props => [
        athleteId,
        athleteName,
        sport,
        team,
        elo,
        wins,
        losses,
        totalBattles,
      ];
}

/// Utility class for ELO rating calculations
class EloCalculator {
  /// K-factor for ELO calculation (higher = more volatile ratings)
  static const double kFactor = 32.0;

  /// Calculate expected score for player A vs player B
  static double expectedScore(double ratingA, double ratingB) {
    return 1 / (1 + math.pow(10, (ratingB - ratingA) / 400));
  }

  /// Calculate new ELO ratings after a match
  /// Returns (newRatingWinner, newRatingLoser)
  static (double, double) calculateNewRatings({
    required double winnerRating,
    required double loserRating,
  }) {
    final expectedWinner = expectedScore(winnerRating, loserRating);
    final expectedLoser = expectedScore(loserRating, winnerRating);

    final newWinnerRating = winnerRating + kFactor * (1 - expectedWinner);
    final newLoserRating = loserRating + kFactor * (0 - expectedLoser);

    return (newWinnerRating, newLoserRating);
  }
}
