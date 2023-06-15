import 'package:ax_dapp/util/truncate_double.dart';
import 'package:test/test.dart';

void main() {
  group('Truncate to decimal places', () {
    test('2 decimal places', () {
      const value = 3.14159265359;
      const fractionalDigits = 2;
      final result = truncateToDecimalPlaces(
        value: value,
        fractionalDigits: fractionalDigits,
      );
      expect(result, equals(3.14));
    });

    test('4 decimal places', () {
      const value = 123.456789;
      const fractionalDigits = 4;
      final result = truncateToDecimalPlaces(
        value: value,
        fractionalDigits: fractionalDigits,
      );
      expect(result, equals(123.4567));
    });

    test('6 decimal places', () {
      const value = 0.987654321;
      const fractionalDigits = 6;
      final result = truncateToDecimalPlaces(
        value: value,
        fractionalDigits: fractionalDigits,
      );
      expect(result, equals(0.987654));
    });

    test('No truncation needed', () {
      const value = 10.0;
      const fractionalDigits = 3;
      final result = truncateToDecimalPlaces(
        value: value,
        fractionalDigits: fractionalDigits,
      );
      expect(result, equals(10.0));
    });
  });
}
