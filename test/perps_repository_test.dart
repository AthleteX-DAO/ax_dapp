import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BtcPerpsData', () {
    test('converts price from wei correctly', () {
      final data = BtcPerpsData(
        price: BigInt.from(50000) * BigInt.from(10).pow(18),
        fundingRate: BigInt.from(5) * BigInt.from(10).pow(15), // 0.005 = 0.5%
        openInterest: BigInt.from(100000000) * BigInt.from(10).pow(18),
        skew: BigInt.from(50000000) * BigInt.from(10).pow(18),
        makerFee: BigInt.from(10) * BigInt.from(10).pow(15), // 0.01 = 0.001%
        takerFee: BigInt.from(20) * BigInt.from(10).pow(15), // 0.02 = 0.002%
        timestamp: DateTime.now(),
      );

      expect(data.priceInUSD, closeTo(50000.0, 0.01));
      expect(data.fundingRatePercentage, closeTo(0.5, 0.01));
      expect(data.openInterestUSD, closeTo(100000000.0, 1.0));
      expect(data.skewUSD, closeTo(50000000.0, 1.0));
      expect(data.makerFeePercentage, closeTo(0.001, 0.0001));
      expect(data.takerFeePercentage, closeTo(0.002, 0.0001));
    });

    test('handles negative funding rate correctly', () {
      final data = BtcPerpsData(
        price: BigInt.from(50000) * BigInt.from(10).pow(18),
        fundingRate: -BigInt.from(5) * BigInt.from(10).pow(15), // -0.005 = -0.5%
        openInterest: BigInt.zero,
        skew: BigInt.zero,
        makerFee: BigInt.zero,
        takerFee: BigInt.zero,
        timestamp: DateTime.now(),
      );

      expect(data.fundingRatePercentage, closeTo(-0.5, 0.01));
    });

    test('toString returns formatted string', () {
      final data = BtcPerpsData(
        price: BigInt.from(50000) * BigInt.from(10).pow(18),
        fundingRate: BigInt.from(5) * BigInt.from(10).pow(15),
        openInterest: BigInt.from(100000000) * BigInt.from(10).pow(18),
        skew: BigInt.from(50000000) * BigInt.from(10).pow(18),
        makerFee: BigInt.from(10) * BigInt.from(10).pow(15),
        takerFee: BigInt.from(20) * BigInt.from(10).pow(15),
        timestamp: DateTime.now(),
      );

      final stringRep = data.toString();
      expect(stringRep, contains('50000.00'));
      expect(stringRep, contains('0.5000'));
      expect(stringRep, contains('100000000'));
    });

    test('converts various BTC prices correctly', () {
      final testCases = [
        {'wei': BigInt.from(1) * BigInt.from(10).pow(18), 'expected': 1.0},
        {
          'wei': BigInt.from(50000) * BigInt.from(10).pow(18),
          'expected': 50000.0
        },
        {
          'wei': BigInt.from(100000) * BigInt.from(10).pow(18),
          'expected': 100000.0
        },
      ];

      for (final testCase in testCases) {
        final data = BtcPerpsData(
          price: testCase['wei']! as BigInt,
          fundingRate: BigInt.zero,
          openInterest: BigInt.zero,
          skew: BigInt.zero,
          makerFee: BigInt.zero,
          takerFee: BigInt.zero,
          timestamp: DateTime.now(),
        );

        expect(data.priceInUSD, closeTo(testCase['expected']! as double, 0.01));
      }
    });
  });
}
