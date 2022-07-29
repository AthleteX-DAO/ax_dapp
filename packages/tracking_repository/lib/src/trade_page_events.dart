import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the trade page
class TradePageUserEvent extends TrackEvent {
  /// Informs tracking services that the swap transaction is confirmed
  TradePageUserEvent.onSwapConfirmedTransaction(): super('trade_confirmed');
}
