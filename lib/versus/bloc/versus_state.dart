part of 'versus_bloc.dart';

/// Status of versus battle state
enum VersusStatus {
  initial,
  loading,
  loaded,
  submittingVote,
  voteConfirmed,
  error,
}

/// State for versus battles
final class VersusState extends Equatable {
  const VersusState({
    this.status = VersusStatus.initial,
    this.currentMatch,
    this.marketName = 'Who is the #1 Ranked Athlete?',
    this.selectedSport,
    this.errorMessage,
    this.lastVoteWinnerId,
    this.showLeaderboard = false,
  });

  final VersusStatus status;
  final VersusMatchModel? currentMatch;
  final String marketName;
  final String? selectedSport;
  final String? errorMessage;
  final int? lastVoteWinnerId;
  final bool showLeaderboard;

  VersusState copyWith({
    VersusStatus? status,
    VersusMatchModel? currentMatch,
    String? marketName,
    String? selectedSport,
    String? errorMessage,
    int? lastVoteWinnerId,
    bool? showLeaderboard,
  }) {
    return VersusState(
      status: status ?? this.status,
      currentMatch: currentMatch ?? this.currentMatch,
      marketName: marketName ?? this.marketName,
      selectedSport: selectedSport ?? this.selectedSport,
      errorMessage: errorMessage ?? this.errorMessage,
      lastVoteWinnerId: lastVoteWinnerId,
      showLeaderboard: showLeaderboard ?? this.showLeaderboard,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentMatch,
        marketName,
        selectedSport,
        errorMessage,
        lastVoteWinnerId,
        showLeaderboard,
      ];
}
