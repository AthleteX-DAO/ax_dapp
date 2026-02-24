import 'package:ax_dapp/versus/models/versus_match_model.dart';
import 'package:ax_dapp/versus/repository/versus_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'versus_event.dart';
part 'versus_state.dart';

/// BLoC for managing versus battles and matchups
class VersusBloc extends Bloc<VersusEvent, VersusState> {
  VersusBloc({
    required VersusRepository versusRepository,
  })  : _versusRepository = versusRepository,
        super(const VersusState()) {
    on<LoadMatchupRequested>(_onLoadMatchupRequested);
    on<VoteSubmitted>(_onVoteSubmitted);
    on<NextMatchupRequested>(_onNextMatchupRequested);
    on<LeaderboardRequested>(_onLeaderboardRequested);
  }

  final VersusRepository _versusRepository;

  Future<void> _onLoadMatchupRequested(
    LoadMatchupRequested event,
    Emitter<VersusState> emit,
  ) async {
    print('[VersusBloc] LoadMatchupRequested: market=${event.marketName}, sport=${event.sport}');
    emit(state.copyWith(status: VersusStatus.loading));

    try {
      final matchup = await _versusRepository.generateMatchup(
        marketName: event.marketName,
        sport: event.sport,
      );

      if (matchup == null) {
        print('[VersusBloc] Failed to generate matchup — null returned');
        emit(
          state.copyWith(
            status: VersusStatus.error,
            errorMessage: 'Failed to generate matchup',
          ),
        );
        return;
      }

      print('[VersusBloc] Matchup loaded: ${matchup.athlete1.athleteName} vs ${matchup.athlete2.athleteName} (matchId=${matchup.matchId})');
      emit(
        state.copyWith(
          status: VersusStatus.loaded,
          currentMatch: matchup,
          marketName: event.marketName,
        ),
      );
    } catch (e) {
      print('[VersusBloc] LoadMatchup error: $e');
      emit(
        state.copyWith(
          status: VersusStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onVoteSubmitted(
    VoteSubmitted event,
    Emitter<VersusState> emit,
  ) async {
    if (state.currentMatch == null) return;

    print('[VersusBloc] VoteSubmitted: winner=${event.winnerId}, loser=${event.loserId}, wallet=${event.walletAddress.isEmpty ? "(anonymous)" : event.walletAddress}');
    emit(state.copyWith(status: VersusStatus.submittingVote));

    try {
      // Haptic feedback for premium feel
      await HapticFeedback.mediumImpact();

      // Submit vote to repository with market context
      await _versusRepository.submitVote(
        matchId: state.currentMatch!.matchId,
        walletAddress: event.walletAddress,
        winnerId: event.winnerId,
        loserId: event.loserId,
        marketName: state.marketName,
        sport: state.selectedSport,
      );

      print('[VersusBloc] Vote confirmed for winner=${event.winnerId}');

      // Show vote confirmed state briefly
      emit(
        state.copyWith(
          status: VersusStatus.voteConfirmed,
          lastVoteWinnerId: event.winnerId,
        ),
      );

      // Wait for animation
      await Future<void>.delayed(const Duration(milliseconds: 800));

      // Auto-load next matchup
      print('[VersusBloc] Loading next matchup after vote...');
      add(
        NextMatchupRequested(
          marketName: state.marketName,
          sport: state.selectedSport,
        ),
      );
    } catch (e) {
      print('[VersusBloc] Vote submission error: $e');
      emit(
        state.copyWith(
          status: VersusStatus.error,
          errorMessage: 'Failed to submit vote: $e',
        ),
      );
    }
  }

  Future<void> _onNextMatchupRequested(
    NextMatchupRequested event,
    Emitter<VersusState> emit,
  ) async {
    print('[VersusBloc] NextMatchupRequested: market=${event.marketName}, sport=${event.sport}');
    emit(state.copyWith(status: VersusStatus.loading));

    try {
      final matchup = await _versusRepository.generateMatchup(
        marketName: event.marketName,
        sport: event.sport,
      );

      if (matchup == null) {
        print('[VersusBloc] Failed to generate next matchup — null returned');
        emit(
          state.copyWith(
            status: VersusStatus.error,
            errorMessage: 'Failed to generate next matchup',
          ),
        );
        return;
      }

      print('[VersusBloc] Next matchup loaded: ${matchup.athlete1.athleteName} vs ${matchup.athlete2.athleteName}');
      emit(
        state.copyWith(
          status: VersusStatus.loaded,
          currentMatch: matchup,
          lastVoteWinnerId: null,
        ),
      );
    } catch (e) {
      print('[VersusBloc] NextMatchup error: $e');
      emit(
        state.copyWith(
          status: VersusStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLeaderboardRequested(
    LeaderboardRequested event,
    Emitter<VersusState> emit,
  ) async {
    // Leaderboard is handled by stream in widget
    // This event can be used to trigger refresh if needed
    emit(state.copyWith(showLeaderboard: event.show));
  }
}
