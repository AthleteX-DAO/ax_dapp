import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Landing Page
class LandingPageEvent extends TrackEvent {
  /// Informs tracking services that start trading button was pressed
  LandingPageEvent.onPressedStartTrading() : super('start_trading', {});
}
