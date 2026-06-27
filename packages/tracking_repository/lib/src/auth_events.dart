import 'package:tracking_repository/src/track_event.dart';

/// Events for user authentication flows
class AuthTrackingEvent extends TrackEvent {
  /// Tracks when a user presses the sign up button
  AuthTrackingEvent.onSignUpPressed(
    Map<String, dynamic> params,
  ) : super(name: 'sign_up_pressed', params: params);

  /// Tracks when a user successfully creates a new account
  AuthTrackingEvent.onSignUpSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'sign_up_success', params: params);
}
