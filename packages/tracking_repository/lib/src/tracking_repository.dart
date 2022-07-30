import 'dart:developer' as dev;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:tracking_repository/src/track_event.dart';

/// Used to interface tracking services
class TrackingRepository {
  /// Default construcot
  TrackingRepository({
    FirebaseAnalytics? firebase,
  }) : _firebase = firebase ?? FirebaseAnalytics.instance ;

  /// Update to configure with relevant trackers
  final FirebaseAnalytics _firebase;

  ///
  /// Packages/trackers may have additional lifecycle requirements.
  /// These methods like id/reset/consent and other ones should be handled here.
  ///

  /// Updates tracking services accordingly
  void track(TrackEvent event) {
    _firebase.logEvent(name: event.name);    
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }

  /// Get athlete buy information for analytics
  void trackAthleteBuy(TrackEvent event, String athleteName, int id ) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'athlete_name': athleteName,
        'athlete_id': id
        },
    );
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }

  /// Get athlete buy information for analytics
  void trackAthleteView(TrackEvent event, String athleteName) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'athlete_name': athleteName,
      },
    );
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }
}
