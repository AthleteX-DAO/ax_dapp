part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  const WalletState({
    required this.walletStatus,
    required this.walletAddress,
    required this.chain,
    this.axData = AxData.empty,
    this.gasPrice = 0,
    this.failure = WalletFailure.none,
  });

  WalletState.fromWallet(Wallet wallet)
      : this(
          walletStatus: wallet.status,
          walletAddress: wallet.address,
          chain: wallet.chain,
        );

  final WalletStatus walletStatus;
  final String walletAddress;
  final EthereumChain chain;
  final AxData axData;
  final double gasPrice;
  final WalletFailure failure;

  @override
  List<Object> get props => [
        walletStatus,
        walletAddress,
        chain,
        gasPrice,
        failure,
        axData,
      ];

  WalletState copyWith({
    WalletStatus? walletStatus,
    String? walletAddress,
    EthereumChain? chain,
    AxData? axData,
    double? gasPrice,
    WalletFailure? failure,
  }) {
    return WalletState(
      walletStatus: walletStatus ?? this.walletStatus,
      walletAddress: walletAddress ?? this.walletAddress,
      chain: chain ?? this.chain,
      axData: axData ?? this.axData,
      gasPrice: gasPrice ?? this.gasPrice,
      failure: failure ?? this.failure,
    );
  }

  WalletState copyWithWallet(Wallet wallet) => copyWith(
        walletStatus: wallet.status,
        walletAddress: wallet.address,
        chain: wallet.chain,
      );

  @override
  String toString() {
    final stringifyProps = [
      walletStatus,
      walletAddress,
      chain,
      if (hasFailure) failure
    ];
    final stringifiedProps =
        stringifyProps.map((prop) => prop.toString()).join(', ');
    return 'WalletState($stringifiedProps)';
  }
}

extension WalletStateX on WalletState {
  bool get isWalletConnected => walletStatus.isConnected;
  bool get isWalletDisconnected => !isWalletConnected;
  bool get isWalletUnsupported => walletStatus.isUnsupported;
  bool get isWalletUnavailable => failure is WalletUnavailableFailure;
  bool get hasFailure => failure != WalletFailure.none;

  String get formattedWalletAddress => "'$walletAddress'";
}
