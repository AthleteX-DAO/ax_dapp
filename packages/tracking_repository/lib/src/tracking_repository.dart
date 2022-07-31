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

  /// Updates tracking services when the user has approved a swap
  void trackTradeApproval(
      TrackEvent event,
      String fromUnits,
      String toUnits,
      String totalFee,
      String walletID,) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'from_units': fromUnits,
        'to_units': toUnits,
        'fee': totalFee,
        'wallet_id': walletID,
      },
    );    
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }

  /// Updates tracking services when the user has clicked the approve button
  void trackTradeApproveClick(
      TrackEvent event,
      String fromCurrency,) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'from_currency': fromCurrency
      },
    );    
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }
  
  /// Updates tracking services when the user has clicked the approve button
  void trackTradeConfirmClick(
      TrackEvent event,
      String toCurrency,) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'to_currency': toCurrency
      },
    );    
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }
}
