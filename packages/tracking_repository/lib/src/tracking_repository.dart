import 'package:tracking_repository/src/event.dart';

/// Used to interface tracking services
class TrackingRepository {
  /// final Tracker? tracker;
  /// Loads trackers
  /// void configureWith(
  ///   // firebase
  ///   // GA
  ///   // amplitude
  ///   // mixpanel
  ///   // ...
  /// ) {
  ///    this.trakingService = trakingService
  /// }

  ///
  /// Packages/trackers may have additional lifecycle requirements.
  /// These methods like id/reset/consent and other ones should be handled here.
  ///

  /// Updates tracking services accordingly
  void track(Event event) {
    // firebase
    // GA
    // tracker?.track...
  }
}

/// Should be deleted after first events are implemented.
/// Only for demo.
// class FeatureExample {
//   void blueScreen() {
//     TrackingRepository.instance.track(SomeFeature.screenA({'param': value}));
//   }
// }
