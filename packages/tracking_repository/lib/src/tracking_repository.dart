import 'dart:developer' as dev;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:tracking_repository/src/track_event.dart';

/// Used to interface tracking services
class TrackingRepository {
  /// Default construcot
  TrackingRepository({
    required this.firebase,
  });

  /// Update to configure with relevant trackers
  final FirebaseAnalytics firebase;

  ///
  /// Packages/trackers may have additional lifecycle requirements.
  /// These methods like id/reset/consent and other ones should be handled here.
  ///

  /// Updates tracking services accordingly
  void track(TrackEvent event) {
    firebase.logEvent(name: event.name);
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }
}
