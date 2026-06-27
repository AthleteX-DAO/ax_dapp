import 'package:tracking_repository/src/track_event.dart';

/// Events for the Spot Markets page
class SpotMarketsTrackingEvent extends TrackEvent {
  /// Tracks when a user views a specific spot market
  SpotMarketsTrackingEvent.onSpotMarketView(
    Map<String, dynamic> params,
  ) : super(name: 'spot_market_view', params: params);

  /// Tracks when a user initiates a buy order on the spot market
  SpotMarketsTrackingEvent.onPressedSpotOrderBuy(
    Map<String, dynamic> params,
  ) : super(name: 'spot_order_buy_pressed', params: params);

  /// Tracks when a user initiates a sell order on the spot market
  SpotMarketsTrackingEvent.onPressedSpotOrderSell(
    Map<String, dynamic> params,
  ) : super(name: 'spot_order_sell_pressed', params: params);

  /// Tracks when a spot market order successfully settles on-chain
  SpotMarketsTrackingEvent.onSpotOrderSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'spot_order_success', params: params);
}
