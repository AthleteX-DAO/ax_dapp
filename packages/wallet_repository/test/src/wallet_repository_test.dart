@TestOn('chrome')
// ignore_for_file: prefer_const_constructors

import 'package:cache/cache.dart';
import 'package:ethereum_api/ethereum_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:wallet_repository/src/wallet_repository.dart';

class MockWalletApiClient extends Mock implements WalletApiClient {}

class MockCacheClient extends Mock implements CacheClient {}

void main() {
  group('WalletRepository', () {
    late WalletApiClient walletApiClient;
    late CacheClient cache;

    late WalletRepository subject;

    setUp(() {
      walletApiClient = MockWalletApiClient();
      cache = MockCacheClient();

      subject = WalletRepository(
        walletApiClient: walletApiClient,
        cache: cache,
        seedChain: EthereumChain.polygonMainnet,
      );
    });

    test('can be instantiated', () {
      expect(subject, isNotNull);
    });
  });
}
