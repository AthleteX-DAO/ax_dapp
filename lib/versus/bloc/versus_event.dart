part of 'versus_bloc.dart';

/// Base class for versus events
sealed class VersusEvent extends Equatable {
  const VersusEvent();

  @override
  List<Object?> get props => [];
}

/// Load a new matchup
final class LoadMatchupRequested extends VersusEvent {
  const LoadMatchupRequested({
    required this.marketName,
    this.sport,
  });

  final String marketName;
  final String? sport;

  @override
  List<Object?> get props => [marketName, sport];
}

/// Submit a vote for an athlete
final class VoteSubmitted extends VersusEvent {
  const VoteSubmitted({
    required this.walletAddress,
    required this.winnerId,
    required this.loserId,
  });

  final String walletAddress;
  final int winnerId;
  final int loserId;

  @override
  List<Object?> get props => [walletAddress, winnerId, loserId];
}

/// Request next matchup
final class NextMatchupRequested extends VersusEvent {
  const NextMatchupRequested({
    required this.marketName,
    this.sport,
  });

  final String marketName;
  final String? sport;

  @override
  List<Object?> get props => [marketName, sport];
}

/// Toggle leaderboard visibility
final class LeaderboardRequested extends VersusEvent {
  const LeaderboardRequested({required this.show});

  final bool show;

  @override
  List<Object?> get props => [show];
}
