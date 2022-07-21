import 'package:ax_dapp/analytics/event.dart';

class AnalyticsService {
  AnalyticsService._();

  /// Default instance of the analytics
  static final instance = AnalyticsService._();

  /// final Tracker? trakingService;
  /// Loads trackers
  /// void configureWith(
  ///   // firebase
  ///   // aplitude
  ///   // trakingService
  ///   // ....
  /// ) {
  ///    this.trakingService = trakingService
  /// }

  ///
  /// Packages/trackers may have additional lifecycle requirements.
  /// These methods like reset and other ones should be handled here.
  ///

  /// Updates tracking services accordingly
  void track(Event event) {}
}

/// Should be deleted after first events are implemented.
/// Only for demo.
// class FeatureExample {
//   void blueScreen() {
//     AnalyticsService.instance.track(SomeFeature.screenA({'param': value}));
//   }
// }
