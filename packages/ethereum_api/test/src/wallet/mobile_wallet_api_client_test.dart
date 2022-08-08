@TestOn('!chrome')
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:ethereum_api/src/wallet/wallet_api_client/mobile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockWeb3Client extends Mock implements Web3Client {}

void main() {
  group('EthereumWalletApiClient', () {
    late Web3Client web3client;

    late EthereumWalletApiClient subject;

    setUp(() {
      web3client = MockWeb3Client();
      subject = EthereumWalletApiClient(web3Client: web3client);
    });

    test('is unimplemented on mobile', () {
      expect(subject.currentChain, throwsUnimplementedError);
    });
  });
}
