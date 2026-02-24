import 'package:ax_dapp/versus/models/athlete_elo.dart';
import 'package:equatable/equatable.dart';

/// Represents a head-to-head matchup between two athletes
class VersusMatchModel extends Equatable {
  const VersusMatchModel({
    required this.matchId,
    required this.athlete1,
    required this.athlete2,
    required this.marketName,
    this.totalVotes = 0,
    this.athlete1Votes = 0,
    this.athlete2Votes = 0,
  });

  final String matchId;
  final AthleteElo athlete1;
  final AthleteElo athlete2;
  final String marketName; // e.g., "Battle for the Top Rank"
  final int totalVotes;
  final int athlete1Votes;
  final int athlete2Votes;

  /// Calculate vote percentage for athlete 1
  double get athlete1VotePercent {
    if (totalVotes == 0) return 50.0;
    return (athlete1Votes / totalVotes) * 100;
  }

  /// Calculate vote percentage for athlete 2
  double get athlete2VotePercent {
    if (totalVotes == 0) return 50.0;
    return (athlete2Votes / totalVotes) * 100;
  }

  /// Check if athletes are in similar ELO range (within 200 points)
  bool get isBalanced {
    return (athlete1.elo - athlete2.elo).abs() <= 200;
  }

  VersusMatchModel copyWith({
    String? matchId,
    AthleteElo? athlete1,
    AthleteElo? athlete2,
    String? marketName,
    int? totalVotes,
    int? athlete1Votes,
    int? athlete2Votes,
  }) {
    return VersusMatchModel(
      matchId: matchId ?? this.matchId,
      athlete1: athlete1 ?? this.athlete1,
      athlete2: athlete2 ?? this.athlete2,
      marketName: marketName ?? this.marketName,
      totalVotes: totalVotes ?? this.totalVotes,
      athlete1Votes: athlete1Votes ?? this.athlete1Votes,
      athlete2Votes: athlete2Votes ?? this.athlete2Votes,
    );
  }

  @override
  List<Object?> get props => [
        matchId,
        athlete1,
        athlete2,
        marketName,
        totalVotes,
        athlete1Votes,
        athlete2Votes,
      ];
}

/// Represents a vote in a versus battle
class VersusVote extends Equatable {
  const VersusVote({
    required this.matchId,
    required this.walletAddress,
    required this.winnerId,
    required this.loserId,
    required this.timestamp,
    this.winnerEloChange = 0.0,
    this.loserEloChange = 0.0,
  });

  final String matchId;
  final String walletAddress;
  final int winnerId;
  final int loserId;
  final DateTime timestamp;
  final double winnerEloChange;
  final double loserEloChange;

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'walletAddress': walletAddress,
      'winnerId': winnerId,
      'loserId': loserId,
      'timestamp': timestamp.toIso8601String(),
      'winnerEloChange': winnerEloChange,
      'loserEloChange': loserEloChange,
    };
  }

  factory VersusVote.fromJson(Map<String, dynamic> json) {
    return VersusVote(
      matchId: json['matchId'] as String,
      walletAddress: json['walletAddress'] as String,
      winnerId: json['winnerId'] as int,
      loserId: json['loserId'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      winnerEloChange: (json['winnerEloChange'] as num?)?.toDouble() ?? 0.0,
      loserEloChange: (json['loserEloChange'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        matchId,
        walletAddress,
        winnerId,
        loserId,
        timestamp,
        winnerEloChange,
        loserEloChange,
      ];
}
