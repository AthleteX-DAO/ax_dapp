// ignore_for_file: prefer_const_constructors
import 'package:ethereum_api/ethereum_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EthereumApiClient', () {
    test('can be instantiated', () {
      expect(EthereumApiClient(), isNotNull);
    });
  });
}
