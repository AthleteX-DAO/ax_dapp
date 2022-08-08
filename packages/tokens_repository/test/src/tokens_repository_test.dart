@TestOn('chrome')

// ignore_for_file: prefer_const_constructors
import 'package:ethereum_api/ethereum_api.dart';
import 'package:ethereum_api/lsp_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MockEthereumApiClient extends Mock implements EthereumApiClient {}

class MockLongShortPair extends Mock implements LongShortPair {}

void main() {
  group('TokensRepository', () {
    late EthereumApiClient ethereumApiClient;
    late LongShortPair lspClient;

    setUp(() {
      ethereumApiClient = MockEthereumApiClient();
      lspClient = MockLongShortPair();
    });

    TokensRepository createSubject() => TokensRepository(
          ethereumApiClient: ethereumApiClient,
          lspClient: lspClient,
        );

    test('can be instantiated', () {
      expect(createSubject(), isNotNull);
    });
  });
}
