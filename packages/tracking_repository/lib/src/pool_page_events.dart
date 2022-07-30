import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the trade page
class PoolPageUserEvent extends TrackEvent {
  /// Informs tracking services that the swap transaction is confirmed
  PoolPageUserEvent.onPoolCreate(): super('pool_created');
}
