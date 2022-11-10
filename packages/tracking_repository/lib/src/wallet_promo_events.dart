import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Athlete Page
class WalletPromoTrackingEvent extends TrackEvent {
  /// Informs tracking services that the user clicked
  /// on the Discord link in the wallet promotion dialog
  WalletPromoTrackingEvent.onDiscordLinkClicked(
    Map<String, dynamic> params,
  ) : super(name: 'promo_discord_link_clicked', params: params);
}
