@TestOn('!chrome')
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:ethereum_api/src/wallet/wallet_api_client/mobile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EthereumWalletApiClient', () {
    late EthereumWalletApiClient subject;

    setUp(() {
      subject = EthereumWalletApiClient();
    });

    test('is unimplemented on mobile', () {
      expect(subject.ethereumChain, throwsUnimplementedError);
    });
  });
}
