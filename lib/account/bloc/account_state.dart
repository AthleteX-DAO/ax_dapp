part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState({
    required this.chain,
    required this.walletAddress,
    this.selectedToken = Token.empty,
    this.tokenAddress = kEmptyAddress,
    this.selectedAssets = AccountAssets.all,
    this.accountViewStatus = AccountViewStatus.initial,
    this.tokenBalance = 0,
    this.tokens = const [],
  });

  final String walletAddress;
  final Token selectedToken;
  final String tokenAddress;
  final AccountAssets selectedAssets;
  final EthereumChain chain;
  final AccountViewStatus accountViewStatus;
  final double tokenBalance;
  final List<Token> tokens;

  @override
  List<Object?> get props => [
        accountViewStatus,
        selectedAssets,
        selectedToken,
        walletAddress,
        chain,
        tokenBalance,
        tokenAddress,
        tokens,
      ];

  AccountState copyWith({
    String? walletAddress,
    Token? selectedToken,
    AccountAssets? selectedAssets,
    EthereumChain? chain,
    AccountViewStatus? accountViewStatus,
    double? tokenBalance,
    String? tokenAddress,
    List<Token>? tokens,
  }) {
    return AccountState(
      chain: chain ?? this.chain,
      selectedToken: selectedToken ?? this.selectedToken,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      accountViewStatus: accountViewStatus ?? this.accountViewStatus,
      walletAddress: walletAddress ?? this.walletAddress,
      tokenBalance: tokenBalance ?? this.tokenBalance,
      tokenAddress: tokenAddress ?? this.tokenAddress,
      tokens: tokens ?? this.tokens,
    );
  }
}
