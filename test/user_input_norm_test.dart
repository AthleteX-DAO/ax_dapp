import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:test/test.dart';

void main() {
  group('normalizeInput', () {
    test(
        'should return the correct BigInt value when no decimal places are specified',
        () {
      final result = normalizeInput(123.45);
      expect(result, BigInt.parse('123450000000000000000'));
    });

    test(
        'should return the correct BigInt value when decimal places are specified',
        () {
      final result = normalizeInput(123.45, decimal: 6);
      expect(result, BigInt.from(123450000));
    });

    test('should return zero BigInt when input is zero', () {
      final result = normalizeInput(0);
      expect(result, BigInt.zero);
    });

    test(
        'should return zero BigInt when decimal places are specified with zero input',
        () {
      final result = normalizeInput(0, decimal: 4);
      expect(result, BigInt.zero);
    });

    test(
        'should return the correct negative BigInt value when decimal places are specified',
        () {
      final result = normalizeInput(-5.6789, decimal: 2);
      expect(result, BigInt.from(-567));
    });
  });

  group('getRawAmount', () {
    test('should return the correct BigInt value for a positive input', () {
      final result = getRawAmount('123.45', 6);
      expect(result, BigInt.parse('123450000'));
    });

    test('should return the correct BigInt value for a negative input', () {
      final result = getRawAmount('-67.89', 4);
      expect(result, BigInt.parse('-678900'));
    });

    test('should return zero BigInt for zero input', () {
      final result = getRawAmount('0', 8);
      expect(result, BigInt.zero);
    });
  });

  group('getViewAmount', () {
    test('should return the correct string representation for a positive input',
        () {
      final result = getViewAmount(BigInt.parse('12345000000'), 6);
      expect(result, '12345.000000');
    });

    test('should return the correct string representation for a negative input',
        () {
      final result = getViewAmount(BigInt.parse('-678900'), 4);
      expect(result, '-67.890000');
    });

    test('should return zero string representation for zero input', () {
      final result = getViewAmount(BigInt.zero, 8);
      expect(result, '0.000000');
    });
  });

  group('getAmountWithDecimal', () {
    test('should return the correct double value for a positive input', () {
      final result =
          getAmountWithDecimal(BigInt.parse('12345000000'), BigInt.from(6));
      expect(result, 12345.0);
    });

    test('should return the correct double value for a negative input', () {
      final result =
          getAmountWithDecimal(BigInt.parse('-678900'), BigInt.from(4));
      expect(result, -67.89);
    });

    test('should return zero for zero input', () {
      final result = getAmountWithDecimal(BigInt.zero, BigInt.from(8));
      expect(result, 0);
    });
  });
}
