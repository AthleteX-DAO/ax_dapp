part of 'predict_page_bloc.dart';

abstract class PredictPageEvent extends Equatable {
  const PredictPageEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends PredictPageEvent {
  const WatchAppDataChangesStarted();
}

class FetchPredictInfoRequested extends PredictPageEvent {
  const FetchPredictInfoRequested();
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
