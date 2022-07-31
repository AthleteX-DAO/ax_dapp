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

  /// Updates tracking services accordingly
  void trackPoolCreation(TrackEvent event, 
    String valueOne,
    String valueTwo,
    String lpTokens,
    String shareOfPool,
    String lpTokenName,
  ) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'value_one' : valueOne,
        'value_two' : valueTwo,
        'lp_tokens' : lpTokens,
        'share_of_pool': shareOfPool,
        'lp_token_name': lpTokenName,
      },
    );
    dev.log(event.name);
    // firebase
    // GA
    // tracker?.track...
  }

  /// Updates tracking services when approve button clicked
  void trackPoolApproveClick(TrackEvent event, String currencyOne) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'currency_one': currencyOne,
      },
    );
  }

  /// Updates tracking services when confirm button clicked
  void trackPoolConfirmClick(TrackEvent event, String currencyTwo) {
    _firebase.logEvent(name: event.name,
      parameters: {
        'currency_two': currencyTwo,
      },
    );
  }
}
