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

class PredictionPageLoaded extends PredictionPageEvent {
  const PredictionPageLoaded({required this.predictionAddress});
  final String predictionAddress;

  @override
  List<Object?> get props => [predictionAddress];
}
