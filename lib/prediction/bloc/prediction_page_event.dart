part of 'prediction_page_bloc.dart';

abstract class PredictionPageEvent extends Equatable {
  const PredictionPageEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends PredictionPageEvent {
  const WatchAppDataChangesStarted();
}

class MintPredictionTokens extends PredictionPageEvent {
  const MintPredictionTokens();
}

class RedeemPredictionTokens extends PredictionPageEvent {
  const RedeemPredictionTokens();
}

class BuyPredictionTokens extends PredictionPageEvent {
  const BuyPredictionTokens();
}

class SellPredictionTokens extends PredictionPageEvent {
  const SellPredictionTokens();
}

class LoadingPredictionPage extends PredictionPageEvent {
  const LoadingPredictionPage();
}

class PredictionPageLoaded extends PredictionPageEvent {
  const PredictionPageLoaded({required this.predictionModel});
  final PredictionModel predictionModel;

  @override
  List<Object?> get props => [predictionModel];
}

class LoadMarketAddress extends PredictionPageEvent {}

class ToggleAdvanceFeatures extends PredictionPageEvent {}

class SelectedMarketsChanged extends MarketsPageEvent {
  const SelectedMarketsChanged({
    required this.selectedMarkets,
  });

  final SupportedPredictionMarkets selectedMarkets;

  @override
  List<Object?> get props => [selectedMarkets];
}
