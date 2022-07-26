part of 'wallet_bloc.dart';

enum WalletStatus {
  disconnected,
  connected,
  unsupported;

  factory WalletStatus.fromEthereumChain(EthereumChain chain) {
    switch (chain) {
      case EthereumChain.none:
        return WalletStatus.disconnected;
      case EthereumChain.unsupported:
        return WalletStatus.unsupported;
      case EthereumChain.polygonMainnet:
      case EthereumChain.polygonTestnet:
      case EthereumChain.sxMainnet:
      case EthereumChain.sxTestnet:
        return WalletStatus.connected;
    }
  }
}

class WalletState extends Equatable {
  const WalletState({
    required this.status,
    required this.chain,
    this.failure = WalletFailure.none,
  });

  final WalletStatus status;
  final EthereumChain chain;
  final WalletFailure failure;

  @override
  List<Object> get props => [status, chain, failure];

  WalletState copyWith({
    WalletStatus? status,
    EthereumChain? chain,
    WalletFailure? failure,
  }) {
    return WalletState(
      status: status ?? this.status,
      chain: chain ?? this.chain,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() {
    return 'status: $status, chain: $chain, failure: $failure';
  }
}

extension WalletStateX on WalletState {
  bool get isWalletConnected => status == WalletStatus.connected;
  bool get hasFailure => failure != WalletFailure.none;
}
