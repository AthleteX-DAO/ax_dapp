import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the trade page
class TradePageUserEvent extends TrackEvent {
  /// Informs tracking services that the swap transaction is confirmed
  TradePageUserEvent.onSwapConfirmedTransaction(
    Map<String, dynamic> params,
  ): super(name: 'swap_success', params: params);
  /// Event for when the approve button is clicked
  TradePageUserEvent.onApproveClick(
    Map<String, dynamic> params,
  ): super(name: 'swap_approve_button_click', params: params);
  /// Event for when the confirm button is clicked
  TradePageUserEvent.onConfirmClick(
    Map<String, dynamic> params,
  ): super(name: 'swap_confirm_button_click', params: params);
}
