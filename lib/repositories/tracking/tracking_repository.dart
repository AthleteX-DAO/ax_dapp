import 'package:ax_dapp/repositories/tracking/event.dart';

/// 
class TrackingRepository {
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
  /// These methods like id/reset/consent and other ones should be handled here.
  ///

  /// Updates tracking services accordingly
  void track(Event event) {
    // firebase
    // GA
    // trackingService
  }
}

/// Should be deleted after first events are implemented.
/// Only for demo.
// class FeatureExample {
//   void blueScreen() {
//     TrackingRepository.instance.track(SomeFeature.screenA({'param': value}));
//   }
// }
