part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    required this.chain,
    required this.selectedToken,
    required this.walletAddress,
    required this.tokenAddress,
    this.selectedAssets = AccountAssets.all,
    this.accountViewStatus = AccountViewStatus.initial,
    this.tokenBalance = 0,
  });

  final String walletAddress;
  final Token selectedToken;
  final String tokenAddress;
  final AccountAssets selectedAssets;
  final EthereumChain chain;
  final AccountViewStatus accountViewStatus;
  final double tokenBalance;

  @override
  List<Object?> get props => [
        accountViewStatus,
        selectedAssets,
        selectedToken,
        walletAddress,
        chain,
        tokenBalance,
        tokenAddress,
      ];

  AccountState copyWith({
    String? walletAddress,
    Token? selectedToken,
    AccountAssets? selectedAssets,
    EthereumChain? chain,
    AccountViewStatus? accountViewStatus,
    double? tokenBalance,
    String? tokenAddress,
  }) {
    return AccountState(
      chain: chain ?? this.chain,
      selectedToken: selectedToken ?? this.selectedToken,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      accountViewStatus: accountViewStatus ?? this.accountViewStatus,
      walletAddress: walletAddress ?? this.walletAddress,
      tokenBalance: tokenBalance ?? this.tokenBalance,
      tokenAddress: tokenAddress ?? this.tokenAddress,
    );
  }
}
