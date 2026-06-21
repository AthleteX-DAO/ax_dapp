part of 'vote_bloc.dart';

/// Status of the vote dashboard page.
enum VotePageStatus { initial, loading, loaded, error }

/// State for the vote dashboard.
final class VoteState extends Equatable {
  const VoteState({
    this.selectedTab = ExchangeTab.predictions,
    this.sectorStats = const {},
    this.totalVolume24h = 0,
    this.totalOpenInterest = 0,
    this.proposals = const [],
    this.status = VotePageStatus.initial,
    this.errorMessage = '',
    this.walletAddress = '',
  });

  final ExchangeTab selectedTab;
  final Map<ExchangeTab, SectorStats> sectorStats;
  final double totalVolume24h;
  final double totalOpenInterest;
  final List<MarketProposal> proposals;
  final VotePageStatus status;
  final String errorMessage;
  final String walletAddress;

  /// Convenience getter for the stats of the currently selected tab.
  SectorStats get currentSectorStats =>
      sectorStats[selectedTab] ?? SectorStats.empty(selectedTab);

  VoteState copyWith({
    ExchangeTab? selectedTab,
    Map<ExchangeTab, SectorStats>? sectorStats,
    double? totalVolume24h,
    double? totalOpenInterest,
    List<MarketProposal>? proposals,
    VotePageStatus? status,
    String? errorMessage,
    String? walletAddress,
  }) {
    return VoteState(
      selectedTab: selectedTab ?? this.selectedTab,
      sectorStats: sectorStats ?? this.sectorStats,
      totalVolume24h: totalVolume24h ?? this.totalVolume24h,
      totalOpenInterest: totalOpenInterest ?? this.totalOpenInterest,
      proposals: proposals ?? this.proposals,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }

  @override
  List<Object?> get props => [
        selectedTab,
        sectorStats,
        totalVolume24h,
        totalOpenInterest,
        proposals,
        status,
        errorMessage,
        walletAddress,
      ];
}
