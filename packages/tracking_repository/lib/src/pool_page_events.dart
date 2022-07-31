import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the trade page
class PoolPageUserEvent extends TrackEvent {
  /// Informs tracking services that the pool transaction 
  /// is confirmed on add liquidity
  PoolPageUserEvent.onPoolCreate(): super('add_liquidity_success');
  /// Informs tracking services when the approve button 
  /// is clicked on add liquidity
  PoolPageUserEvent.onApprovePoolClick()
      : super('add_liquidity_approve_button_click');
  /// Informs tracking services when the confirm button 
  /// is clicked on add liquidity
  PoolPageUserEvent.onConfirmPoolClick()
      : super('add_liquidity_confirm_button_click');
  /// Informs tracking services when the approve button 
  /// is clicked on my liquidity
  PoolPageUserEvent.onRemoveApproveClick()
      : super('remove_liquidity_approve_button_click');
  /// Informs tracking services when the confirm button 
  /// is clicked on my liquidity
  PoolPageUserEvent.onRemoveConfirmClick()
      : super('remove_liquidity_confirm_button_click');
  /// Informs tracking services when the removal transaction 
  /// is clicked on my liquidity
  PoolPageUserEvent.onPoolRemove(): super('remove_liquidity_success');
}
