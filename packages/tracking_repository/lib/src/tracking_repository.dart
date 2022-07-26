import 'package:tracking_repository/src/track_event.dart';

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
  /// ) {dart analyze
  ///    this.trakingService = trakingService
  /// }

  ///
  /// Packages/trackers may have additional lifecycle requirements.
  /// These methods like id/reset/consent and other ones should be handled here.
  ///

  /// Updates tracking services accordingly
  void track(TrackEvent event) {
    // firebase
    // GA
    // tracker?.track...
  }
}

/// Only for demo
// class TrackingCubit extends Cubit<void> {
//   //// Setup
//   /// ...
//   /// 
// 
//   /// Will notify analytics trackes of ...
//   void trackBlueScreen(Map<String, dynamic> params) =>
//       instanceOfTrackingRepository.track(SomeFeature.blueScreen(params..));
