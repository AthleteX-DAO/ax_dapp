// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

import 'package:ethereum_api/src/wallet/failures/failures.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:shared/shared.dart';
import 'package:web3_browser/web3_browser.dart' as web3_browser;

/// {@template wallet_api_client}
/// Web only client that manages the wallet API(i.e. MetaMask).
/// {@endtemplate}
class EthereumWalletApiClient implements WalletApiClient {
  /// {@macro wallet_api_client}
  EthereumWalletApiClient({
    Ethereum? ethereum,
  }) : _ethereum = ethereum ?? Ethereum.provider;

  final Ethereum? _ethereum;

  final _chainController = BehaviorSubject<EthereumChain>();

  /// Allows listening to changes to the current [EthereumChain].
  @override
  Stream<EthereumChain> get ethereumChainChanges =>
      _chainController.stream.distinct();

  /// Returns the current [EthereumChain] synchronously.
  @override
  EthereumChain get ethereumChain =>
      _chainController.valueOrNull ?? EthereumChain.none;

  /// Returns whether [Ethereum] is currently supported. Can be overriden for
  /// testing purposes only.
  @visibleForTesting
  bool isEthereumSupported = Ethereum.isSupported;

  html.Window get _window => html.window;

  /// Browser's Ethereum can be overridden for testing purposes only.
  @visibleForTesting
  web3_browser.Ethereum? browserEthereum;
  web3_browser.Ethereum get _browserEthereum =>
      browserEthereum ?? _window.ethereum!;

  /// Adds the specified [chain] to user's `MetaMask` wallet. The user
  /// may choose to switch to the chain once it has been added.
  ///
  /// Throws:
  /// - [WalletUnavailableFailure]
  /// - [WalletOperationRejectedFailure]
  /// - [EthereumWalletFailure]
  /// - [UnknownWalletFailure]
  @override
  Future<void> addChain(EthereumChain chain) async {
    _checkWalletAvailability();
    try {
      await _ethereum!.walletAddChain(
        chainId: chain.chainId,
        chainName: chain.chainName,
        nativeCurrency: chain.currency.toCurrencyParams,
        rpcUrls: chain.rpcUrls,
        blockExplorerUrls: chain.blockExplorerUrls,
      );
    } on EthereumUserRejected catch (exception, stackTrace) {
      throw WalletFailure.fromOperationRejected(exception, stackTrace);
    } on EthereumException catch (exception, stackTrace) {
      throw WalletFailure.fromEthereum(exception, stackTrace);
    } catch (error, stackTrace) {
      throw WalletFailure.fromError(error, stackTrace);
    }
  }

  /// Switches the currently used chain.
  ///
  /// Throws:
  /// - [WalletUnavailableFailure]
  /// - [WalletUnrecognizedChainFailure]
  /// - [WalletOperationRejectedFailure]
  /// - [EthereumWalletFailure]
  /// - [UnknownWalletFailure]
  @override
  Future<void> switchChain(EthereumChain chain) async {
    _checkWalletAvailability();
    try {
      await _ethereum!.walletSwitchChain(chain.chainId);
      await _syncChainId();
    } on EthereumUnrecognizedChainException catch (exception, stackTrace) {
      // Bug with `EthereumUnrecognizedChainException` not being thrown by the
      // underlying method, `WalletFailure.fromError` handles it.
      throw WalletFailure.fromUnrecognizedChain(exception, stackTrace);
    } on EthereumUserRejected catch (exception, stackTrace) {
      throw WalletFailure.fromOperationRejected(exception, stackTrace);
    } on EthereumException catch (exception, stackTrace) {
      throw WalletFailure.fromEthereum(exception, stackTrace);
    } catch (error, stackTrace) {
      throw WalletFailure.fromError(error, stackTrace);
    }
  }

  /// When the `seedChain` is the same with the last known chain on
  /// `MetaMask`, [Ethereum.onChainChanged] doesn't get triggered, so we
  /// explicitly sync up the chain.
  Future<void> _syncChainId() async {
    final chainId = await _ethereum!.getChainId();
    _chainController.add(EthereumChain.fromChainId(chainId));
  }

  /// Asks the user to select an account and give your application access to it.
  /// Returns the [WalletCredentials] for the connected account.
  ///
  /// Throws:
  /// - [WalletUnavailableFailure]
  /// - [WalletOperationRejectedFailure]
  /// - [UnknownWalletFailure]
  @override
  Future<WalletCredentials> getWalletCredentials() async {
    _checkWalletAvailability();
    try {
      final credentials = await _browserEthereum.requestAccount();
      return WalletCredentials(credentials);
    } catch (error, stackTrace) {
      throw WalletFailure.fromBrowserEthereum(error, stackTrace);
    }
  }

  /// Starts reacting to [Ethereum.onChainChanged].
  ///
  /// It will result in updates to [ethereumChainChanges] stream whenever the
  /// user changes the chain on `MetaMask`.
  @override
  void addChainChangedListener() => _ethereum?.onChainChanged(_onChainChanged);
  void _onChainChanged(int newChainId) {
    final newChain = EthereumChain.fromChainId(newChainId);
    _chainController.add(newChain);
  }

  /// Stops reacting to [Ethereum.onChainChanged].
  ///
  /// It will update the [ethereumChainChanges] stream with
  /// [EthereumChain.none] to simulate that the wallet was disconnected.
  /// For security reasons an actual disconnect is not possible.
  @override
  void removeChainChangedListener() {
    _ethereum?.removeAllListeners('chainChanged');
    _chainController.add(EthereumChain.none);
  }

  void _checkWalletAvailability() {
    if (!isEthereumSupported) {
      throw WalletFailure.fromWalletUnavailable();
    }
  }
}
