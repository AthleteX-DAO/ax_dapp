// // ignore_for_file: prefer_const_constructors
// import 'package:ethereum_api/lsp_api.dart';
// import 'package:ethereum_api/tokens_api.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared/shared.dart';
// import 'package:test/test.dart';
// import 'package:tokens_repository/src/api/coin_gecko_api.dart';
// import 'package:tokens_repository/tokens_repository.dart';
//
// class MockTokensApiClient extends Mock implements TokensApiClient {}
//
// class MockCoinApiClient extends Mock implements CoinGeckoAPI {}
//
// class MockReactiveLspClient extends Mock implements ValueStream<LongShortPair> {
// }
//
// void main() {
//   group('TokensRepository', () {
//     late TokensApiClient tokensApiClient;
//     late ValueStream<LongShortPair> reactiveLspClient;
//
//     setUp(() {
//       tokensApiClient = MockTokensApiClient();
//       reactiveLspClient = MockReactiveLspClient();
//     });
//
//     TokensRepository createSubject() => TokensRepository(
//           tokensApiClient: tokensApiClient,
//           reactiveLspClient: reactiveLspClient,
//           coinGeckoApiClient: MockCoinApiClient(),
//         );
//
//     test('can be instantiated', () {
//       expect(createSubject(), isNotNull);
//     });
//   });
// }
