// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

import 'package:ethereum_api/src/wallet/failures/failures.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';
import 'package:flutter/widgets.dart';
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
    required ValueStream<Web3Client> reactiveWeb3Client,
  })  : _ethereum = ethereum ?? Ethereum.provider,
        _reactiveWeb3Client = reactiveWeb3Client;

  final Ethereum? _ethereum;

  final ValueStream<Web3Client> _reactiveWeb3Client;
  Web3Client get _web3Client => _reactiveWeb3Client.value;

  final _chainController = BehaviorSubject<EthereumChain>();

  /// Allows listening to changes to the current [EthereumChain].
  @override
  Stream<EthereumChain> get chainChanges => _chainController.stream.distinct();

  /// Returns the current [EthereumChain] synchronously.
  @override
  EthereumChain get currentChain =>
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
      throw WalletFailure.fromUnrecognizedChain(exception, stackTrace);
    } catch (error, stackTrace) {
      throw WalletFailure.fromError(error, stackTrace);
    }
  }

  /// When the `defaultChain` is the same with the last known chain on
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
  /// It will result in updates to [chainChanges] stream whenever the
  /// user changes the chain on `MetaMask`.
  @override
  void addChainChangedListener() => _ethereum?.onChainChanged(_onChainChanged);
  void _onChainChanged(int newChainId) {
    final newChain = EthereumChain.fromChainId(newChainId);
    _chainController.add(newChain);
  }

  /// Stops reacting to [Ethereum.onChainChanged].
  ///
  /// It will update the [chainChanges] stream with
  /// [EthereumChain.none] to simulate that the wallet was disconnected.
  /// For security reasons an actual disconnect is not possible.
  @override
  void removeChainChangedListener() {
    _ethereum?.removeAllListeners('chainChanged');
    _chainController.add(EthereumChain.none);
  }

  /// Adds the token with the given [tokenAddress] and [tokenImageUrl] to
  /// user's wallet.
  ///
  /// Throws:
  /// - [WalletUnavailableFailure]
  /// - [WalletUnsuccessfulOperationFailure]
  /// - [WalletOperationRejectedFailure]
  /// - [EthereumWalletFailure]
  /// - [UnknownWalletFailure]
  @override
  Future<void> addToken({
    required String tokenAddress,
    required String tokenImageUrl,
  }) async {
    _checkWalletAvailability();
    try {
      final ethereumAddress = EthereumAddress.fromHex(tokenAddress);
      final token = ERC20(address: ethereumAddress, client: _web3Client);
      final symbol = await token.symbol();
      final decimals = await token.decimals();
      final result = await _ethereum!.walletWatchAssets(
        address: tokenAddress,
        symbol: symbol,
        decimals: decimals.toInt(),
        image: tokenImageUrl,
      );
      if (!result) {
        throw WalletFailure.fromUnsuccessfulOperation();
      }
    } on EthereumUserRejected catch (exception, stackTrace) {
      throw WalletFailure.fromOperationRejected(exception, stackTrace);
    } on EthereumException catch (exception, stackTrace) {
      throw WalletFailure.fromEthereum(exception, stackTrace);
    } catch (error, stackTrace) {
      throw WalletFailure.fromError(error, stackTrace);
    }
  }

  /// Returns the amount of tokens with [tokenAddress] owned by the wallet
  /// identified by [walletAddress].
  ///
  /// Defaults to [BigInt.zero] on error.
  @override
  Future<BigInt> getRawTokenBalance({
    required String tokenAddress,
    required String walletAddress,
  }) async {
    try {
      final tokenEthereumAddress = EthereumAddress.fromHex(tokenAddress);
      final walletEthereumAddress = EthereumAddress.fromHex(walletAddress);
      final token = ERC20(address: tokenEthereumAddress, client: _web3Client);
      final rawBalance = await token.balanceOf(walletEthereumAddress);
      return rawBalance;
    } catch (e) {
      debugPrint('AX getRawTokenBalance error occurred: $e');
      return BigInt.zero;
    }
  }

  /// Returns the amount typically needed to pay for one unit of gas(in gwei).
  @override
  Future<double> getGasPrice() async {
    try {
      final rawGasPrice = await _web3Client.getGasPrice();
      final gasPriceInGwei = rawGasPrice.getValueInUnit(EtherUnit.gwei);
      final formattedGasPriceInGwei = gasPriceInGwei.toStringAsFixed(2);
      return double.parse(formattedGasPriceInGwei);
    } catch (_) {
      return 0.0;
    }
  }

  void _checkWalletAvailability() {
    if (!isEthereumSupported) {
      throw WalletFailure.fromWalletUnavailable();
    }
  }
}

/// `EthereumCurrency` extensions.
extension EthereumCurrencyX on EthereumCurrency {
  /// Converts an `EthereumCurrency` to native `CurrencyParams`.
  CurrencyParams get toCurrencyParams => CurrencyParams(
        name: currencyName,
        symbol: symbol,
        decimals: decimals,
      );
}
