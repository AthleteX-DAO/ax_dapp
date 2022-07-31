import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Athlete Page
class AthletePageTrackingEvent extends TrackEvent {
  /// Informs tracking services that buy athlete button was pressed
  AthletePageTrackingEvent.onPressedAthleteBuy() :
        super('athlete_buy');

  /// Informs tracking services that buy athlete button was pressed
  AthletePageTrackingEvent.onPressedConfirmBuy() :
        super('confirm_buy');

  /// Informs tracking services that buy athlete was successful
  AthletePageTrackingEvent.onAthleteBuySuccess() :
        super('buy_success');

  /// Informs tracking services that sell athlete button was pressed
  AthletePageTrackingEvent.onPressedAthleteSell() : super('athlete_Sell');

  /// Informs tracking services that mint pair button was pressed
  AthletePageTrackingEvent.onPressedAthleteMintPair() : super('mint_pair');

  /// Informs tracking services that redeem pair athlete button was pressed
  AthletePageTrackingEvent.onPressedAthleteRedeemPair() : super('redeem_pair');
}
