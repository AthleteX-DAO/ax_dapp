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

  /// Get athlete info when buy button clicked for analytics
  void trackAthleteBuyApproveButtonClicked(
      TrackEvent event, String athleteName, ) {
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
  /// Get athlete info when buy button clicked for analytics
  void trackAthleteBuyConfirmButtonClicked(
      TrackEvent event,int id, ) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'athlete_id': id
      },
    );
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }

  /// Get athlete info when buy button clicked for analytics
  void trackAthleteBuySuccess(
    TrackEvent event,
    String buyPosition,
    String unit,
    String currencySpent,
    String currency,
    double totalFee,
    String sport,
    String walletId,
  ) {
    _firebase.logEvent(
      name: event.name,
      parameters: {
        'athlete_buy_position': buyPosition,
        'apt_unit': unit,
        'currency_spent': currencySpent,
        'currency': currency,
        'total_fee': totalFee,
        'sport': sport,
        'wallet_id': walletId
      },
    );
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }

  /// Get athlete view information for analytics
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
