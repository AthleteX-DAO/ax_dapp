import 'package:tracking_repository/src/track_event.dart';

/// Default events available on the Landing Page
class LandingPageEvent extends TrackEvent {
  /// Informs tracking services that start trading button was pressed
  LandingPageEvent.onPressedStartTrading(
    Map<String, dynamic> params,
  ) : super(name: 'start_trading', params: params);

  /// Informs tracking services that the user is on the landing page
  LandingPageEvent.onLandingPageView(
    Map<String, dynamic> params,
  ) : super(name: 'landing_page_view', params: params);
}
