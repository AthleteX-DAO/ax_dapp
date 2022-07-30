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
      String fromCurrency,
      String toCurrency,
      String fromUnits,
      String toUnits,
      String totalFee,
      String walletID,) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'from_currency': fromCurrency,
        'to_currency': toCurrency,
        'from_units': fromUnits,
        'to_units': toUnits,
        'total_fee': totalFee,
        'wallet_id': walletID,
      },
    );    
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }
}
