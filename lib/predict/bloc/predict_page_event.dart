part of 'predict_page_bloc.dart';

abstract class PredictPageEvent extends Equatable {
  const PredictPageEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends PredictPageEvent {
  const WatchAppDataChangesStarted();
}

class FetchPredictionInfoRequested extends PredictPageEvent {
  const FetchPredictionInfoRequested();
}

class ViewPredictionDetails extends PredictPageEvent {
  const ViewPredictionDetails();
}

class SelectedPredictionMarketsChanged extends PredictPageEvent {
  const SelectedPredictionMarketsChanged({
    required this.selectedMarkets,
  });

  final SupportedPredictionMarkets selectedMarkets;

  @override
  List<Object?> get props => [selectedMarkets];
}

class AllPredictionMarketsRequested extends PredictPageEvent {
  const AllPredictionMarketsRequested();
}

class CollegePredictionMarketsRequested extends PredictPageEvent {
  const CollegePredictionMarketsRequested();
}

class BasketballPredictionMarketsRequested extends PredictPageEvent {
  const BasketballPredictionMarketsRequested();
}

class FootballPredictionMarketsRequested extends PredictPageEvent {
  const FootballPredictionMarketsRequested();
}

class HockeyPredictionMarketsRequested extends PredictPageEvent {
  const HockeyPredictionMarketsRequested();
}

class BaseballPredictionMarketsRequested extends PredictPageEvent {
  const BaseballPredictionMarketsRequested();
}

class SoccerPredictionMarketsRequested extends PredictPageEvent {
  const SoccerPredictionMarketsRequested();
}

class VotedPredictionMarketsRequested extends PredictPageEvent {
  const VotedPredictionMarketsRequested();
}

class ExoticPredictionMarketsRequested extends PredictPageEvent {
  const ExoticPredictionMarketsRequested();
}

class PredictionVisibilityChanged extends PredictPageEvent {
  const PredictionVisibilityChanged({
    required this.predictionId,
    required this.isVisible,
  });

  final int predictionId;
  final bool isVisible;

  @override
  List<Object?> get props => [predictionId, isVisible];
}

/// Event to place a prediction (create YES or NO tokens) on a live prediction market.
class PredictionPlacementRequested extends PredictPageEvent {
  const PredictionPlacementRequested({
    required this.marketAddress,
    required this.axUsdAmount,
    required this.isYes,
  });

  /// On-chain contract address of the prediction market.
  final String marketAddress;

  /// Amount of axUSD to spend (human-readable, e.g. 10.0 = 10 axUSD).
  final double axUsdAmount;

  /// True = YES position, false = NO position.
  /// (Both create equal YES+NO tokens — the user's intent determines
  ///  which token they hold for payout.)
  final bool isYes;

  @override
  List<Object?> get props => [marketAddress, axUsdAmount, isYes];
}

class LiveStreamsFetchRequested extends PredictPageEvent {
  const LiveStreamsFetchRequested();
}
