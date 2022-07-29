import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Athlete Page
class ScoutPageTrackingEvent extends TrackEvent {
  /// Informs tracking services that buy athlete button was pressed
  ScoutPageTrackingEvent.onPressedConnectWallet() : super('connect_wallet');

  /// Informs tracking services that view athlete button was pressed
  ScoutPageTrackingEvent.onPressedAthleteView() : super('view_athlete');

}
