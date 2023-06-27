import 'dart:js_interop';
import 'dart:js_util';

import 'package:ethereum_api/config_api.dart';
import 'package:ethereum_api/src/wallet/models/magic_credentials.dart';
import 'package:ethereum_api/wallet_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web3/flutter_web3.dart';
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
  EthereumChain get currentChain =>
      _chainController.valueOrNull ?? EthereumChain.none;

  void _checkWalletAvailability() {
    if (_magicSDK.isUndefinedOrNull) {
      throw WalletFailure.fromWalletUnavailable();
    }
  }

  final _chainController = BehaviorSubject<EthereumChain>();

  /// Allows the user to retrieve information about their wallet.
  ///
  /// Throws: Exception
  Future<String> getWalletInfo() async {
    try {
      final walletType =
          await promiseToFuture<String>(_magicSDK.getWalletInfo());
      return walletType;
    } catch (_) {
      throw Exception('Unable to getWalletInfo from Magic');
    }
  }

  /// Allows the user to send their information upon request
  ///
  /// Returns a string representation of the email address
  /// that is associated with the 'Magic' wallet
  ///
  Future<String> requestUserInfo() async {
    try {
      final email = await promiseToFuture<String>(_magicSDK.requestUserInfo());
      return email;
    } catch (error, stacktrace) {
      throw Exception('Unable to requestUserInfo from Magic');
    }
  }

  /// Allows the user to disconnect their wallet from the dApp
  Future<void> disconnect() async {
    try {
      await promiseToFuture<void>(_magicSDK.disconnect());
    } catch (_) {
      throw Exception(
        "unable to disconnect Magic from dapp.. maybe it's already disconnected",
      );
    }
  }

  /// Returns web3dart compatible Magic credentials
  Future<CredentialsWithKnownAddress> requestAccount() async {
    String requiredAddresses;
    try {
      final addresses = await promiseToFuture<String>(_magicSDK.connect());
      requiredAddresses = addresses;
    } catch (e) {
      requiredAddresses = kNullAddress;
      throw Exception(
        'Unable to request account from magicSDK.  See error for details \n\n $e',
      );
    }

    return MagicCredentials(_magicSDK, requiredAddresses);
  }

  /// adds a chain to the Magic Wallet
  @override
  Future<void> addChain(EthereumChain chain) async {
    throw UnimplementedError(
      'Magic Wallet does not allow adding chains',
    );
  }

  @override
  void addChainChangedListener() {
    throw UnimplementedError(
      'Magic Wallet does not allow listening to chain changes',
    );
  }

  @override
  void removeChainChangedListener() {
    throw UnimplementedError(
      'Magic Wallet does not allow removing chain changed listeners',
    );
  }

  @override
  Future<void> addToken({
    required String tokenAddress,
    required String tokenImageUrl,
  }) async {
    try {
      await promiseToFuture<void>(
        _magicSDK.addToken(tokenAddress, tokenImageUrl),
      );
    } catch (e) {
      throw Exception(
        'Unable to addToken to Magic wallet',
      );
    }
  }

  @override
  Stream<EthereumChain> get chainChanges => _chainController.stream.distinct();

  @override
  Future<BigInt> getDecimals(String tokenAddress) async {
    try {
      final rawDecimals =
          await promiseToFuture<num>(_magicSDK.getDecimals(tokenAddress));
      return BigInt.from(rawDecimals);
    } catch (e) {
      throw Exception(
        'Unable to getDecimals of $tokenAddress from Magic wallet',
      );
    }
  }

  @override
  Future<BigInt> getRawTokenBalance({
    required String tokenAddress,
    required String walletAddress,
  }) async {
    _checkWalletAvailability();

    try {
      final rawTokenBalance = promiseToFuture<String>(
        await _magicSDK.getTokenBalance(tokenAddress, walletAddress) as String,
      );
      return rawTokenBalance as BigInt;
    } catch (e) {
      throw Exception('Unable to getTokenBalance from Magic wallet');
    }
  }

  @override
  Future<void> switchChain(EthereumChain chain) async {
    _checkWalletAvailability(); //Checks if a wallet is already connected

    try {
      await promiseToFuture<void>(_magicSDK.sendTransaction());
    } catch (e) {
      throw Exception('Unable to switchChain for Magic wallet');
    }
  }

  @override
  Future<void> syncChain(EthereumChain chain) async {
    _checkWalletAvailability();
    try {
      await _syncChainId();
    } on EthereumUserRejected catch (exception, stackTrace) {
      throw WalletFailure.fromOperationRejected(exception, stackTrace);
    } on EthereumException catch (exception, stackTrace) {
      throw WalletFailure.fromUnrecognizedChain(exception, stackTrace);
    } catch (error, stackTrace) {
      throw WalletFailure.fromError(error, stackTrace);
    }
  }

  Future<void> _syncChainId() async {
    final chainId = await promiseToFuture<int>(_magicSDK.getChainId());
    _chainController.add(EthereumChain.fromChainId(chainId));
  }

  @override
  Future<BigInt> getGasPrice() async {
    final rawGasPrice = await promiseToFuture<BigInt>(_magicSDK.getGasPrice());
    return rawGasPrice;
  }

  @override
  Future<WalletCredentials> getWalletCredentials() async {
    try {
      final credentials = await requestAccount();
      debugPrint('grabbing wallet credentials!');
      return WalletCredentials(credentials);
    } catch (error, stackTrace) {
      throw WalletFailure.fromError(error, stackTrace);
    }
  }
}
