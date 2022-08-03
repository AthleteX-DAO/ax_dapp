@TestOn('chrome')

// ignore_for_file: prefer_const_constructors
import 'package:ethereum_api/ethereum_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MockEthereumApiClient extends Mock implements EthereumApiClient {}

void main() {
  group('TokensRepository', () {
    late EthereumApiClient ethereumApiClient;

    setUp(() {
      ethereumApiClient = MockEthereumApiClient();
    });

    TokensRepository createSubject() =>
        TokensRepository(ethereumApiClient: ethereumApiClient);

    test('can be instantiated', () {
      expect(createSubject(), isNotNull);
    });
  });
}
