import 'dart:async';
import 'dart:developer' as dev;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:tracking_repository/src/track_event.dart';

/// Used to interface tracking services
class TrackingRepository {
  /// Default construcot
  TrackingRepository({
    FirebaseAnalytics? firebase,
  }) : _firebase = firebase ?? FirebaseAnalytics.instance;

  /// Update to configure with relevant trackers
  final FirebaseAnalytics _firebase;

  /// Will add events containg the complet updated list of events
  Stream<List<TrackEvent>> get loggedEventsStream =>
      _loggedEventsController.stream.asBroadcastStream();
  final _loggedEventsController = StreamController<List<TrackEvent>>();
  final _loggedEvents = <TrackEvent>[];

  void _updateLoggedEvents(TrackEvent event) {
    _loggedEvents.insert(0, event);
    _loggedEventsController.add(_loggedEvents);
  }

  ///
  /// Packages/trackers may have additional lifecycle requirements.
  /// These methods like id/reset/consent and other ones should be handled here.
  ///
  ///
  /// Updates tracking services accordingly
  void track(TrackEvent event) {
    _firebase.logEvent(
      name: event.name,
      parameters: event.params,
    );
    dev.log(event.name);
    _updateLoggedEvents(event);
  }
}
