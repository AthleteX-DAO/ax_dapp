part of 'account_bloc.dart';

class AccountState extends Equatable {
  AccountState({
    required this.chain,
    required this.walletAddress,
    this.selectedToken = Token.empty,
    this.tokenAddress = kEmptyAddress,
    this.selectedAssets = AccountAssets.all,
    this.accountViewStatus = AccountViewStatus.initial,
    this.tokenBalance = 0,
    this.tokens = const [],
    this.tokenAmountInput = 0,
    this.recipentAddress = kEmptyAddress,
    this.vaults = const [],
    this.isVaultsLoading = false,
    this.vaultsError,
    EthereumChain? withdrawTargetChain,
    // Synthetix account data
    this.synthetixAccountId = 0,
    BigInt? synthetixCollateralDeposited,
    BigInt? synthetixCollateralAssigned,
    BigInt? synthetixCollateralAvailable,
    BigInt? synthetixDebt,
    BigInt? synthetixCollateralRatio,
    this.hasSynthetixAccount = false,
    this.isSynthetixAccountLoading = false,
  })  : withdrawTargetChain = withdrawTargetChain ?? chain,
        synthetixCollateralDeposited = synthetixCollateralDeposited ?? _zeroBigInt,
        synthetixCollateralAssigned = synthetixCollateralAssigned ?? _zeroBigInt,
        synthetixCollateralAvailable = synthetixCollateralAvailable ?? _zeroBigInt,
        synthetixDebt = synthetixDebt ?? _zeroBigInt,
        synthetixCollateralRatio = synthetixCollateralRatio ?? _zeroBigInt;

  static final BigInt _zeroBigInt = BigInt.zero;

  final String walletAddress;
  final Token selectedToken;
  final String tokenAddress;
  final AccountAssets selectedAssets;
  final EthereumChain chain;
  final AccountViewStatus accountViewStatus;
  final double tokenBalance;
  final List<Token> tokens;
  final double tokenAmountInput;
  final String recipentAddress;
  final EthereumChain withdrawTargetChain;
  final List<VaultData> vaults;
  final bool isVaultsLoading;
  final String? vaultsError;
  
  // Synthetix V3 account data
  final int synthetixAccountId;
  final BigInt synthetixCollateralDeposited;
  final BigInt synthetixCollateralAssigned;
  final BigInt synthetixCollateralAvailable;
  final BigInt synthetixDebt;
  final BigInt synthetixCollateralRatio; // 18 decimals (e.g., 400e18 = 400%)
  final bool hasSynthetixAccount;
  final bool isSynthetixAccountLoading;

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
        tokenAmountInput,
        recipentAddress,
        withdrawTargetChain,
        vaults,
        isVaultsLoading,
        vaultsError,
        synthetixAccountId,
        synthetixCollateralDeposited,
        synthetixCollateralAssigned,
        synthetixCollateralAvailable,
        synthetixDebt,
        synthetixCollateralRatio,
        hasSynthetixAccount,
        isSynthetixAccountLoading,
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
    double? tokenAmountInput,
    String? recipentAddress,
    EthereumChain? withdrawTargetChain,
    List<VaultData>? vaults,
    bool? isVaultsLoading,
    String? vaultsError,
    int? synthetixAccountId,
    BigInt? synthetixCollateralDeposited,
    BigInt? synthetixCollateralAssigned,
    BigInt? synthetixCollateralAvailable,
    BigInt? synthetixDebt,
    BigInt? synthetixCollateralRatio,
    bool? hasSynthetixAccount,
    bool? isSynthetixAccountLoading,
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
      tokenAmountInput: tokenAmountInput ?? this.tokenAmountInput,
      recipentAddress: recipentAddress ?? this.recipentAddress,
      withdrawTargetChain: withdrawTargetChain ?? this.withdrawTargetChain,
      vaults: vaults ?? this.vaults,
      isVaultsLoading: isVaultsLoading ?? this.isVaultsLoading,
      vaultsError: vaultsError ?? this.vaultsError,
      synthetixAccountId: synthetixAccountId ?? this.synthetixAccountId,
      synthetixCollateralDeposited: synthetixCollateralDeposited ?? this.synthetixCollateralDeposited,
      synthetixCollateralAssigned: synthetixCollateralAssigned ?? this.synthetixCollateralAssigned,
      synthetixCollateralAvailable: synthetixCollateralAvailable ?? this.synthetixCollateralAvailable,
      synthetixDebt: synthetixDebt ?? this.synthetixDebt,
      synthetixCollateralRatio: synthetixCollateralRatio ?? this.synthetixCollateralRatio,
      hasSynthetixAccount: hasSynthetixAccount ?? this.hasSynthetixAccount,
      isSynthetixAccountLoading: isSynthetixAccountLoading ?? this.isSynthetixAccountLoading,
    );
  }
}
