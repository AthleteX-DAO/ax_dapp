import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Athlete Page
class MarketsPageTrackingEvent extends TrackEvent {
  /// Informs tracking services that wallet was connected successfully
  MarketsPageTrackingEvent.onConnectWalletSuccessful(
    Map<String, dynamic> params,
  ) : super(name: 'wallet_connection_success', params: params);

  /// Informs tracking services that the user requested to connect a wallet
  MarketsPageTrackingEvent.onConnectWalletPressed(
    Map<String, dynamic> params,
  ) : super(name: 'connect_wallet', params: params);

  /// Informs tracking services that view athlete button was pressed
  MarketsPageTrackingEvent.onPressedAthleteView(
    Map<String, dynamic> params,
  ) : super(name: 'view_athlete', params: params);
}
