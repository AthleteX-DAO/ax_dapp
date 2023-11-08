part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    required this.chain,
    required this.walletAddress,
    this.accountViewStatus = AccountViewStatus.initial,
  });

  final String walletAddress;
  final EthereumChain chain;
  final AccountViewStatus accountViewStatus;

  @override
  List<Object?> get props => [
        accountViewStatus,
        walletAddress,
        chain,
      ];

  AccountState copyWith({
    String? walletAddress,
    EthereumChain? chain,
    AccountViewStatus? accountViewStatus,
  }) {
    return AccountState(
      chain: chain ?? this.chain,
      accountViewStatus: accountViewStatus ?? this.accountViewStatus,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }
}
