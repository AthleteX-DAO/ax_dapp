part of 'earn_page_bloc.dart';

enum TransactionStep { approve, confirm, pending, success }

class EarnPageState extends Equatable {
  const EarnPageState({
    this.expandedTile = TileType.earnSimple,
    this.currentAmount = 0.0,
    this.currentLeverage = 1.0,
    this.collateralRatio = 0.0,
    this.isCollateralRatioLoading = false,
    this.transactionStatus = TransactionStatus.idle,
    this.transactionStep = TransactionStep.confirm,
    this.transactionHash = '',
    this.transactionError = '',
    this.showTransactionModal = false,
    this.platformTVL = 0.0,
    this.isPlatformTVLLoading = false,
  });

  /// Currently expanded tile (null if all collapsed)
  final TileType expandedTile;

  /// Current amount input value
  final double currentAmount;

  /// Current leverage value (1.0 to 2.0)
  final double currentLeverage;

  /// Live collateralization ratio (as percentage, e.g., 200.0 = 200%)
  final double collateralRatio;

  /// Whether C-ratio is currently being fetched
  final bool isCollateralRatioLoading;

  /// Current transaction status
  final TransactionStatus transactionStatus;

  /// Current step in transaction stepper
  final TransactionStep transactionStep;

  /// Transaction hash for polling
  final String transactionHash;

  /// Error message if transaction failed
  final String transactionError;

  /// Whether to show transaction modal
  final bool showTransactionModal;

  /// Total Value Locked across all platform vaults
  final double platformTVL;

  /// Whether platform TVL is currently being fetched
  final bool isPlatformTVLLoading;

  EarnPageState copyWith({
    TileType? expandedTile,
    double? currentAmount,
    double? currentLeverage,
    double? collateralRatio,
    bool? isCollateralRatioLoading,
    TransactionStatus? transactionStatus,
    TransactionStep? transactionStep,
    String? transactionHash,
    String? transactionError,
    bool? showTransactionModal,
    double? platformTVL,
    bool? isPlatformTVLLoading,
  }) {
    return EarnPageState(
      expandedTile: expandedTile ?? this.expandedTile,
      currentAmount: currentAmount ?? this.currentAmount,
      currentLeverage: currentLeverage ?? this.currentLeverage,
      collateralRatio: collateralRatio ?? this.collateralRatio,
      isCollateralRatioLoading:
          isCollateralRatioLoading ?? this.isCollateralRatioLoading,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      transactionStep: transactionStep ?? this.transactionStep,
      transactionHash: transactionHash ?? this.transactionHash,
      transactionError: transactionError ?? this.transactionError,
      showTransactionModal: showTransactionModal ?? this.showTransactionModal,
      platformTVL: platformTVL ?? this.platformTVL,
      isPlatformTVLLoading: isPlatformTVLLoading ?? this.isPlatformTVLLoading,
    );
  }

  @override
  List<Object> get props => [
        expandedTile,
        currentAmount,
        currentLeverage,
        collateralRatio,
        isCollateralRatioLoading,
        transactionStatus,
        transactionStep,
        transactionHash,
        transactionError,
        showTransactionModal,
        platformTVL,
        isPlatformTVLLoading,
      ];
}
enum TransactionStatus { idle, pending, success, error }