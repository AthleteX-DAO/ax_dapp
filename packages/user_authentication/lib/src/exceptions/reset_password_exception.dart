/// {@template send_password_reset_email_failure}
/// Thrown during the reset password process if a failure occurs.
/// {@endtemplate}
class SendPasswordResetFailure implements Exception {
  /// {@macro send_password_reset_failure}
  const SendPasswordResetFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/sendPasswordResetEmail.html
  factory SendPasswordResetFailure.fromCode(String code) {
    switch (code) {
      case 'auth/invalid-email':
        return const SendPasswordResetFailure(
          'Email is not valid or badly formatted.',
        );
      case 'auth/missing-android-pkg-name':
        return const SendPasswordResetFailure(
          'An Android package name must be provided if the Android app is required to be installed.',
        );
      case 'auth/missing-continue-uri':
        return const SendPasswordResetFailure(
          'A continue URL must be provided in the request.',
        );
      case 'auth/missing-ios-bundle-id':
        return const SendPasswordResetFailure(
          'An iOS Bundle ID must be provided if an App Store ID is provided.',
        );
      case 'auth/invalid-continue-uri':
        return const SendPasswordResetFailure(
          'The continue URL provided in the request is invalid.',
        );
      case 'auth/unauthorized-continue-uri':
        return const SendPasswordResetFailure(
          'The domain of the continue URL is not whitelisted. Whitelist the domain in the Firebase console.',
        );
      case 'auth/user-not-found':
        return const SendPasswordResetFailure(
          'No user corresponds to the email address.',
        );
      default:
        return const SendPasswordResetFailure();
    }
  }

  /// The associated error message.
  final String message;
}
