import 'dart:async';

import 'package:cache/cache.dart';
import 'package:ethereum_api/wallet_api.dart';
import 'package:shared/shared.dart';

/// {@template wallet_repository}
/// Repository that manages the wallet domain.
/// {@endtemplate}
class WalletRepository {
  /// {@macro wallet_repository}
  WalletRepository({
    WalletApiClient? walletApiClient,
    CacheClient? cache,
    required EthereumChain defaultChain,
  })  : _walletApiClient = walletApiClient ?? EthereumWalletApiClient(),
        _cache = cache ?? CacheClient(),
        _defaultChain = defaultChain;

  final WalletApiClient _walletApiClient;
  final CacheClient _cache;

  /// The initial `EthereumChain` that the wallet will be switched to.
  final EthereumChain _defaultChain;

  /// [Credentials] cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const credentialsCacheKey = '__credentials_cache_key__';

  /// Allows listening to changes to the current [EthereumChain].
  Stream<EthereumChain> get ethereumChainChanges =>
      _walletApiClient.ethereumChainChanges;

  /// Returns the current [EthereumChain] synchronously.
  EthereumChain get ethereumChain => _walletApiClient.ethereumChain;

  /// Allows the user to connect to a `MetaMask` wallet.
  ///
  /// Returns the hexadecimal representation of the wallet address.
  Future<String> connectWallet() async {
    _walletApiClient.addChainChangedListener();
    await switchChain(_defaultChain);
    return _getWalletCredentials();
  }

  /// Switches the currently used chain.
  Future<void> switchChain(EthereumChain chain) async {
    try {
      await _walletApiClient.switchChain(chain);
    } on WalletUnrecognizedChainFailure {
      await _walletApiClient.addChain(chain);
    }
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

  /// Returns the cached [WalletCredentials] for the connected wallet. This
  /// doesn't return `null`, because when called, the wallet is asssumed to be
  /// connected and thus have it's credentials cached.
  ///
  /// This can used in the BLoC layer to pass [WalletCredentials] to other calls
  /// needing them.
  WalletCredentials get credentials =>
      _cache.read<WalletCredentials>(key: credentialsCacheKey)!;

  /// Simulates disconnecting user's wallet. For security reasons an actual
  /// disconnect is not possible.
  void disconnectWallet() => _walletApiClient.removeChainChangedListener();
}
