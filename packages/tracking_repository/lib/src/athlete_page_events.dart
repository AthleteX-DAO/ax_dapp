import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Athlete Page
class AthletePageTrackingEvent extends TrackEvent {
  /// Informs tracking services that buy athlete button was pressed
  AthletePageTrackingEvent.onPressedAthleteBuy(
    Map<String, dynamic> params,
  ) : super(name: 'buy_approve_button_click', params: params);

  /// Informs tracking services that buy athlete button was pressed
  AthletePageTrackingEvent.onPressedConfirmBuy(
    Map<String, dynamic> params,
  ) : super(name: 'buy_confirm_button_click', params: params);

  /// Informs tracking services that buy athlete was successful
  AthletePageTrackingEvent.onAthleteBuySuccess(
    Map<String, dynamic> params,
  ) : super(name: 'buy_success', params: params);

  /// Informs tracking services that sell athlete button was pressed
  AthletePageTrackingEvent.onPressedAthleteSell(
    Map<String, dynamic> params,
  ) : super(name: 'sell_approve_button_click', params: params);

  /// Informs tracking services that sell athlete button was pressed
  AthletePageTrackingEvent.onPressedConfirmSell(
    Map<String, dynamic> params,
  ) : super(name: 'sell_confirm_button_click', params: params);

  /// Informs tracking services that sell athlete was successful
  AthletePageTrackingEvent.onAthleteSellSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'sell_success', params: params);

  /// Informs tracking services that mint athlete button was pressed
  AthletePageTrackingEvent.onPressedAthleteMint(
    Map<String, dynamic> params,
  ) : super(name: 'mint_approve_button_click', params: params);

  /// Informs tracking services that mint athlete button was pressed
  AthletePageTrackingEvent.onPressedConfirmMint(
    Map<String, dynamic> params,
  ) : super(name: 'mint_confirm_button_click', params: params);

  /// Informs tracking services that mint athlete was successful
  AthletePageTrackingEvent.onAthleteMintSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'mint_success', params: params);

  /// Informs tracking services that redeem athlete was successful
  AthletePageTrackingEvent.onAthleteRedeemSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'redeem_success', params: params);

  /// Informs tracking services that redeem athlete was successful
  AthletePageTrackingEvent.onPressedAddToWallet(
    Map<String, dynamic> params,
  ) : super(name: 'add_to_wallet', params: params);
}
