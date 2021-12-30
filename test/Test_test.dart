import 'package:test/test.dart';

void main() {
  test('Testing unit tests', () {
    String actual = "This should execute successfully";
    String matcher = "This should execute successfully";
    expect(actual, matcher);
  });
}
