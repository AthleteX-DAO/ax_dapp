import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the trade page
class TradePageUserEvent extends TrackEvent {
  /// Informs tracking services that the swap transaction is confirmed
  TradePageUserEvent.onSwapConfirmedTransaction(): super('swap_success', {});
  /// Event for when the approve button is clicked
  TradePageUserEvent.onApproveClick(): super('swap_approve_button_click', {});
  /// Event for when the confirm button is clicked
  TradePageUserEvent.onConfirmClick(): super('swap_confirm_button_click', {});
}
