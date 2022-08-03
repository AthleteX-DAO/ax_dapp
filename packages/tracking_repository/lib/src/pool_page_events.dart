import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the trade page
class PoolPageUserEvent extends TrackEvent {
  /// Informs tracking services that the pool transaction 
  /// is confirmed on add liquidity
  PoolPageUserEvent.onPoolCreate(
    Map<String, dynamic> params,
  ): super(name: 'add_liquidity_success', params: params);
  /// Informs tracking services when the approve button 
  /// is clicked on add liquidity
  PoolPageUserEvent.onApprovePoolClick(
    Map<String, dynamic> params,
  )
      : super(name: 'add_liquidity_approve_button_click', params: params);
  /// Informs tracking services when the confirm button 
  /// is clicked on add liquidity
  PoolPageUserEvent.onConfirmPoolClick(
    Map<String, dynamic> params,
  )
      : super(name: 'add_liquidity_confirm_button_click', params: params);
  /// Informs tracking services when the approve button 
  /// is clicked on my liquidity
  PoolPageUserEvent.onRemoveApproveClick(
    Map<String, dynamic> params,
  )
      : super(name: 'remove_liquidity_approve_button_click', params: params);
  /// Informs tracking services when the confirm button 
  /// is clicked on my liquidity
  PoolPageUserEvent.onRemoveConfirmClick(
    Map<String, dynamic> params,
  )
      : super(name: 'remove_liquidity_confirm_button_click', params: params);
  /// Informs tracking services when the removal transaction 
  /// is clicked on my liquidity
  PoolPageUserEvent.onPoolRemove(
    Map<String, dynamic> params,
  ): super(name: 'remove_liquidity_success', params: params);
}
