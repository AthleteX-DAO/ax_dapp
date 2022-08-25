import 'dart:async';

import 'package:cache/cache.dart';
import 'package:ethereum_api/wallet_api.dart';
import 'package:shared/shared.dart';
import 'package:wallet_repository/src/models/models.dart';

/// {@template wallet_repository}
/// Repository that manages the wallet domain.
/// {@endtemplate}
class WalletRepository {
  /// {@macro wallet_repository}
  WalletRepository({
    required WalletApiClient walletApiClient,
    required CacheClient cache,
    required this.defaultChain,
  })  : _walletApiClient = walletApiClient,
        _cache = cache,
        _walletChanges = walletApiClient.chainChanges
            .map(
              (chain) => Wallet(
                address: chain.isSupported
                    ? cache
                            .read<WalletCredentials>(key: credentialsCacheKey)
                            ?.walletAddress ??
                        kEmptyAddress
                    : kEmptyAddress,
                chain: chain,
                status: WalletStatus.fromChain(chain),
              ),
            )
            .shareValue();

  final WalletApiClient _walletApiClient;
  final CacheClient _cache;

  /// The initial [EthereumChain] that the wallet will be switched to.
  final EthereumChain defaultChain;

  /// [WalletCredentials] cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const credentialsCacheKey = '__credentials_cache_key__';

  /// Allows listening to changes to the current [EthereumChain].
  Stream<EthereumChain> get chainChanges => _walletApiClient.chainChanges;

  /// Returns the current [EthereumChain] synchronously.
  EthereumChain get currentChain => _walletApiClient.currentChain;

  final ValueStream<Wallet> _walletChanges;

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
    _walletApiClient.addChainChangedListener();
    await switchChain(defaultChain);
    return _getWalletCredentials();
  }

  Future<String> _getWalletCredentials() async {
    final credentials = await _walletApiClient.getWalletCredentials();
    _cacheWalletCredentials(credentials);
    return credentials.value.address.hex;
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
  void disconnectWallet() => _walletApiClient.removeChainChangedListener();

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
  Future<BigInt> getRawTokenBalance(String tokenAddress) =>
      _walletApiClient.getRawTokenBalance(
        tokenAddress: tokenAddress,
        walletAddress: currentWallet.address,
      );

  /// Returns an aproximate balance for the token with the given [tokenAddress],
  /// on the connected wallet. It returns `null` when any error occurs.
  ///
  /// **WARNING**: Due to rounding errors, the returned balance is not
  /// reliable, especially for larger amounts or smaller units. While it can be
  /// used to display the amount of ether in a human-readable format, it should
  /// not be used for anything else.
  Future<double?> getTokenBalance(String tokenAddress) async {
    final rawBalance = await getRawTokenBalance(tokenAddress);
    if (rawBalance == BigInt.zero) {
      return null;
    }
    final balanceInWei = EtherAmount.inWei(rawBalance);
    final balance = balanceInWei.getValueInUnit(EtherUnit.ether);
    final formattedBalance = balance.toStringAsFixed(2);
    return double.parse(formattedBalance);
  }

  /// Returns the amount typically needed to pay for one unit of gas(in gwei).
  Future<double> getGasPrice() => _walletApiClient.getGasPrice();
}
