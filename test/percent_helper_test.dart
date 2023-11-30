import 'package:ax_dapp/util/percent_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getPercentageDesc', () {
    test('returns positive percentage with plus sign', () {
      expect(getPercentageDesc(50), equals('+50.00%'));
    });

    test('returns negative percentage with minus sign', () {
      expect(getPercentageDesc(-25), equals('-25.00%'));
    });

    test('returns zero percentage without sign', () {
      expect(getPercentageDesc(0), equals('0.00%'));
    });
  });

  group('getPercentageColor', () {
    test('returns green for positive percentage', () {
      expect(getPercentageColor(0.5), equals(Colors.green));
    });

    test('returns red for negative percentage', () {
      expect(getPercentageColor(-0.25), equals(Colors.red));
    });

    test('returns green for zero percentage', () {
      expect(getPercentageColor(0), equals(Colors.white));
    });
  });

  group('getPercentStatusIcon', () {
    test('returns trending up icon for positive percentage', () {
      expect(getPercentStatusIcon(0.5), equals(Icons.trending_up));
    });

    test('returns trending down icon for negative percentage', () {
      expect(getPercentStatusIcon(-0.25), equals(Icons.trending_down));
    });

    test('returns trending up icon for zero percentage', () {
      expect(getPercentStatusIcon(0), equals(Icons.trending_neutral));
    });
  });
}
