import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Athlete Page
class ScoutPageTrackingEvent extends TrackEvent {
  /// Informs tracking services that wallet was connected successfully
  ScoutPageTrackingEvent.onConnectWalletSuccessful(
    Map<String, dynamic> params,
  ) : super(name: 'wallet_connection_success', params: params);

  /// Informs tracking services that the user requested to connect a wallet
  ScoutPageTrackingEvent.onConnectWalletPressed(
    Map<String, dynamic> params,
  ) : super(name: 'connect_wallet', params: params);

  /// Informs tracking services that view athlete button was pressed
  ScoutPageTrackingEvent.onPressedAthleteView(
    Map<String, dynamic> params,
  ) : super(name: 'view_athlete', params: params);
}
