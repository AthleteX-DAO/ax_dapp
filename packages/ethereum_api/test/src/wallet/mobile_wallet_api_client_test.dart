// @TestOn('!chrome')
// // ignore_for_file: avoid_web_libraries_in_flutter
//
// import 'package:ethereum_api/src/wallet/wallet_api_client/mobile.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared/shared.dart';
//
// class MockReactiveWeb3Client extends Mock implements ValueStream<Web3Client> {}
//
// void main() {
//   group('EthereumWalletApiClient', () {
//     late ValueStream<Web3Client> reactiveWeb3Client;
//
//     late EthereumWalletApiClient subject;
//
//     setUp(() {
//       reactiveWeb3Client = MockReactiveWeb3Client();
//       subject = EthereumWalletApiClient(reactiveWeb3Client: reactiveWeb3Client);
//     });
//
//     test('is unimplemented on mobile', () {
//       expect(subject.currentChain, throwsUnimplementedError);
//     });
//   });
// }
