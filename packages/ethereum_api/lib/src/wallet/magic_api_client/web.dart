import 'dart:js_util';

import 'package:ethereum_api/config_api.dart';
import 'package:ethereum_api/src/wallet/magic_api_client/javascript_calls/magic.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:ethereum_api/wallet_api.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';

/// {@template magic_wallet_api_client}
/// Web only client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
class MagicWalletApiClient implements WalletApiClient {
  /// {@macro magic_wallet_api_client}
  MagicWalletApiClient({
    required MagicSDK magicSDK,
    required ValueStream<Web3Client> reactiveWeb3Client,
  })  : _magicSDK = magicSDK,
        _reactiveWeb3Client = reactiveWeb3Client;

  final MagicSDK _magicSDK;
  final _reactiveApiClient = BehaviorSubject<ConfigApiClient>();
  final ValueStream<Web3Client> _reactiveWeb3Client;
  Web3Client get _web3Client => _reactiveWeb3Client.value;
  ConfigApiClient get _configApiClient => _reactiveApiClient.value;
  @override
  EthereumChain get currentChain => EthereumChain.polygonMainnet;

  /// Allows the user to connect to a 'Magic' wallet.
  ///
  /// Returns the hexadecimal representation of the wallet address.
  ///
  /// Throws:
  @override
  Future<dynamic> connect() async {
    try {
      final address = promiseToFuture<String>(_magicSDK.showWallet());
      return address;
    } catch (_) {}
  }

  /// Allows the user to retrieve information about their wallet.
  ///
  /// Throws:
  @override
  Future<void> getWalletInfo() async {
    try {
      await _magicSDK.getWalletInfo();
    } catch (_) {}
  }

  /// Allows the user to show their 'Magic' wallet.
  ///
  /// Throws:
  @override
  Future<dynamic> showWallet() async {
    try {
      final address = await promiseToFuture<String>(_magicSDK.showWallet());
      debugPrint('[MagicApiClient]showWallet invoked.  address: $address');
      return address;
    } catch (_) {}
  }

  /// Allows the user to send their information upon request
  ///
  /// Returns a string representation of the email address
  /// that is associated with the 'Magic' wallet
  ///
  /// Throws:
  @override
  Future<void> requestUserInfo() async {
    try {
      await _magicSDK.requestUserInfo();
    } catch (_) {}
  }

  /// Disconnects the user from their 'Magic' wallet.
  ///
  /// Throws:
  @override
  Future<void> disconnect() async {
    try {
      await _magicSDK.disconnect();
    } catch (_) {}
  }

  @override
  Future<dynamic> requestAccount() async {
    final addresses =
        await promiseToFuture<List<String>>(_magicSDK.requestAccount());
    final requiredAddress = addresses.single;
    return requiredAddress;
  }

  @override
  Future<void> addChain(EthereumChain chain) {
    // TODO: implement addChain
    throw UnimplementedError();
  }

  @override
  void addChainChangedListener() {
    // TODO: implement addChainChangedListener
  }

  @override
  Future<void> addToken(
      {required String tokenAddress, required String tokenImageUrl}) {
    // TODO: implement addToken
    throw UnimplementedError();
  }

  @override
  // TODO: implement chainChanges
  Stream<EthereumChain> get chainChanges => throw UnimplementedError();

  @override
  Future<BigInt> getDecimals(String tokenAddress) {
    // TODO: implement getDecimals
    throw UnimplementedError();
  }

  @override
  Future<BigInt> getRawTokenBalance(
      {required String tokenAddress, required String walletAddress}) {
    // TODO: implement getRawTokenBalance
    throw UnimplementedError();
  }

  @override
  void removeChainChangedListener() {
    // TODO: implement removeChainChangedListener
  }

  @override
  Future<void> switchChain(EthereumChain chain) {
    // TODO: implement switchChain
    throw UnimplementedError();
  }

  @override
  Future<void> syncChain(EthereumChain chain) {
    // TODO: implement syncChain
    throw UnimplementedError();
  }

  @override
  Future<double> getGasPrice() async {
    final rawGasPrice = await _magicSDK.getGasPrice() as EtherAmount;
    final gasPriceInGwei = rawGasPrice.getValueInUnit(EtherUnit.gwei);
    final formattedGasPriceInGwei = gasPriceInGwei.toStringAsFixed(2);
    return double.parse(formattedGasPriceInGwei);
  }

  @override
  Future<WalletCredentials> getWalletCredentials() async {
    // TODO: implement getWalletCredentials
    try {
      final credentials = await promiseToFuture<CredentialsWithKnownAddress>(
        _magicSDK.requestAccount(),
      );
      return WalletCredentials(credentials);
    } catch (error, stackTrace) {
      throw WalletFailure.fromError(error, stackTrace);
    }
  }
}
