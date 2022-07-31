import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the trade page
class PoolPageUserEvent extends TrackEvent {
  /// Informs tracking services that the pool transaction is confirmed
  PoolPageUserEvent.onPoolCreate(): super('add_liquidity_success');
  /// Informs tracking services when the approve button is clicked
  PoolPageUserEvent.onApprovePoolClick()
      : super('add_liquidity_approve_button_click');
  /// Informs tracking services when the confirm button is clicked
  PoolPageUserEvent.onConfirmPoolClick()
      : super('add_liquidity_confirm_button_click');
}
