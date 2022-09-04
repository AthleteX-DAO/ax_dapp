// // ignore_for_file: prefer_const_constructors
//
// import 'package:shared/shared.dart';
// import 'package:test/expect.dart';
// import 'package:test/scaffolding.dart';
//
// class TestFailure extends Failure {
//   TestFailure(super.exception, super.stackTrace);
// }
//
// void main() {
//   group('Failure', () {
//     const exceptionMessage = 'exception message';
//     const stackTraceString = 'stack trace string';
//
//     test('can be instantiated', () {
//       expect(TestFailure(Exception(), StackTrace.empty), isNotNull);
//     });
//
//     test('correctly sets exception and stackTrace', () {
//       final failure = TestFailure(
//         Exception(exceptionMessage),
//         StackTrace.fromString(stackTraceString),
//       );
//       expect(
//         failure.exception,
//         isA<Exception>().having(
//           (e) => e.toString(),
//           'message',
//           'Exception: $exceptionMessage',
//         ),
//       );
//     });
//
//     test('returns NoFailure when calling none', () {
//       expect(Failure.none, isA<NoFailure>());
//     });
//
//     test('returns false by default for needsReconnecting', () {
//       expect(
//         TestFailure(
//           Exception(exceptionMessage),
//           StackTrace.fromString(stackTraceString),
//         ).needsReconnecting,
//         false,
//       );
//     });
//   });
//
//   group('NoFailure', () {
//     late NoFailure subject;
//
//     setUp(() {
//       subject = NoFailure();
//     });
//
//     test('can be instantiated', () {
//       expect(subject, isNotNull);
//     });
//
//     test('is a Failure', () {
//       expect(subject, isA<Failure>());
//     });
//
//     test('correctly sets no exception and no stackTrace', () {
//       expect(
//         subject,
//         isA<Failure>()
//           ..having((f) => f.exception, 'exception', null)
//           ..having((f) => f.stackTrace, 'stackTrace', StackTrace.empty),
//       );
//     });
//
//     test('returns false by default for needsReconnecting', () {
//       expect(subject.needsReconnecting, false);
//     });
//   });
// }
