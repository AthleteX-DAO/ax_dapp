import 'dart:async';

import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'earn_page_event.dart';
part 'earn_page_state.dart';

class EarnPageBloc extends Bloc<EarnPageEvent, EarnPageState> {
  EarnPageBloc({
    required WalletRepository walletRepository,
    VaultRepository? vaultRepository,
    StreamAppDataChangesUseCase? streamAppDataChanges,
  })  : _vaultRepository = vaultRepository,
        _walletRepository = walletRepository,
        _streamAppDataChanges = streamAppDataChanges,
        super(const EarnPageState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<ExpandTile>(_onExpandTile);
    on<CollapseAllTiles>(_onCollapseAllTiles);
    on<UpdateAmount>(_onUpdateAmount);
    on<UpdateLeverage>(_onUpdateLeverage);
    on<RefreshCollateralRatioNow>(_onRefreshCollateralRatioNow);
    on<SubmitDepositForm>(_onSubmitDepositForm);
    on<SubmitWithdrawForm>(_onSubmitWithdrawForm);
    on<SubmitMintForm>(_onSubmitMintForm);
    on<SubmitBurnForm>(_onSubmitBurnForm);
    on<PollTransaction>(_onPollTransaction);
    on<TransactionConfirmed>(_onTransactionConfirmed);
    on<TransactionFailed>(_onTransactionFailed);
    on<CloseTransactionModal>(_onCloseTransactionModal);
    on<FetchPlatformTVL>(_onFetchPlatformTVL);

    // Subscribe to chain changes (updates VaultRepository + re-fetches TVL).
    if (_streamAppDataChanges != null) add(const WatchAppDataChangesStarted());

    // Fetch platform TVL on initialization
    add(const FetchPlatformTVL());
  }

  final VaultRepository? _vaultRepository;
  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase? _streamAppDataChanges;

  /// Debounce timer for C-ratio queries
  Timer? _debounceTimer;

  /// Transaction polling timer
  Timer? _pollingTimer;

  /// Current operation (for transaction handling)
  String? _currentOperation;
  double? _currentOperationAmount;
  String? _currentOperationCollateral;

