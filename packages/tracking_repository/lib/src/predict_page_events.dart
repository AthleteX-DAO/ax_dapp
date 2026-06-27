import 'package:tracking_repository/src/track_event.dart';

/// Events for the Prediction Markets page
class PredictPageTrackingEvent extends TrackEvent {
  /// Tracks when a user views a specific prediction market
  PredictPageTrackingEvent.onPressedPredictionView(
    Map<String, dynamic> params,
  ) : super(name: 'prediction_view', params: params);

  /// Tracks when a user initiates a buy (bet) on Yes or No
  PredictPageTrackingEvent.onPressedPredictionBuy(
    Map<String, dynamic> params,
  ) : super(name: 'prediction_buy_pressed', params: params);

  /// Tracks when a prediction buy transaction succeeds on-chain
  PredictPageTrackingEvent.onPredictionBuySuccess(
    Map<String, dynamic> params,
  ) : super(name: 'prediction_buy_success', params: params);

  /// Tracks when a user initiates a sell of their prediction position
  PredictPageTrackingEvent.onPressedPredictionSell(
    Map<String, dynamic> params,
  ) : super(name: 'prediction_sell_pressed', params: params);

  /// Tracks when a prediction sell transaction succeeds on-chain
  PredictPageTrackingEvent.onPredictionSellSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'prediction_sell_success', params: params);
}
