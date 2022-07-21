import 'package:shared/src/failure/failure.dart';

/// Stream extensions handling `Failure`s.
extension FailureSteamExtensions<T> on Stream<T> {
  /// Handles a [Stream] error of type [Failure]. Optionally an [onFailure]
  /// callback can be invoked allowing for further processing of the failure.
  Stream<T> handleFailure<F extends Failure>([
    void Function(F failure)? onFailure,
  ]) {
    return handleError(
      (Object error) {
        if (error is F) {
          onFailure?.call(error);
        }
      },
    );
  }
}
