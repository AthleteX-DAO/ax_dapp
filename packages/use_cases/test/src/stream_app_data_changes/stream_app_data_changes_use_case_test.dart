// @TestOn('browser')
// // ignore_for_file: prefer_const_constructors
// import 'package:config_repository/config_repository.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';
// import 'package:tokens_repository/tokens_repository.dart';
// import 'package:use_cases/stream_app_data_changes_use_case.dart';
// import 'package:wallet_repository/wallet_repository.dart';
//
// class MockWalletRepository extends Mock implements WalletRepository {}
//
// class MockTokensRepository extends Mock implements TokensRepository {}
//
// class MockConfigRepository extends Mock implements ConfigRepository {}
//
// void main() {
//   late WalletRepository walletRepository;
//   late TokensRepository tokensRepository;
//   late ConfigRepository configRepository;
//
//   StreamAppDataChangesUseCase createSubject() => StreamAppDataChangesUseCase(
//         walletRepository: walletRepository,
//         tokensRepository: tokensRepository,
//         configRepository: configRepository,
//       );
//
//   group('StreamAppDataChangesUseCase', () {
//     setUp(() {
//       walletRepository = MockWalletRepository();
//       tokensRepository = MockTokensRepository();
//       configRepository = MockConfigRepository();
//     });
//
//     test('can be instantiated', () {
//       expect(createSubject(), isNotNull);
//     });
//   });
// }