  /// Watch for chain/wallet changes and update VaultRepository accordingly.
  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted event,
    Emitter<EarnPageState> emit,
  ) async {
    if (_streamAppDataChanges == null) return;
    await emit.onEach<AppData>(
      _streamAppDataChanges!.appDataChanges,
      onData: (appData) {
        // Propagate new chain + web3 client into VaultRepository.
        _vaultRepository?.updateChain(appData.chain);
        emit(state.copyWith(selectedChain: appData.chain));
        // Re-fetch TVL for the newly active chain.
        add(const FetchPlatformTVL());
      },
    );
  }

  /// Fetch platform TVL
  Future<void> _onFetchPlatformTVL(
    FetchPlatformTVL event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(isPlatformTVLLoading: true));
    try {
      final tvl = await _vaultRepository?.getPlatformTVL() ?? 0.0;
      emit(state.copyWith(
        platformTVL: tvl,
        isPlatformTVLLoading: false,
      ),);
    } catch (e) {
      emit(state.copyWith(isPlatformTVLLoading: false));
    }
  }

  /// Handle tile expansion
  Future<void> _onExpandTile(
    ExpandTile event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(expandedTile: event.tileType));
  }

  /// Handle collapse all
  Future<void> _onCollapseAllTiles(
    CollapseAllTiles event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(expandedTile: TileType.earnSimple));
  }

  /// Handle amount input with debouncing
  Future<void> _onUpdateAmount(
    UpdateAmount event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(currentAmount: event.amount));

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    // Emit loading state
    emit(state.copyWith(isCollateralRatioLoading: true));

    // Set up new debounce timer (500ms)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        // Fetch live C-ratio
        final cRatio = await _vaultRepository?.getCollateralRatio(
          collateralAddress: '0xc43708f8987Df3f3681801e5e640667D86Ce3C30', // fUSDC or similar
        ) ?? 200.0;
        emit(state.copyWith(
          collateralRatio: cRatio,
          isCollateralRatioLoading: false,
        ),);
      } catch (e) {
        emit(state.copyWith(isCollateralRatioLoading: false));
      }
    });
  }

  /// Handle leverage slider update
  Future<void> _onUpdateLeverage(
    UpdateLeverage event,
    Emitter<EarnPageState> emit,
  ) async {
    // Clamp leverage between 1.0 and 2.0
    final clampedLeverage = event.leverage.clamp(1.0, 2.0);
    emit(state.copyWith(currentLeverage: clampedLeverage));

    // Refresh C-ratio when leverage changes
    add(const RefreshCollateralRatioNow());
  }

  /// Refresh C-ratio immediately (e.g., on button hover)
  Future<void> _onRefreshCollateralRatioNow(
    RefreshCollateralRatioNow event,
    Emitter<EarnPageState> emit,
  ) async {
    // Cancel ongoing debounce
    _debounceTimer?.cancel();

    emit(state.copyWith(isCollateralRatioLoading: true));

    try {
      final cRatio = await _vaultRepository?.getCollateralRatio(
        collateralAddress: '0xc43708f8987Df3f3681801e5e640667D86Ce3C30',
      ) ?? 200.0;
      emit(state.copyWith(
        collateralRatio: cRatio,
        isCollateralRatioLoading: false,
      ),);
    } catch (e) {
      emit(state.copyWith(isCollateralRatioLoading: false));
    }
  }

  /// Submit deposit form and initiate transaction
  Future<void> _onSubmitDepositForm(
    SubmitDepositForm event,
    Emitter<EarnPageState> emit,
  ) async {
    try {
      debugPrint('🔵 [DEPOSIT] ===== STARTING DEPOSIT FLOW =====');
      debugPrint('🔵 [DEPOSIT] Event: vaultSymbol=${event.vaultSymbol}, amount=${event.amount}, leverage=${event.leverage}');
      
      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.approve,
      ),);

      // Store operation details
      _currentOperation = 'deposit';
      _currentOperationAmount = event.amount;

      if (_vaultRepository == null) {
        debugPrint('❌ [DEPOSIT] Vault repository is NULL');
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault repository not available',
        ),);
        return;
      }

      // Fetch vault to get details
      debugPrint('🟡 [DEPOSIT] Fetching vault: ${event.vaultSymbol}');
      final vault = await _vaultRepository!.fetchVault(event.vaultSymbol);
      if (vault == null) {
        debugPrint('❌ [DEPOSIT] Vault not found: ${event.vaultSymbol}');
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault not found',
        ),);
        return;
      }

      debugPrint('✅ [DEPOSIT] Vault fetched: ${vault.toString()}');
      debugPrint('✅ [DEPOSIT] Vault details:');
      debugPrint('   - symbol: ${vault.symbol}');
      debugPrint('   - collateralAddress: ${vault.collateralAddress}');
      debugPrint('   - poolId: ${vault.poolId}');
      debugPrint('   - vaultAddress: ${vault.vaultAddress}');

      _currentOperationCollateral = vault.collateralAddress;

      // Emit confirm step
      emit(state.copyWith(transactionStep: TransactionStep.confirm));

      // Call deposit with custom leverage
      final leverageBigInt = BigInt.from((event.leverage * 1e18).toInt());
      debugPrint('🟡 [DEPOSIT] Leverage calculation:');
      debugPrint('   - leverage from UI: ${event.leverage}');
      debugPrint('   - leverage * 1e18: ${(event.leverage * 1e18).toInt()}');
      debugPrint('   - leverageBigInt: $leverageBigInt');
      
      debugPrint('🟡 [DEPOSIT] Calling vault_repository.deposit()...');
      final txHash = await _vaultRepository!.deposit(
        vault: vault,
        amount: event.amount,
      );
      debugPrint('✅ [DEPOSIT] Deposit transaction submitted: $txHash');

      // Move to pending step and start polling
      emit(state.copyWith(
        transactionStep: TransactionStep.pending,
        transactionHash: txHash,
      ),);

      add(PollTransaction(txHash));
    } catch (e, stackTrace) {
      debugPrint('❌ [DEPOSIT] ERROR: $e');
      debugPrint('❌ [DEPOSIT] StackTrace: $stackTrace');
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ),);
    }
  }

  /// Submit withdraw form
  Future<void> _onSubmitWithdrawForm(
    SubmitWithdrawForm event,
    Emitter<EarnPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.confirm,
      ),);

      _currentOperation = 'withdraw';
      _currentOperationAmount = event.amount;

      if (_vaultRepository == null) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault repository not available',
        ),);
        return;
      }

      final vault = await _vaultRepository!.fetchVault(event.vaultSymbol);
      if (vault == null) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault not found',
        ),);
        return;
      }

      _currentOperationCollateral = vault.collateralAddress;

      emit(state.copyWith(transactionStep: TransactionStep.pending));

      final txHash = await _vaultRepository!.withdraw(
        vault: vault,
        amount: event.amount,
      );

      emit(state.copyWith(transactionHash: txHash));
      add(PollTransaction(txHash));
    } catch (e) {
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ),);
    }
  }

  /// Submit mint stablecoins form
  Future<void> _onSubmitMintForm(
    SubmitMintForm event,
    Emitter<EarnPageState> emit,
  ) async {
    debugPrint('🔵 [EARN_BLOC] _onSubmitMintForm called');
    debugPrint('   amount: ${event.amount}');
    debugPrint('   collateralAddress: ${event.collateralAddress}');
    debugPrint('   vaultRepository: ${_vaultRepository != null ? "AVAILABLE" : "NULL"}');
    
    try {
      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.confirm,
      ),);

      _currentOperation = 'mint';
      _currentOperationAmount = event.amount;
      _currentOperationCollateral = event.collateralAddress;

      emit(state.copyWith(transactionStep: TransactionStep.pending));

      if (_vaultRepository == null) {
        debugPrint('❌ [EARN_BLOC] VaultRepository is NULL!');
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault repository not available',
        ));
        return;
      }

      debugPrint('🟡 [EARN_BLOC] Calling mintStablecoins...');
      final txHash = await _vaultRepository!.mintStablecoins(
        amount: event.amount,
        collateralAddress: event.collateralAddress,
      );
      debugPrint('✅ [EARN_BLOC] mintStablecoins returned: $txHash');

      if (txHash.isEmpty) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Failed to initiate mint transaction',
        ));
        return;
      }

      emit(state.copyWith(transactionHash: txHash));
      add(PollTransaction(txHash));
    } catch (e, stack) {
      debugPrint('❌ [EARN_BLOC] Mint error: $e');
      debugPrint('❌ [EARN_BLOC] Stack: $stack');
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ));
    }
  }

  /// Submit burn (repay) stablecoins form
  Future<void> _onSubmitBurnForm(
    SubmitBurnForm event,
    Emitter<EarnPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.confirm,
      ),);

      _currentOperation = 'burn';
      _currentOperationAmount = event.amount;
      _currentOperationCollateral = event.collateralAddress;

      emit(state.copyWith(transactionStep: TransactionStep.pending));

      final txHash = await _vaultRepository?.burnStablecoins(
        amount: event.amount,
        collateralAddress: event.collateralAddress,
      ) ?? '';

      if (txHash.isEmpty) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Failed to initiate burn transaction',
        ),);
        return;
      }

      emit(state.copyWith(transactionHash: txHash));
      add(PollTransaction(txHash));
    } catch (e) {
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ),);
    }
  }

  /// Poll transaction receipt
  Future<void> _onPollTransaction(
    PollTransaction event,
    Emitter<EarnPageState> emit,
  ) async {
    // Cancel any existing polling timer
    _pollingTimer?.cancel();

    var attempts = 0;
    const maxAttempts = 60; // 60 * 2s = 120s timeout
    const pollInterval = Duration(seconds: 2);

    _pollingTimer = Timer.periodic(pollInterval, (_) async {
      attempts++;

      try {
        final receipt = await _vaultRepository?.getTransactionReceipt(event.txHash);

        if (receipt != null) {
          _pollingTimer?.cancel();

          if (receipt.status == true) {
            // Transaction succeeded
            emit(state.copyWith(
              transactionStep: TransactionStep.success,
              transactionStatus: TransactionStatus.success,
            ),);

            // Auto-dismiss after 2 seconds
            await Future.delayed(const Duration(seconds: 2));
            add(const CloseTransactionModal());
          } else {
            // Transaction reverted
            _pollingTimer?.cancel();
            emit(state.copyWith(
              transactionStatus: TransactionStatus.error,
              transactionError: 'Transaction failed on-chain',
            ),);
          }
        } else if (attempts >= maxAttempts) {
          // Timeout
          _pollingTimer?.cancel();
          emit(state.copyWith(
            transactionStatus: TransactionStatus.error,
            transactionError: 'Transaction confirmation timeout',
          ),);
        }
      } catch (e) {
        if (attempts >= maxAttempts) {
          _pollingTimer?.cancel();
          emit(state.copyWith(
            transactionStatus: TransactionStatus.error,
            transactionError: 'Error polling transaction: $e',
          ),);
        }
      }
    });
  }

  /// Handle transaction confirmed
  Future<void> _onTransactionConfirmed(
    TransactionConfirmed event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(
      transactionStatus: TransactionStatus.success,
      transactionStep: TransactionStep.success,
    ),);
  }

  /// Handle transaction failed
  Future<void> _onTransactionFailed(
    TransactionFailed event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(
      transactionStatus: TransactionStatus.error,
      transactionError: event.error,
    ),);
  }

  /// Close transaction modal
  Future<void> _onCloseTransactionModal(
    CloseTransactionModal event,
    Emitter<EarnPageState> emit,
  ) async {
    _pollingTimer?.cancel();
    emit(state.copyWith(
      showTransactionModal: false,
      transactionStatus: TransactionStatus.idle,
      transactionStep: TransactionStep.confirm,
      transactionHash: '',
      transactionError: '',
      currentAmount: 0,
      currentLeverage: 1,
    ),);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _pollingTimer?.cancel();
    return super.close();
  }
}
