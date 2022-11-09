import 'package:ethereum_api/wallet_api.dart';

/// Represents the status of a wallet.
enum WalletStatus {
  /// Disconnected wallet.
  disconnected,

  /// Connected wallet.
  connected,

  /// Unsupported wallet.
  unsupported;

  /// Computes a [WalletStatus] from the given [EthereumChain].
  factory WalletStatus.fromChain(EthereumChain chain) {
    switch (chain) {
      case EthereumChain.none:
        return WalletStatus.disconnected;
      case EthereumChain.unsupported:
        return WalletStatus.unsupported;
      case EthereumChain.polygonMainnet:
      case EthereumChain.goerliTestNet:
      case EthereumChain.sxMainnet:
      case EthereumChain.sxTestnet:
        return WalletStatus.connected;
    }
  }
}

/// [WalletStatus] extensions.
extension WalletStatusX on WalletStatus {
  /// Returns `true` when this status is connected.
  bool get isConnected => this == WalletStatus.connected;

  /// Returns `true` when this status is unsupported.
  bool get isUnsupported => this == WalletStatus.unsupported;
}
