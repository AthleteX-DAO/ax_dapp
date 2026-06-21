part of 'predict_page_bloc.dart';

class PredictPageState extends Equatable {
  const PredictPageState({
    this.status = BlocStatus.initial,
    this.predictions = const [],
    this.selectedMarket = SupportedPredictionMarkets.all,
    this.filteredPredictions = const [],
    this.selectedChain = EthereumChain.none,
    this.visiblePredictionIds = const {},
    this.activeStreams = const [],
  });

  final List<PredictionModel> predictions;
  final List<PredictionModel> filteredPredictions;
  final SupportedPredictionMarkets selectedMarket;
  final EthereumChain selectedChain;
  final BlocStatus status;
  
  /// Set of prediction IDs currently visible on screen for efficient rendering
  final Set<int> visiblePredictionIds;

  /// Active livestreams to display in the carousel and grid.
  final List<LiveStreamModel> activeStreams;

  /// The featured stream for the hero carousel (first live + featured).
  LiveStreamModel? get featuredStream {
    try {
      return activeStreams.firstWhere((s) => s.isFeatured && s.isLive);
    } catch (_) {
      return null;
    }
  }

  /// Streams suitable for grid interleaving (live, not featured).
  List<LiveStreamModel> get gridStreams =>
      activeStreams.where((s) => s.isLive).toList();

  PredictPageState copyWith({
    List<PredictionModel>? predictions,
    List<PredictionModel>? filteredPredictions,
    SupportedPredictionMarkets? selectedMarket,
    EthereumChain? selectedChain,
    BlocStatus? status,
    Set<int>? visiblePredictionIds,
    List<LiveStreamModel>? activeStreams,
  }) {
    return PredictPageState(
      predictions: predictions ?? this.predictions,
      filteredPredictions: filteredPredictions ?? this.filteredPredictions,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      selectedChain: selectedChain ?? this.selectedChain,
      status: status ?? this.status,
      visiblePredictionIds: visiblePredictionIds ?? this.visiblePredictionIds,
      activeStreams: activeStreams ?? this.activeStreams,
    );
  }

  @override
  List<Object?> get props => [
        predictions,
        filteredPredictions,
        selectedMarket,
        selectedChain,
        status,
        visiblePredictionIds,
        activeStreams,
      ];
}
