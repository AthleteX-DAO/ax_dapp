import 'package:ax_dapp/vote/models/models.dart';
import 'package:ax_dapp/vote/repository/exchange_stats_repository.dart';
import 'package:ax_dapp/vote/repository/proposal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vote_event.dart';
part 'vote_state.dart';

/// BLoC for the Vote dashboard — exchange stats + community proposals.
class VoteBloc extends Bloc<VoteEvent, VoteState> {
  VoteBloc({
    required ExchangeStatsRepository exchangeStatsRepository,
    required ProposalRepository proposalRepository,
    required String walletAddress,
  })  : _exchangeStatsRepo = exchangeStatsRepository,
        _proposalRepo = proposalRepository,
        super(VoteState(walletAddress: walletAddress)) {
    on<LoadDashboard>(_onLoadDashboard);
    on<SwitchTab>(_onSwitchTab);
    on<RefreshSectorData>(_onRefreshSectorData);
    on<SubmitProposal>(_onSubmitProposal);
    on<CastVote>(_onCastVote);
  }

  final ExchangeStatsRepository _exchangeStatsRepo;
  final ProposalRepository _proposalRepo;

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<VoteState> emit,
  ) async {
    emit(state.copyWith(status: VotePageStatus.loading));

    try {
      // Fetch all three sectors in parallel
      final results = await Future.wait([
        _exchangeStatsRepo.getSectorStats(ExchangeTab.predictions),
        _exchangeStatsRepo.getSectorStats(ExchangeTab.spot),
        _exchangeStatsRepo.getSectorStats(ExchangeTab.perps),
        _exchangeStatsRepo.getTotalVolume24h(),
        _exchangeStatsRepo.getTotalOpenInterest(),
      ]);

      final predictionStats = results[0] as SectorStats;
      final spotStats = results[1] as SectorStats;
      final perpsStats = results[2] as SectorStats;
      final totalVolume = results[3] as double;
      final totalOI = results[4] as double;

      final sectorMap = <ExchangeTab, SectorStats>{
        ExchangeTab.predictions: predictionStats,
        ExchangeTab.spot: spotStats,
        ExchangeTab.perps: perpsStats,
      };

      // Fetch proposals via stream — take first snapshot
      var proposals = <MarketProposal>[];
      try {
        proposals = await _proposalRepo.getProposals().first;
      } catch (_) {
        // Proposals may fail (e.g. Firestore rules not deployed) — non-blocking
      }

      emit(
        state.copyWith(
          status: VotePageStatus.loaded,
          sectorStats: sectorMap,
          totalVolume24h: totalVolume,
          totalOpenInterest: totalOI,
          proposals: proposals,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VotePageStatus.error,
          errorMessage: 'Failed to load dashboard: $e',
        ),
      );
    }
  }

  Future<void> _onSwitchTab(
    SwitchTab event,
    Emitter<VoteState> emit,
  ) async {
    emit(state.copyWith(selectedTab: event.tab));

    // If sector data is not cached, fetch it
    if (!state.sectorStats.containsKey(event.tab)) {
      try {
        final stats = await _exchangeStatsRepo.getSectorStats(event.tab);
        final updated = Map<ExchangeTab, SectorStats>.from(state.sectorStats)
          ..[event.tab] = stats;
        emit(state.copyWith(sectorStats: updated));
      } catch (e) {
        emit(
          state.copyWith(
            status: VotePageStatus.error,
            errorMessage: 'Failed to load ${event.tab.displayName} data: $e',
          ),
        );
      }
    }
  }

  Future<void> _onRefreshSectorData(
    RefreshSectorData event,
    Emitter<VoteState> emit,
  ) async {
    try {
      final stats =
          await _exchangeStatsRepo.getSectorStats(state.selectedTab);
      final updated = Map<ExchangeTab, SectorStats>.from(state.sectorStats)
        ..[state.selectedTab] = stats;
      emit(state.copyWith(sectorStats: updated));
    } catch (e) {
      emit(
        state.copyWith(
          status: VotePageStatus.error,
          errorMessage: 'Failed to refresh data: $e',
        ),
      );
    }
  }

  Future<void> _onSubmitProposal(
    SubmitProposal event,
    Emitter<VoteState> emit,
  ) async {
    try {
      await _proposalRepo.submitProposal(
        prompt: event.prompt,
        category: event.category,
        details: event.details,
        proposerAddress: state.walletAddress,
      );
      // Refresh proposals
      final proposals = await _proposalRepo.getProposals().first;
      emit(state.copyWith(proposals: proposals));
    } catch (e) {
      emit(
        state.copyWith(
          status: VotePageStatus.error,
          errorMessage: 'Failed to submit proposal: $e',
        ),
      );
    }
  }

  Future<void> _onCastVote(
    CastVote event,
    Emitter<VoteState> emit,
  ) async {
    try {
      await _proposalRepo.castVote(
        proposalId: event.proposalId,
        walletAddress: state.walletAddress,
      );
      // Refresh proposals
      final proposals = await _proposalRepo.getProposals().first;
      emit(state.copyWith(proposals: proposals));
    } catch (e) {
      emit(
        state.copyWith(
          status: VotePageStatus.error,
          errorMessage: 'Failed to cast vote: $e',
        ),
      );
    }
  }
}
