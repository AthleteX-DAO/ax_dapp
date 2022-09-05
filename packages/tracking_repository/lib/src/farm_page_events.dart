import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Athlete Page
class FarmPageTrackingEvent extends TrackEvent {
  /// Informs tracking services that stake button was pressed
  FarmPageTrackingEvent.onPressedStake(
    Map<String, dynamic> params,
  ) : super(name: 'stake_approve_button_click', params: params);

  /// Informs tracking services that confirmed stake
  FarmPageTrackingEvent.onPressedStakeConfirm(
    Map<String, dynamic> params,
  ) : super(name: 'stake_confirm_button_click', params: params);

  /// Informs tracking services that stake was successful
  FarmPageTrackingEvent.onStakeSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'stake_success', params: params);

  /// Informs tracking services that claim rewards button pressed
  FarmPageTrackingEvent.onPressedClaimRewards(
    Map<String, dynamic> params,
  ) : super(name: 'claim_rewards_button_click', params: params);

  /// Informs tracking services that claim rewards button pressed
  FarmPageTrackingEvent.onClaimRewardsSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'claim_rewards_success', params: params);

  /// Informs tracking services that UnStake button pressed
  FarmPageTrackingEvent.onPressedUnStake(
    Map<String, dynamic> params,
  ) : super(name: 'unstake_approve_button_click', params: params);

  /// Informs tracking services that UnStake confirm button was pressed
  FarmPageTrackingEvent.onPressedUnStakeConfirm(
    Map<String, dynamic> params,
  ) : super(name: 'unstake_confirm_button_click', params: params);

  /// Informs tracking services that UnStake was successful
  FarmPageTrackingEvent.onUnStakeSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'unstake_success', params: params);
}
