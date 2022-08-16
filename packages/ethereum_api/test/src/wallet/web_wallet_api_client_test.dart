@TestOn('chrome')
// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/web.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';
import 'package:web3_browser/web3_browser.dart' as web3_browser;

class MockEthereum extends Mock implements Ethereum {}

class MockReactiveWeb3Client extends Mock implements ValueStream<Web3Client> {}

class MockWindow extends Mock implements html.Window {}

class MockBrowserEthereum extends Mock implements web3_browser.Ethereum {}

class MockCredentialsWithKnownAddress extends Mock
    implements CredentialsWithKnownAddress {}

class FakeCredentialsWithKnownAddress extends Fake
    implements CredentialsWithKnownAddress {}

void main() {
  group('EthereumWalletApiClient', () {
    late Ethereum ethereum;
    late ValueStream<Web3Client> reactiveWeb3Client;
    late web3_browser.Ethereum browserEthereum;

    late EthereumWalletApiClient subject;

    EthereumWalletApiClient createSubject() => EthereumWalletApiClient(
          ethereum: ethereum,
          reactiveWeb3Client: reactiveWeb3Client,
        )
          ..isEthereumSupported = true
          ..browserEthereum = browserEthereum;

    setUp(() {
      ethereum = MockEthereum();
      reactiveWeb3Client = MockReactiveWeb3Client();
    });

    test('can be instantiated', () {
      expect(
        EthereumWalletApiClient(
          ethereum: ethereum,
          reactiveWeb3Client: reactiveWeb3Client,
        ),
        isNotNull,
      );
    });

    group('addChain', () {
      setUp(() {
        browserEthereum = MockBrowserEthereum();

        registerFallbackValue(
          CurrencyParams(name: '', symbol: '', decimals: 0),
        );

        subject = createSubject();
      });

      test('makes correct api request', () {
        when(
          () => ethereum.walletAddChain(
            chainId: any(named: 'chainId'),
            chainName: any(named: 'chainName'),
            nativeCurrency: any(named: 'nativeCurrency'),
            rpcUrls: any(named: 'rpcUrls'),
            blockExplorerUrls: any(named: 'blockExplorerUrls'),
          ),
        ).thenAnswer((_) async {});
        expect(subject.addChain(EthereumChain.polygonTestnet), completes);
        verify(
          () => ethereum.walletAddChain(
            chainId: any(named: 'chainId'),
            chainName: any(named: 'chainName'),
            nativeCurrency: any(named: 'nativeCurrency'),
            rpcUrls: any(named: 'rpcUrls'),
            blockExplorerUrls: any(named: 'blockExplorerUrls'),
          ),
        ).called(1);
      });
    });
  });
}
