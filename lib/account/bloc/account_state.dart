part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    required this.chain,
    required this.selectedToken,
    required this.walletAddress,
    this.accountViewStatus = AccountViewStatus.initial,
  });

  final String walletAddress;
  final Token selectedToken;
  final EthereumChain chain;
  final AccountViewStatus accountViewStatus;

  @override
  List<Object?> get props => [
        accountViewStatus,
        selectedToken,
        walletAddress,
        chain,
      ];

  AccountState copyWith({
    String? walletAddress,
    Token? selectedToken,
    EthereumChain? chain,
    AccountViewStatus? accountViewStatus,
  }) {
    return AccountState(
      chain: chain ?? this.chain,
      selectedToken: selectedToken ?? this.selectedToken,
      accountViewStatus: accountViewStatus ?? this.accountViewStatus,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }
}
