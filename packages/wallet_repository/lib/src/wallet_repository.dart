import 'dart:async';

import 'package:cache/cache.dart';
import 'package:ethereum_api/wallet_api.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_repository/src/models/models.dart';
import 'package:wallet_repository/src/utils/utils.dart';

/// {@template wallet_repository}
/// Repository that manages the wallet domain.
/// {@endtemplate}
class WalletRepository {
  /// {@macro wallet_repository}
  WalletRepository(
    this._walletApiClient,
    this._cache, {
    required this.defaultChain,
  }) {
    _walletApiClient.chainChanges.listen((chain) async {
      debugPrint('Wallet Repo: chain changed: ${chain.name}: ${chain.chainId}');
      debugPrint('Wallet Credentials: $credentialsCacheKey');
      final cachedWalletAddress = _cache
          .read<WalletCredentials>(key: credentialsCacheKey)
          ?.walletAddress;
      final Wallet walletUpdate;
      if (cachedWalletAddress != null) {
        debugPrint(
          'Wallet Repo: wallet address found in cache: $cachedWalletAddress',
        );
        walletUpdate = Wallet(
          address: (chain.isSupported) ? cachedWalletAddress : kEmptyAddress,
          chain: chain,
          status: WalletStatus.fromChain(chain),
        );
      } else {
        debugPrint(
          'Wallet Repo: no cached wallet address so lets get the real thing',
        );
        final newAddress = await _getWalletCredentials();
        debugPrint('Retrieved the new address: $newAddress');
        walletUpdate = Wallet(
          address: (chain.isSupported) ? newAddress : kEmptyAddress,
          chain: chain,
          status: WalletStatus.fromChain(chain),
        );
      }
      _walletChangeController.add(walletUpdate);
    });
  }

  final WalletApiClient _walletApiClient;
  final CacheClient _cache;
  final _walletChangeController = BehaviorSubject<Wallet>();

  /// The initial [EthereumChain] that the wallet will be switched to.
  final EthereumChain defaultChain;

  /// [WalletCredentials] cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const credentialsCacheKey = '__credentials_cache_key__';

  /// set true when connecting, false disconnecting
  static const searchForWalletKey = '__search_cache_key__';

  /// return if you should attempt to load wallet
  Future<bool?> searchForWallet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(searchForWalletKey);
  }

  /// Allows listening to changes to the current [EthereumChain].
  Stream<EthereumChain> get chainChanges => _walletApiClient.chainChanges;

  /// Returns the current [EthereumChain] synchronously.
  EthereumChain get currentChain => _walletApiClient.currentChain;

  ValueStream<Wallet> get _walletChanges => _walletChangeController.stream;

  /// Allows listening to changes to the current [Wallet].
  Stream<Wallet> get walletChanges => _walletChanges;

  /// Returns the current [Wallet] synchronously.
  Wallet get currentWallet =>
      _walletChanges.valueOrNull ?? const Wallet.disconnected();

  /// Returns the cached [WalletCredentials] for the connected wallet. This
  /// doesn't return `null`, because when called, the wallet is asssumed to be
  /// connected and thus have it's credentials cached.
  WalletCredentials get credentials =>
      _cache.read<WalletCredentials>(key: credentialsCacheKey)!;

  /// Allows the user to connect to a `MetaMask` wallet.
  ///
  /// Returns the hexadecimal representation of the wallet address.
  ///
  /// Throws:
  /// - [WalletUnavailableFailure]
  /// - [WalletOperationRejectedFailure]
  /// - [EthereumWalletFailure]
  /// - [UnknownWalletFailure]
  Future<String> connectWallet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(searchForWalletKey, true);
    _walletApiClient.addChainChangedListener();
    await _walletApiClient.syncChain(defaultChain);
    final credentials = _getWalletCredentials();
    return credentials;
  }

  Future<String> _getWalletCredentials() async {
    final credentials = await _walletApiClient.getWalletCredentials();
    _cacheWalletCredentials(credentials);
    final walletAddress = credentials.value.address.hex;
    _walletChangeController.add(
      Wallet(
        status: currentWallet.status,
        address: walletAddress,
        chain: currentWallet.chain,
      ),
    );
    return walletAddress;
  }

  void _cacheWalletCredentials(WalletCredentials credentials) => _cache.write(
        key: credentialsCacheKey,
        value: credentials,
      );

  /// Switches the currently used [EthereumChain].
  ///
  /// Throws:
  /// - [WalletUnavailableFailure]
  /// - [WalletOperationRejectedFailure]
  /// - [EthereumWalletFailure]
  /// - [UnknownWalletFailure]
  Future<void> switchChain(EthereumChain chain) async {
    try {
      await _walletApiClient.switchChain(chain);
    } on WalletUnrecognizedChainFailure {
      await _walletApiClient.addChain(chain);
    }
  }

  /// Simulates disconnecting user's wallet. For security reasons an actual
  /// disconnect is not possible.
  Future<void> disconnectWallet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(searchForWalletKey, false);
    _walletApiClient.removeChainChangedListener();
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
  Future<void> addToken({
    required String tokenAddress,
    required String tokenImageUrl,
  }) =>
      _walletApiClient.addToken(
        tokenAddress: tokenAddress,
        tokenImageUrl: tokenImageUrl,
      );

  /// Returns the amount of tokens with [tokenAddress] owned by the wallet
  /// identified by current [Wallet.address].
  ///
  /// Defaults to [BigInt.zero] on error.
  Future<BigInt> getRawTokenBalance(String tokenAddress) async {
    final walletAddress = (currentWallet.address.isNotEmpty)
        ? currentWallet.address
        : await _getWalletCredentials();
    return _walletApiClient.getRawTokenBalance(
      tokenAddress: tokenAddress,
      walletAddress: walletAddress,
    );
  }

  /// Returns an aproximate balance for the token with the given [tokenAddress],
  /// on the connected wallet. It returns `null` when any error occurs.
  ///
  /// **WARNING**: Due to rounding errors, the returned balance is not
  /// reliable, especially for larger amounts or smaller units. While it can be
  /// used to display the amount of ether in a human-readable format, it should
  /// not be used for anything else.
  Future<double?> getTokenBalance(String tokenAddress) async {
    final rawBalance = await getRawTokenBalance(tokenAddress);
    final decimal = await _walletApiClient.getDecimals(tokenAddress);
    debugPrint('Buy Dialog Raw AX Balance: $rawBalance');
    if (rawBalance == BigInt.zero) {
      return null;
    }
    final balance = getAmountWithDecimal(rawBalance, decimal);
    final formattedBalance = balance.toStringAsFixed(11);
    return double.parse(formattedBalance);
  }

  /// Returns a [BigInt] amount of decimals from a [tokenAddress]. 
  Future<BigInt> getDecimals(String tokenAddress) async {
    final decimal = await _walletApiClient.getDecimals(tokenAddress);
    return decimal;
  }

  /// Returns the amount typically needed to pay for one unit of gas(in gwei).
  Future<double> getGasPrice() => _walletApiClient.getGasPrice();
}
