part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  const WalletState({
    required this.walletStatus,
    required this.walletAddress,
    required this.chain,
    this.walletBalance = 0,
    this.axData = AxData.empty,
    this.gasPrice = 0,
    this.failure = WalletFailure.none,
    this.walletViewStatus = WalletViewStatus.initial,
    this.errorMessage,
    this.email = '',
    this.password = '',
  });

  WalletState.fromWallet({
    WalletViewStatus? walletViewStatus,
    required Wallet wallet,
  }) : this(
          walletStatus: wallet.status,
          walletViewStatus: walletViewStatus ?? WalletViewStatus.none,
          walletAddress: wallet.address,
          chain: wallet.chain,
        );

  final WalletStatus walletStatus;
  final String walletAddress;
  final double walletBalance;
  final WalletViewStatus walletViewStatus;
  final EthereumChain chain;
  final AxData axData;
  final double gasPrice;
  final WalletFailure failure;
  final String? errorMessage;
  final String email;
  final String password;

  @override
  List<Object?> get props => [
        walletStatus,
        walletAddress,
        walletViewStatus,
        walletBalance,
        chain,
        gasPrice,
        failure,
        axData,
        errorMessage,
        email,
        password,
      ];

  WalletState copyWith({
    WalletStatus? walletStatus,
    WalletViewStatus? walletViewStatus,
    String? walletAddress,
    double? walletBalance,
    EthereumChain? chain,
    AxData? axData,
    double? gasPrice,
    WalletFailure? failure,
    String? errorMessage,
    String? email,
    String? password,
  }) {
    return WalletState(
      walletStatus: walletStatus ?? this.walletStatus,
      walletViewStatus: walletViewStatus ?? this.walletViewStatus,
      walletBalance: walletBalance ?? this.walletBalance,
      walletAddress: walletAddress ?? this.walletAddress,
      chain: chain ?? this.chain,
      axData: axData ?? this.axData,
      gasPrice: gasPrice ?? this.gasPrice,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
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
      if (hasFailure) failure,
    ];
    final stringifiedProps =
        stringifyProps.map((prop) => prop.toString()).join(', ');
    return 'WalletState($stringifiedProps)';
  }
}

extension WalletStateX on WalletState {
  bool get isWalletConnected => walletStatus.isConnected;
  bool get isWalletDisconnected => !isWalletConnected;
  WalletViewStatus get currentStatus => walletViewStatus.currentStatus();
  bool get isWalletUnsupported => walletStatus.isUnsupported;
  bool get isWalletUnavailable => failure is WalletUnavailableFailure;
  bool get hasFailure => failure != WalletFailure.none;

  String get formattedWalletAddress => "'$walletAddress'";
}
