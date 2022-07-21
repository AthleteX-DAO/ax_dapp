export 'failure_extensions.dart';

/// {@template failure}
/// Base class for all failures.
/// {@endtemplate}
abstract class Failure implements Exception {
  /// {@macro failure}
  const Failure(
    this.exception,
    this.stackTrace,
  );

  /// {@macro no_failure}
  static const none = NoFailure();

  /// Stores the original exception.
  final Object exception;

  /// Stores the original `StackTrace`.
  final StackTrace stackTrace;
}

/// {@template no_failure}
/// Represents no failure. Useful as default value on a bloc's state class.
/// {@endtemplate}
class NoFailure extends Failure {
  /// {@macro no_failure}
  const NoFailure() : super(Null, StackTrace.empty);
}
