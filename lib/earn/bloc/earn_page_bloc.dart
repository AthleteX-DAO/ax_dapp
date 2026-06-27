import 'dart:async';

import 'package:ax_dapp/api/ax_api_client.dart';
import 'package:ax_dapp/config/synthetix_config.dart';

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
    AxApiClient? axApiClient,
  })  : _vaultRepository = vaultRepository,
        _walletRepository = walletRepository,
        _streamAppDataChanges = streamAppDataChanges,
        _axApiClient = axApiClient,
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
    on<_TransactionPollResult>(_onTransactionPollResult);
    on<_CollateralRatioResult>(_onCollateralRatioResult);
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
  final AxApiClient? _axApiClient;

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

  /// Fetch platform TVL — API-first with VaultRepository fallback
  Future<void> _onFetchPlatformTVL(
    FetchPlatformTVL event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(isPlatformTVLLoading: true));
    try {
      double tvl = 0.0;
      // Try API first
      if (_axApiClient != null) {
        try {
          final pools = await _axApiClient!.fetchPools();
          if (pools.isNotEmpty) {
            // For each pool's collateral, get the price
            for (final pool in pools) {
              for (final collateral in pool.collateralTypes) {
                final price =
                    await _axApiClient!.fetchCollateralPrice(collateral);
                if (price != null) {
                  tvl += price;
                }
              }
            }
            debugPrint('🔷 EarnPageBloc TVL from API: \$$tvl');
          }
        } catch (e) {
          debugPrint('🔷 EarnPageBloc API TVL failed, falling back: $e');
          tvl = await _vaultRepository?.getPlatformTVL() ?? 0.0;
        }
      } else {
        tvl = await _vaultRepository?.getPlatformTVL() ?? 0.0;
      }
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

    // Set up new debounce timer (500ms) — use add() not emit()
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final cRatio = await _vaultRepository?.getCollateralRatio(
          collateralAddress: SynthetixConfig.axToken,
        ) ?? 200.0;
        add(_CollateralRatioResult(ratio: cRatio));
      } catch (e) {
        debugPrint('C-ratio fetch error: $e');
        add(const _CollateralRatioResult(ratio: 200.0));
      }
    });
  }

  /// Handle the result from debounce timer or refresh.
  Future<void> _onCollateralRatioResult(
    _CollateralRatioResult event,
    Emitter<EarnPageState> emit,
  ) async {
    emit(state.copyWith(
      collateralRatio: event.ratio,
      isCollateralRatioLoading: false,
    ));
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
        collateralAddress: SynthetixConfig.axToken,
      ) ?? 200.0;
      emit(state.copyWith(
        collateralRatio: cRatio,
        isCollateralRatioLoading: false,
      ),);
    } catch (e) {
      emit(state.copyWith(isCollateralRatioLoading: false));
    }
  }

  /// Submit deposit form — API-first with VaultRepository fallback.
  ///
  /// API path: buildDeposit → signAndSendUnsignedTx → poll.
  /// Fallback: VaultRepository.deposit() (handles approve+deposit+delegate).
  Future<void> _onSubmitDepositForm(
    SubmitDepositForm event,
    Emitter<EarnPageState> emit,
  ) async {
    try {
      debugPrint('🔵 [DEPOSIT] ===== STARTING DEPOSIT FLOW =====');
      debugPrint('🔵 [DEPOSIT] Event: vaultSymbol=${event.vaultSymbol}, '
          'amount=${event.amount}, leverage=${event.leverage}');

      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.approve,
      ));

      _currentOperation = 'deposit';
      _currentOperationAmount = event.amount;

      if (_vaultRepository == null) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault repository not available',
        ));
        return;
      }

      final vault = await _vaultRepository!.fetchVault(event.vaultSymbol);
      if (vault == null) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault not found',
        ));
        return;
      }
      _currentOperationCollateral = vault.collateralAddress;

      emit(state.copyWith(transactionStep: TransactionStep.confirm));

      String txHash;

      // ── API-first path ──────────────────────────────────────────
      final wallet = _walletRepository.currentWallet.address;
      final accountId = _vaultRepository!.accountId.toInt();
      if (_axApiClient != null && wallet.isNotEmpty && accountId > 0) {
        try {
          debugPrint('🔷 [DEPOSIT] Trying API path...');
          final amountWei =
              BigInt.from(event.amount * 1e18).toString();

          // Step 1: Build + send approve TX via API
          final approveTx = await _axApiClient!.buildApprove(
            tokenAddress: vault.collateralAddress,
            spender: SynthetixConfig.coreProxy,
            amount: amountWei,
            wallet: wallet,
          );
          if (approveTx != null) {
            debugPrint('🔷 [DEPOSIT] API approve TX built, signing...');
            final approveHash = await _vaultRepository!.signAndSendUnsignedTx(
              to: approveTx.to,
              data: approveTx.data,
              value: approveTx.value,
              gasEstimate: approveTx.gasEstimate,
            );
            debugPrint('✅ [DEPOSIT] Approve sent: $approveHash');
          }

          // Step 2: Build + send deposit TX via API
          emit(state.copyWith(transactionStep: TransactionStep.pending));
          final depositTx = await _axApiClient!.buildDeposit(
            accountId: accountId,
            collateralType: vault.collateralAddress,
            amount: amountWei,
            wallet: wallet,
          );
          if (depositTx == null) throw Exception('API returned null deposit TX');

          txHash = await _vaultRepository!.signAndSendUnsignedTx(
            to: depositTx.to,
            data: depositTx.data,
            value: depositTx.value,
            gasEstimate: depositTx.gasEstimate,
          );
          debugPrint('✅ [DEPOSIT] API deposit TX sent: $txHash');

          emit(state.copyWith(transactionHash: txHash));
          add(PollTransaction(txHash));
          return;
        } catch (apiError) {
          debugPrint('⚠️ [DEPOSIT] API path failed, falling back: $apiError');
        }
      }

      // ── VaultRepository fallback ────────────────────────────────
      debugPrint('🟡 [DEPOSIT] Using VaultRepository fallback...');
      txHash = await _vaultRepository!.deposit(
        vault: vault,
        amount: event.amount,
      );
      debugPrint('✅ [DEPOSIT] VaultRepo deposit submitted: $txHash');

      emit(state.copyWith(
        transactionStep: TransactionStep.pending,
        transactionHash: txHash,
      ));
      add(PollTransaction(txHash));
    } catch (e, stackTrace) {
      debugPrint('❌ [DEPOSIT] ERROR: $e');
      debugPrint('❌ [DEPOSIT] StackTrace: $stackTrace');
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ));
    }
  }

  /// Submit withdraw form — API-first with VaultRepository fallback.
  Future<void> _onSubmitWithdrawForm(
    SubmitWithdrawForm event,
    Emitter<EarnPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.confirm,
      ));

      _currentOperation = 'withdraw';
      _currentOperationAmount = event.amount;

      if (_vaultRepository == null) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault repository not available',
        ));
        return;
      }

      final vault = await _vaultRepository!.fetchVault(event.vaultSymbol);
      if (vault == null) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault not found',
        ));
        return;
      }
      _currentOperationCollateral = vault.collateralAddress;

      emit(state.copyWith(transactionStep: TransactionStep.pending));

      String txHash;

      // ── API-first path ──────────────────────────────────────────
      final wallet = _walletRepository.currentWallet.address;
      final accountId = _vaultRepository!.accountId.toInt();
      if (_axApiClient != null && wallet.isNotEmpty && accountId > 0) {
        try {
          debugPrint('🔷 [WITHDRAW] Trying API path...');
          final amountWei =
              BigInt.from(event.amount * 1e18).toString();

          final withdrawTx = await _axApiClient!.buildWithdraw(
            accountId: accountId,
            collateralType: vault.collateralAddress,
            amount: amountWei,
            wallet: wallet,
          );
          if (withdrawTx == null) throw Exception('API returned null');

          txHash = await _vaultRepository!.signAndSendUnsignedTx(
            to: withdrawTx.to,
            data: withdrawTx.data,
            value: withdrawTx.value,
            gasEstimate: withdrawTx.gasEstimate,
          );
          debugPrint('✅ [WITHDRAW] API TX sent: $txHash');

          emit(state.copyWith(transactionHash: txHash));
          add(PollTransaction(txHash));
          return;
        } catch (apiError) {
          debugPrint('⚠️ [WITHDRAW] API path failed, falling back: $apiError');
        }
      }

      // ── VaultRepository fallback ────────────────────────────────
      txHash = await _vaultRepository!.withdraw(
        vault: vault,
        amount: event.amount,
      );

      emit(state.copyWith(transactionHash: txHash));
      add(PollTransaction(txHash));
    } catch (e) {
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ));
    }
  }

  /// Submit mint stablecoins form — API-first with VaultRepository fallback.
  Future<void> _onSubmitMintForm(
    SubmitMintForm event,
    Emitter<EarnPageState> emit,
  ) async {
    debugPrint('🔵 [MINT] _onSubmitMintForm: amount=${event.amount}, '
        'collateral=${event.collateralAddress}');

    try {
      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.confirm,
      ));

      _currentOperation = 'mint';
      _currentOperationAmount = event.amount;
      _currentOperationCollateral = event.collateralAddress;

      emit(state.copyWith(transactionStep: TransactionStep.pending));

      if (_vaultRepository == null) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Vault repository not available',
        ));
        return;
      }

      String txHash;

      // ── API-first path ──────────────────────────────────────────
      final wallet = _walletRepository.currentWallet.address;
      final accountId = _vaultRepository!.accountId.toInt();
      if (_axApiClient != null && wallet.isNotEmpty && accountId > 0) {
        try {
          debugPrint('🔷 [MINT] Trying API path...');
          final amountWei =
              BigInt.from(event.amount * 1e18).toString();

          final mintTx = await _axApiClient!.buildMintUsd(
            accountId: accountId,
            poolId: 1,
            collateralType: event.collateralAddress,
            amount: amountWei,
            wallet: wallet,
          );
          if (mintTx == null) throw Exception('API returned null');

          txHash = await _vaultRepository!.signAndSendUnsignedTx(
            to: mintTx.to,
            data: mintTx.data,
            value: mintTx.value,
            gasEstimate: mintTx.gasEstimate,
          );
          debugPrint('✅ [MINT] API TX sent: $txHash');

          emit(state.copyWith(transactionHash: txHash));
          add(PollTransaction(txHash));
          return;
        } catch (apiError) {
          debugPrint('⚠️ [MINT] API path failed, falling back: $apiError');
        }
      }

      // ── VaultRepository fallback ────────────────────────────────
      txHash = await _vaultRepository!.mintStablecoins(
        amount: event.amount,
        collateralAddress: event.collateralAddress,
      );

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
      debugPrint('❌ [MINT] Error: $e');
      debugPrint('❌ [MINT] Stack: $stack');
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ));
    }
  }

  /// Submit burn (repay) stablecoins form — API-first with VaultRepository fallback.
  Future<void> _onSubmitBurnForm(
    SubmitBurnForm event,
    Emitter<EarnPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        showTransactionModal: true,
        transactionStatus: TransactionStatus.pending,
        transactionStep: TransactionStep.confirm,
      ));

      _currentOperation = 'burn';
      _currentOperationAmount = event.amount;
      _currentOperationCollateral = event.collateralAddress;

      emit(state.copyWith(transactionStep: TransactionStep.pending));

      String txHash;

      // ── API-first path ──────────────────────────────────────────
      final wallet = _walletRepository.currentWallet.address;
      final accountId = _vaultRepository?.accountId.toInt() ?? 0;
      if (_axApiClient != null && wallet.isNotEmpty && accountId > 0) {
        try {
          debugPrint('🔷 [BURN] Trying API path...');
          final amountWei =
              BigInt.from(event.amount * 1e18).toString();

          final burnTx = await _axApiClient!.buildBurnUsd(
            accountId: accountId,
            poolId: 1,
            collateralType: event.collateralAddress,
            amount: amountWei,
            wallet: wallet,
          );
          if (burnTx == null) throw Exception('API returned null');

          txHash = await _vaultRepository!.signAndSendUnsignedTx(
            to: burnTx.to,
            data: burnTx.data,
            value: burnTx.value,
            gasEstimate: burnTx.gasEstimate,
          );
          debugPrint('✅ [BURN] API TX sent: $txHash');

          emit(state.copyWith(transactionHash: txHash));
          add(PollTransaction(txHash));
          return;
        } catch (apiError) {
          debugPrint('⚠️ [BURN] API path failed, falling back: $apiError');
        }
      }

      // ── VaultRepository fallback ────────────────────────────────
      txHash = await _vaultRepository?.burnStablecoins(
        amount: event.amount,
        collateralAddress: event.collateralAddress,
      ) ?? '';

      if (txHash.isEmpty) {
        emit(state.copyWith(
          transactionStatus: TransactionStatus.error,
          transactionError: 'Failed to initiate burn transaction',
        ));
        return;
      }

      emit(state.copyWith(transactionHash: txHash));
      add(PollTransaction(txHash));
    } catch (e) {
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: e.toString(),
      ));
    }
  }

  /// Poll transaction receipt.
  ///
  /// IMPORTANT: Timer callbacks MUST use `add()` to dispatch events, not
  /// `emit()` directly. Calling `emit` after the handler returns crashes the
  /// bloc with "emit was called after an event handler completed normally".
  Future<void> _onPollTransaction(
    PollTransaction event,
    Emitter<EarnPageState> emit,
  ) async {
    _pollingTimer?.cancel();

    var attempts = 0;
    const maxAttempts = 60;
    const pollInterval = Duration(seconds: 2);

    _pollingTimer = Timer.periodic(pollInterval, (_) async {
      attempts++;
      try {
        final receipt =
            await _vaultRepository?.getTransactionReceipt(event.txHash);
        if (receipt != null) {
          _pollingTimer?.cancel();
          if (receipt.status == true) {
            add(const _TransactionPollResult(success: true));
          } else {
            add(const _TransactionPollResult(
              success: false,
              error: 'Transaction reverted on-chain',
            ));
          }
        } else if (attempts >= maxAttempts) {
          _pollingTimer?.cancel();
          add(const _TransactionPollResult(
            success: false,
            error: 'Transaction confirmation timeout',
          ));
        }
      } catch (e) {
        debugPrint('Poll error (attempt $attempts): $e');
        if (attempts >= maxAttempts) {
          _pollingTimer?.cancel();
          add(_TransactionPollResult(
            success: false,
            error: 'Error polling transaction: $e',
          ));
        }
      }
    });
  }

  /// Handle the result dispatched from the polling timer.
  Future<void> _onTransactionPollResult(
    _TransactionPollResult event,
    Emitter<EarnPageState> emit,
  ) async {
    if (event.success) {
      emit(state.copyWith(
        transactionStep: TransactionStep.success,
        transactionStatus: TransactionStatus.success,
      ));
      // Auto-dismiss after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      add(const CloseTransactionModal());
    } else {
      emit(state.copyWith(
        transactionStatus: TransactionStatus.error,
        transactionError: event.error ?? 'Unknown error',
      ));
    }
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
