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
    BigInt? synthetixAccountId,
    BigInt? synthetixCollateralDeposited,
    BigInt? synthetixCollateralAssigned,
    BigInt? synthetixCollateralAvailable,
    BigInt? synthetixDebt,
    BigInt? synthetixCollateralRatio,
    this.hasSynthetixAccount = false,
    this.isSynthetixAccountLoading = false,
    // axUSD tracking
    BigInt? axUsdBalance,
    BigInt? axUsdInAccount,
    // Server-sourced wallet balances
    this.serverUsdcBalance = 0,
    this.serverMaticBalance = 0,
    this.serverGasPriceGwei = 0,
    this.serverAxBalance = 0,
    this.withdrawInitialTabIndex = 0,
    // collateral selection & mint UI
    this.selectedCollateral,
    this.mintSliderValue = 0.5,
    this.synthetixTxStatus = SynthetixTxStatus.idle,
    this.synthetixTxError,
  })  : withdrawTargetChain = withdrawTargetChain ?? chain,
        synthetixAccountId = synthetixAccountId ?? BigInt.zero,
        synthetixCollateralDeposited =
            synthetixCollateralDeposited ?? _zeroBigInt,
        synthetixCollateralAssigned =
            synthetixCollateralAssigned ?? _zeroBigInt,
        synthetixCollateralAvailable =
            synthetixCollateralAvailable ?? _zeroBigInt,
        synthetixDebt = synthetixDebt ?? _zeroBigInt,
        synthetixCollateralRatio = synthetixCollateralRatio ?? _zeroBigInt,
        axUsdBalance = axUsdBalance ?? _zeroBigInt,
        axUsdInAccount = axUsdInAccount ?? _zeroBigInt;

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
  final BigInt synthetixAccountId;
  final BigInt synthetixCollateralDeposited;
  final BigInt synthetixCollateralAssigned;
  final BigInt synthetixCollateralAvailable;
  final BigInt synthetixDebt;
  final BigInt synthetixCollateralRatio; // 18 decimals (e.g., 400e18 = 400%)
  final bool hasSynthetixAccount;
  final bool isSynthetixAccountLoading;

  /// axUSD balance sitting in the wallet (withdrawn from CoreProxy).
  final BigInt axUsdBalance;

  /// axUSD minted but still inside the CoreProxy account (not yet withdrawn).
  final BigInt axUsdInAccount;

  /// The collateral token currently selected in the deposit / wrap UI.
  /// Null = use chain default (AX).
  final CollateralInfo? selectedCollateral;

  /// Fraction of safe-maximum axUSD to mint (0.0–1.0). Default 0.5 = 50%.
  final double mintSliderValue;

  /// Progress status of the current multi-step Synthetix transaction.
  final SynthetixTxStatus synthetixTxStatus;

  /// Non-null when [synthetixTxStatus] == [SynthetixTxStatus.error].
  final String? synthetixTxError;

  /// USDC balance from server (human-readable USD, 6-decimal adjusted).
  final double serverUsdcBalance;
  /// Native POL/MATIC balance from server (human-readable, 18-decimal adjusted).
  final double serverMaticBalance;
  /// Gas price in gwei from server.
  final double serverGasPriceGwei;
  /// AX balance from server (human-readable, 18-decimal adjusted).
  final double serverAxBalance;

  /// Default tab index when navigating to withdraw page.
  final int withdrawInitialTabIndex;

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
        axUsdBalance,
        axUsdInAccount,
        selectedCollateral,
        mintSliderValue,
        synthetixTxStatus,
        synthetixTxError,
        serverUsdcBalance,
        serverMaticBalance,
        serverGasPriceGwei,
        serverAxBalance,
        withdrawInitialTabIndex,
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
    BigInt? synthetixAccountId,
    BigInt? synthetixCollateralDeposited,
    BigInt? synthetixCollateralAssigned,
    BigInt? synthetixCollateralAvailable,
    BigInt? synthetixDebt,
    BigInt? synthetixCollateralRatio,
    bool? hasSynthetixAccount,
    bool? isSynthetixAccountLoading,
    BigInt? axUsdBalance,
    BigInt? axUsdInAccount,
    CollateralInfo? selectedCollateral,
    double? mintSliderValue,
    SynthetixTxStatus? synthetixTxStatus,
    String? synthetixTxError,
    double? serverUsdcBalance,
    double? serverMaticBalance,
    double? serverGasPriceGwei,
    double? serverAxBalance,
    int? withdrawInitialTabIndex,
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
      synthetixCollateralDeposited:
          synthetixCollateralDeposited ?? this.synthetixCollateralDeposited,
      synthetixCollateralAssigned:
          synthetixCollateralAssigned ?? this.synthetixCollateralAssigned,
      synthetixCollateralAvailable:
          synthetixCollateralAvailable ?? this.synthetixCollateralAvailable,
      synthetixDebt: synthetixDebt ?? this.synthetixDebt,
      synthetixCollateralRatio:
          synthetixCollateralRatio ?? this.synthetixCollateralRatio,
      hasSynthetixAccount: hasSynthetixAccount ?? this.hasSynthetixAccount,
      isSynthetixAccountLoading:
          isSynthetixAccountLoading ?? this.isSynthetixAccountLoading,
      axUsdBalance: axUsdBalance ?? this.axUsdBalance,
      axUsdInAccount: axUsdInAccount ?? this.axUsdInAccount,
      selectedCollateral: selectedCollateral ?? this.selectedCollateral,
      mintSliderValue: mintSliderValue ?? this.mintSliderValue,
      synthetixTxStatus: synthetixTxStatus ?? this.synthetixTxStatus,
      synthetixTxError: synthetixTxError ?? this.synthetixTxError,
      serverUsdcBalance: serverUsdcBalance ?? this.serverUsdcBalance,
      serverMaticBalance: serverMaticBalance ?? this.serverMaticBalance,
      serverGasPriceGwei: serverGasPriceGwei ?? this.serverGasPriceGwei,
      serverAxBalance: serverAxBalance ?? this.serverAxBalance,
      withdrawInitialTabIndex:
          withdrawInitialTabIndex ?? this.withdrawInitialTabIndex,
    );
  }
}
