part of 'predict_page_bloc.dart';

class PredictPageState extends Equatable {
  const PredictPageState({
    this.status = BlocStatus.initial,
    this.predictions = const [],
    this.selectedMarket = SupportedPredictionMarkets.all,
    this.filteredPredictions = const [],
    this.selectedChain = EthereumChain.polygonMainnet,
  });

  final List<PredictionModel> predictions;
  final List<PredictionModel> filteredPredictions;
  final SupportedPredictionMarkets selectedMarket;

  final EthereumChain selectedChain;
  final BlocStatus status;

  PredictPageState copyWith({
    List<PredictionModel>? predictions,
    List<PredictionModel>? filteredPredictions,
    SupportedPredictionMarkets? selectedMarket,
    EthereumChain? selectedChain,
    BlocStatus? status,
  }) {
    return PredictPageState(
      predictions: predictions ?? this.predictions,
      filteredPredictions: filteredPredictions ?? this.filteredPredictions,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      selectedChain: selectedChain ?? this.selectedChain,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        predictions,
        filteredPredictions,
        selectedMarket,
        selectedChain,
        status,
      ];
}
