// ignore_for_file: unused_field

import 'dart:async';

import 'package:ax_dapp/account/models/models.dart';
import 'package:ax_dapp/account/repository/account_repository.dart';
import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required TokensRepository tokensRepository,
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required AccountRepository accountRepository,
    required VaultRepository vaultRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _streamAppDataChangesUseCase = streamAppDataChanges,
        _accountRepository = accountRepository,
        _vaultRepository = vaultRepository,
        super(
          AccountState(
            chain: walletRepository.currentChain,
            walletAddress: walletRepository.currentWallet.address,
            selectedToken: tokensRepository.currentTokens.first,
          ),
        ) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<AccountDetailsViewRequested>(_onAccountDetailsViewRequested);
    on<AccountWithdrawViewRequested>(_onAccountWithdrawViewRequested);
    on<AccountDepositViewRequested>(_onAccountDepositViewRequested);
    on<AccountBuyAndSellViewRequested>(_onAccountBuyAndSellViewRequested);
    on<AccountTokenViewRequested>(_onAccountTokenViewRequested);
    on<AccountWrapViewRequested>(_onAccountWrapViewRequested);
    on<SelectedAccountAssetsChanged>(_onSelectedAccountAssetsChanged);
    on<SelectTokenRequested>(_onSelectTokenRequested);
    on<UpdateBalanceRequested>(_onUpdateBalanceRequested);
    on<FetchTokenInfoRequested>(_onFetchTokenInfoRequested);
    on<FetchVaultSummariesRequested>(_onFetchVaultSummariesRequested);
    on<UpdateWithdrawInput>(_onUpdateWithdrawInput);
    on<AccountWithdrawConfirm>(_onAccountWithdrawConfirm);
    on<UpdateRecipentAddressRequested>(_onUpdateRecipentAddressRequested);
    on<WithdrawChainSelected>(_onWithdrawChainSelected);
    on<CollateralTypeSelected>(_onCollateralTypeSelected);
    on<MintSliderChanged>(_onMintSliderChanged);
    // Synthetix account handlers
    on<FetchSynthetixAccountRequested>(_onFetchSynthetixAccountRequested);
    on<DepositSynthetixCollateralRequested>(
      _onDepositSynthetixCollateralRequested,
    );
    on<WithdrawSynthetixCollateralRequested>(
      _onWithdrawSynthetixCollateralRequested,
    );
    on<DelegateSynthetixCollateralRequested>(
      _onDelegateSynthetixCollateralRequested,
    );
    on<UndelegateSynthetixCollateralRequested>(
      _onUndelegateSynthetixCollateralRequested,
    );
    on<CreateSynthetixAccountRequested>(_onCreateSynthetixAccountRequested);
    on<MintAxUsdRequested>(_onMintAxUsdRequested);
    on<WrapCollateralRequested>(_onWrapCollateralRequested);
    add(const WatchAppDataChangesStarted());
  }

  final TokensRepository _tokensRepository;
  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;
  final AccountRepository _accountRepository;
  final VaultRepository _vaultRepository;
  Timer? _vaultSummaryTimer;

  FutureOr<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted event,
    Emitter<AccountState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChangesUseCase.appDataChanges,
      onData: (appData) {
        final tokens = appData.tokens;
        final appConfig = appData.appConfig;
        _accountRepository.controller.client.value =
            appConfig.reactiveWeb3Client.value;
        _accountRepository.controller.credentials =
            _walletRepository.credentials.value;
        emit(
          state.copyWith(
            selectedToken: tokens.first,
          ),
        );

        add(const FetchTokenInfoRequested());
        add(const FetchSynthetixAccountRequested());
        add(const FetchVaultSummariesRequested());
        _startVaultSummaryTimer();
      },
    );
  }

  void _startVaultSummaryTimer() {
    _vaultSummaryTimer ??= Timer.periodic(
      const Duration(seconds: 45),
      (_) => add(const FetchVaultSummariesRequested()),
    );
  }

  FutureOr<void> _onFetchTokenInfoRequested(
    FetchTokenInfoRequested event,
    Emitter<AccountState> emit,
  ) async {
    final selectedToken = state.selectedToken;
    final selectedTokenAddress = state.selectedToken.address;
    final balance =
        await _walletRepository.getTokenBalance(selectedToken.address);
    emit(
      state.copyWith(
        selectedToken: selectedToken,
        tokenAddress: selectedTokenAddress,
        tokenBalance: balance,
      ),
    );
  }

  Future<void> _onFetchVaultSummariesRequested(
    FetchVaultSummariesRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isVaultsLoading: true));

    try {
      final vaults = await _vaultRepository.fetchVaults();
      emit(state.copyWith(vaults: vaults, isVaultsLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isVaultsLoading: false,
          vaultsError: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAccountDetailsViewRequested(
    AccountDetailsViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(accountViewStatus: AccountViewStatus.details));
  }

  Future<void> _onAccountWithdrawViewRequested(
    AccountWithdrawViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(accountViewStatus: AccountViewStatus.withdraw));
  }

  Future<void> _onAccountDepositViewRequested(
    AccountDepositViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(accountViewStatus: AccountViewStatus.deposit));
  }

  Future<void> _onAccountBuyAndSellViewRequested(
    AccountBuyAndSellViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(accountViewStatus: AccountViewStatus.buySell));
  }

  Future<void> _onAccountTokenViewRequested(
    AccountTokenViewRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(
        accountViewStatus: AccountViewStatus.token,
        selectedToken: event.token,
      ),
    );
  }

  Future<void> _onAccountWrapViewRequested(
    AccountWrapViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(accountViewStatus: AccountViewStatus.wrap));
  }

  Future<void> _onCollateralTypeSelected(
    CollateralTypeSelected event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(selectedCollateral: event.collateral));
  }

  Future<void> _onMintSliderChanged(
    MintSliderChanged event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(mintSliderValue: event.value.clamp(0.0, 1.0)));
  }

  Future<void> _onAccountWithdrawConfirm(
    AccountWithdrawConfirm event,
    Emitter<AccountState> emit,
  ) async {
    final recipentAddress = state.recipentAddress;
    final tokenAmountInput = state.tokenAmountInput;
    final tokenAddress = state.tokenAddress;
    final decimals = await _walletRepository.getDecimals(tokenAddress);
    await _accountRepository.transerTokens(
      toAddress: recipentAddress,
      tokenAddress: tokenAddress,
      inputAmount: tokenAmountInput,
      tokenDecimals: decimals.toInt(),
    );
  }

  Future<void> _onSelectTokenRequested(
    SelectTokenRequested event,
    Emitter<AccountState> emit,
  ) async {
    final selectedToken = event.token;
    final selectedTokenAddress = selectedToken.address;
    final balance =
        await _walletRepository.getTokenBalance(selectedTokenAddress);
    emit(
      state.copyWith(
        selectedToken: selectedToken,
        tokenAddress: selectedTokenAddress,
        tokenBalance: balance,
        tokenAmountInput: 0,
      ),
    );
  }

  Future<void> _onSelectedAccountAssetsChanged(
    SelectedAccountAssetsChanged event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(state.copyWith(selectedAssets: event.selectedAssets));
    } catch (e) {
      debugPrint('An error occured $e');
    }
  }

  Future<void> _onUpdateBalanceRequested(
    UpdateBalanceRequested event,
    Emitter<AccountState> emit,
  ) async {
    final tokenAddress = state.tokenAddress;
    final balance = await _walletRepository.getTokenBalance(tokenAddress);
    emit(state.copyWith(tokenBalance: balance));
  }

  Future<void> _onUpdateWithdrawInput(
    UpdateWithdrawInput event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(tokenAmountInput: event.tokenAmountInput));
  }

  Future<void> _onUpdateRecipentAddressRequested(
    UpdateRecipentAddressRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(recipentAddress: event.recipentAddress));
  }

  Future<void> _onWithdrawChainSelected(
    WithdrawChainSelected event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(withdrawTargetChain: event.chain));
  }

  @override
  Future<void> close() {
    _vaultSummaryTimer?.cancel();
    return super.close();
  }

  // ========== Synthetix V3 Account Event Handlers ==========

  /// Fetches Synthetix account data (ID, collateral, debt, c-ratio, axUSD balance).
  Future<void> _onFetchSynthetixAccountRequested(
    FetchSynthetixAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (state.walletAddress.isEmpty || state.walletAddress == kEmptyAddress) {
      return;
    }

    debugPrint(
      'AccountBloc._onFetchSynthetixAccountRequested: wallet=${state.walletAddress}',
    );
    emit(state.copyWith(isSynthetixAccountLoading: true));

    try {
      // Get account IDs for this wallet
      debugPrint('>>> Fetching Synthetix account IDs for wallet: ${state.walletAddress}');
      final accountIds = await _accountRepository.getSynthetixAccountIds(
        state.walletAddress,
      );
      debugPrint('>>> Raw accountIds from contract: $accountIds');

      if (accountIds.isEmpty) {
        debugPrint('>>> No Synthetix accounts found');
        emit(
          state.copyWith(
            hasSynthetixAccount: false,
            isSynthetixAccountLoading: false,
          ),
        );
        return;
      }

      // Use first account (primary account)
      debugPrint('>>> accountIds.first: ${accountIds.first}');
      debugPrint('>>> accountIds.first runtimeType: ${accountIds.first.runtimeType}');
      final accountId = accountIds.first.toInt();
      debugPrint('>>> Converted accountId (toInt): $accountId');

      final collateralAddress =
          AthleteXSynthetixConfig.defaultCollateralAddress(state.chain.chainId);
      const poolId = AthleteXSynthetixConfig.defaultPoolId;
      const usdProxy = SynthetixConfig.usdProxy;

      // Fetch account data in parallel
      final results = await Future.wait([
        _accountRepository.getSynthetixAccountCollateral(
          accountId: accountId,
          collateralAddress: collateralAddress,
        ),
        _accountRepository.getSynthetixAvailableCollateral(
          accountId: accountId,
          collateralAddress: collateralAddress,
        ),
        _accountRepository.getSynthetixPositionDebt(
          accountId: accountId,
          poolId: poolId,
          collateralAddress: collateralAddress,
        ),
        _accountRepository.getSynthetixCollateralRatio(
          accountId: accountId,
          poolId: poolId,
          collateralAddress: collateralAddress,
        ),
        // axUSD in wallet (USD proxy ERC-20 balance)
        _accountRepository.getSynthetixAccountCollateral(
          accountId: accountId,
          collateralAddress: usdProxy,
        ),
      ]);

      final collateralData = results[0] as Map<String, BigInt>;
      final availableCollateral = results[1] as BigInt;
      final debt = results[2] as BigInt;
      final cRatio = results[3] as BigInt;
      final axUsdAccountData = results[4] as Map<String, BigInt>;

      // axUSD in CoreProxy account (minted but not withdrawn)
      final axUsdInAccount = axUsdAccountData['totalDeposited'] ?? BigInt.zero;

      // axUSD in wallet: fetch ERC-20 balance directly
      var axUsdWalletBalance = BigInt.zero;
      try {
        axUsdWalletBalance = await _walletRepository.getRawTokenBalance(
          usdProxy,
        );
      } catch (_) {
        // wallet repo may not support getRawTokenBalance — best-effort
      }

      emit(
        state.copyWith(
          synthetixAccountId: accountId,
          synthetixCollateralDeposited: collateralData['totalDeposited'],
          synthetixCollateralAssigned: collateralData['totalAssigned'],
          synthetixCollateralAvailable: availableCollateral,
          synthetixDebt: debt,
          synthetixCollateralRatio: cRatio,
          hasSynthetixAccount: true,
          isSynthetixAccountLoading: false,
          axUsdBalance: axUsdWalletBalance,
          axUsdInAccount: axUsdInAccount,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching Synthetix account: $e');
      emit(
        state.copyWith(
          hasSynthetixAccount: false,
          isSynthetixAccountLoading: false,
        ),
      );
    }
  }

  /// Deposits collateral to Synthetix account, then auto-delegates the full
  /// deposited balance to the default pool (LP path step 1+2 in one shot).
  Future<void> _onDepositSynthetixCollateralRequested(
    DepositSynthetixCollateralRequested event,
    Emitter<AccountState> emit,
  ) async {
    debugPrint('========== DEPOSIT FLOW START ==========');
    debugPrint('>>> ⚠️  CHAIN DETECTION: ${state.chain.chainId} (${state.chain.name})');
    debugPrint('>>> Expected Polygon: 137');
    if (state.chain.chainId != 137) {
      debugPrint('>>> ⚠️  ⚠️  WARNING: NOT ON POLYGON! Please switch to Polygon Mainnet in your wallet!');
    }
    debugPrint('>>> ACCOUNT INFO:');
    debugPrint('>>>   hasSynthetixAccount: ${state.hasSynthetixAccount}');
    debugPrint('>>>   synthetixAccountId (STATE): ${state.synthetixAccountId}');
    debugPrint('>>>   synthetixAccountId type: ${state.synthetixAccountId.runtimeType}');
    
    // CRITICAL FIX: The stored accountId is corrupted. Re-fetch from blockchain.
    debugPrint('>>> RE-FETCHING account ID from blockchain...');
    final freshAccountIds = await _accountRepository.getSynthetixAccountIds(state.walletAddress);
    if (freshAccountIds.isEmpty) {
      debugPrint('>>> ERROR: No accounts found on blockchain!');
      emit(state.copyWith(
        synthetixTxStatus: SynthetixTxStatus.error,
        synthetixTxError: 'No Synthetix account found on blockchain. Please create one first.',
        hasSynthetixAccount: false,
      ));
      return;
    }
    final validAccountId = freshAccountIds.first.toInt();
    debugPrint('>>> FRESH accountId from blockchain: $validAccountId');
    
    // Update state with correct account ID
    emit(state.copyWith(
      synthetixAccountId: validAccountId,
    ));
    
    debugPrint('>>> TRANSACTION INFO:');
    debugPrint('>>>   collateralAddress: ${event.collateralAddress}');
    debugPrint('>>>   amount: ${event.amount}');
    debugPrint('>>>   coreProxy: ${SynthetixConfig.coreProxy}');
    debugPrint('>>>   defaultPoolId: ${AthleteXSynthetixConfig.defaultPoolId}');
    
    // Validate collateral address matches the expected chain
    final expectedCollateral = AthleteXSynthetixConfig.defaultCollateralAddress(state.chain.chainId);
    debugPrint('>>> Expected collateral for chain ${state.chain.chainId}: $expectedCollateral');
    if (event.collateralAddress.toLowerCase() != expectedCollateral.toLowerCase()) {
      debugPrint('>>> ⚠️  ERROR: Collateral address mismatch!');
      debugPrint('>>>    Using: ${event.collateralAddress}');
      debugPrint('>>>    Expected for chain ${state.chain.chainId}: $expectedCollateral');
      emit(state.copyWith(
        synthetixTxStatus: SynthetixTxStatus.error,
        synthetixTxError: 'Wrong network! You are on chain ${state.chain.chainId} but trying to use collateral for a different network. Please switch to Polygon (chain 137) in your wallet.',
      ));
      return;
    }
    
    // Additional validation: ensure we're on Polygon for mainnet operations
    if (state.chain.chainId != 137) {
      debugPrint('>>> ⚠️  WARNING: Not on Polygon mainnet! Transactions may fail.');
    }

    try {
      // Step 1 — approve CoreProxy to spend the collateral token
      debugPrint('========== STEP 1: APPROVE ==========');
      emit(
        state.copyWith(
          isSynthetixAccountLoading: true,
          synthetixTxStatus: SynthetixTxStatus.approving,
        ),
      );

      debugPrint('Approving token ${event.collateralAddress} for spender ${SynthetixConfig.coreProxy}');
      final approveTx = await _accountRepository.approveErc20(
        tokenAddress: event.collateralAddress,
        spenderAddress: SynthetixConfig.coreProxy,
        amount: event.amount,
      );
      debugPrint('Approve tx submitted: $approveTx');
      await _accountRepository.waitForReceipt(approveTx);
      debugPrint('Approve tx confirmed!');

      // Step 2 — deposit (must wait for mining before delegate)
      debugPrint('========== STEP 2: DEPOSIT ==========');
      emit(
        state.copyWith(synthetixTxStatus: SynthetixTxStatus.depositing),
      );

      debugPrint('Depositing collateral: accountId=$validAccountId, collateral=${event.collateralAddress}, amount=${event.amount}');
      final depositTx = await _accountRepository.depositSynthetixCollateral(
        accountId: validAccountId,
        collateralAddress: event.collateralAddress,
        amount: event.amount,
      );
      debugPrint('Deposit tx submitted: $depositTx');
      await _accountRepository.waitForReceipt(depositTx);
      debugPrint('Deposit tx confirmed!');

      // Step 3 — auto-delegate the full deposited balance to the default pool
      debugPrint('========== STEP 3: DELEGATE ==========');
      emit(state.copyWith(synthetixTxStatus: SynthetixTxStatus.delegating));

      // Compute total deposited after this deposit to set delegation
      debugPrint('Fetching account collateral data...');
      final collateralData = await _accountRepository
          .getSynthetixAccountCollateral(
        accountId: validAccountId,
        collateralAddress: event.collateralAddress,
      );
      debugPrint('Collateral data: $collateralData');
      final totalDeposited =
          collateralData['totalDeposited'] ?? event.amount;
      debugPrint('Total deposited: $totalDeposited');

      debugPrint('Delegating: accountId=$validAccountId, poolId=${AthleteXSynthetixConfig.defaultPoolId}, amount=$totalDeposited');
      try {
        final delegateTx = await _accountRepository.delegateSynthetixCollateral(
          accountId: validAccountId,
          poolId: AthleteXSynthetixConfig.defaultPoolId,
          collateralAddress: event.collateralAddress,
          amount: totalDeposited,
        );
        debugPrint('Delegate tx submitted: $delegateTx');
        await _accountRepository.waitForReceipt(delegateTx);
        debugPrint('Delegate tx confirmed!');
        
        emit(
          state.copyWith(synthetixTxStatus: SynthetixTxStatus.done),
        );
      } catch (delegateError) {
        debugPrint('>>> Delegate failed but deposit succeeded: $delegateError');
        debugPrint('>>> Collateral is deposited but not delegated to pool');
        
        // Deposit succeeded, show partial success
        emit(
          state.copyWith(
            synthetixTxStatus: SynthetixTxStatus.done,
            synthetixTxError: 'Deposit successful! Delegate failed (pool may need configuration). Your collateral is deposited but not earning yield yet.',
          ),
        );
      }

      // Refresh account data
      add(const FetchSynthetixAccountRequested());
      debugPrint('========== DEPOSIT FLOW COMPLETE ==========');
    } catch (e, stack) {
      debugPrint('========== DEPOSIT FLOW ERROR ==========');
      debugPrint('Error depositing + delegating collateral: $e');
      debugPrint('Stack trace: $stack');
      emit(
        state.copyWith(
          isSynthetixAccountLoading: false,
          synthetixTxStatus: SynthetixTxStatus.error,
          synthetixTxError: e.toString(),
        ),
      );
    }
  }

  /// Withdraws collateral from Synthetix account back to wallet.
  Future<void> _onWithdrawSynthetixCollateralRequested(
    WithdrawSynthetixCollateralRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (!state.hasSynthetixAccount) return;

    try {
      emit(state.copyWith(isSynthetixAccountLoading: true));

      await _accountRepository.withdrawSynthetixCollateral(
        accountId: state.synthetixAccountId,
        collateralAddress: event.collateralAddress,
        amount: event.amount,
      );

      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error withdrawing collateral: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  /// Delegates collateral to a pool for earning yield.
  Future<void> _onDelegateSynthetixCollateralRequested(
    DelegateSynthetixCollateralRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (!state.hasSynthetixAccount) return;

    try {
      emit(state.copyWith(isSynthetixAccountLoading: true));

      await _accountRepository.delegateSynthetixCollateral(
        accountId: state.synthetixAccountId,
        poolId: event.poolId,
        collateralAddress: event.collateralAddress,
        amount: event.amount,
        leverage: event.leverage,
      );

      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error delegating collateral: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  /// Undelegates collateral from a pool.
  Future<void> _onUndelegateSynthetixCollateralRequested(
    UndelegateSynthetixCollateralRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (!state.hasSynthetixAccount) return;

    try {
      emit(state.copyWith(isSynthetixAccountLoading: true));

      await _accountRepository.undelegateSynthetixCollateral(
        accountId: state.synthetixAccountId,
        poolId: event.poolId,
        collateralAddress: event.collateralAddress,
        amount: event.amount,
      );

      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error undelegating collateral: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  /// Creates a new Synthetix account and shows loading during tx.
  Future<void> _onCreateSynthetixAccountRequested(
    CreateSynthetixAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (state.walletAddress.isEmpty || state.walletAddress == kEmptyAddress) {
      return;
    }

    debugPrint(
      'AccountBloc._onCreateSynthetixAccountRequested: wallet=${state.walletAddress}',
    );
    emit(state.copyWith(isSynthetixAccountLoading: true));

    try {
      await _accountRepository.createSynthetixAccount();
      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error creating Synthetix account: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  /// Mint axUSD against delegated collateral (LP path step 3).
  ///
  /// Calculates amount from [event.sliderValue] × safe-maximum mintable.
  /// Safe-max is derived from the on-chain position debt + c-ratio so that
  /// minting keeps the position at or above [targetCollateralizationRatio].
  /// After minting, immediately withdraws axUSD to the wallet.
  Future<void> _onMintAxUsdRequested(
    MintAxUsdRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (!state.hasSynthetixAccount) return;
    if (state.synthetixCollateralAssigned == BigInt.zero) {
      debugPrint('MintAxUsd: no delegated collateral');
      return;
    }

    try {
      emit(
        state.copyWith(
          isSynthetixAccountLoading: true,
          synthetixTxStatus: SynthetixTxStatus.minting,
        ),
      );

      // Derive safe-maximum mintable from on-chain data:
      //   maxMint = (collateralValueUSD / targetCRatio) − existingDebt
      //
      // collateralValueUSD is approximated from the on-chain c-ratio and
      // existing debt:  collateralValueUSD = existingDebt × cRatio
      // When debt == 0 we fall back to a conservative fraction of the
      // assigned collateral (treating 1 token unit ≈ 1 USD for AX peg).
      final existingDebt = await _accountRepository.getSynthetixPositionDebt(
        accountId: state.synthetixAccountId,
        poolId: AthleteXSynthetixConfig.defaultPoolId,
        collateralAddress: event.collateralAddress,
      );

      final BigInt maxMintable;
      if (existingDebt > BigInt.zero && state.synthetixCollateralRatio > BigInt.zero) {
        // collateralValueUSD = debt × cRatio (both in 18-dec)
        final cRatioX18 = state.synthetixCollateralRatio;
        final collateralValueX18 =
            (existingDebt * cRatioX18) ~/ BigInt.from(10).pow(18);
        final targetCRatioX18 = BigInt.from(
          (AthleteXSynthetixConfig.targetCollateralizationRatio * 1e18).toInt(),
        );
        final maxDebtAtTarget =
            collateralValueX18 * BigInt.from(10).pow(18) ~/ targetCRatioX18;
        maxMintable = maxDebtAtTarget > existingDebt
            ? maxDebtAtTarget - existingDebt
            : BigInt.zero;
      } else {
        // No existing debt: use assigned collateral ÷ targetCRatio as estimate
        final targetCRatioX18 = BigInt.from(
          (AthleteXSynthetixConfig.targetCollateralizationRatio * 1e18).toInt(),
        );
        maxMintable = state.synthetixCollateralAssigned *
            BigInt.from(10).pow(18) ~/
            targetCRatioX18;
      }

      final mintAmount = BigInt.from(
        (maxMintable.toDouble() * event.sliderValue).toInt(),
      );

      if (mintAmount == BigInt.zero) {
        emit(
          state.copyWith(
            isSynthetixAccountLoading: false,
            synthetixTxStatus: SynthetixTxStatus.idle,
          ),
        );
        return;
      }

      debugPrint(
        'MintAxUsd: minting ${mintAmount} axUSD (slider=${event.sliderValue})',
      );

      final mintTx = await _accountRepository.mintAxUsd(
        accountId: state.synthetixAccountId,
        poolId: AthleteXSynthetixConfig.defaultPoolId,
        collateralAddress: event.collateralAddress,
        amount: mintAmount,
      );
      await _accountRepository.waitForReceipt(mintTx);

      // axUSD lands in CoreProxy account — withdraw it to wallet
      final withdrawTx = await _accountRepository.withdrawAxUsd(
        accountId: state.synthetixAccountId,
        amount: mintAmount,
        usdProxyAddress: SynthetixConfig.usdProxy,
      );
      await _accountRepository.waitForReceipt(withdrawTx);

      emit(state.copyWith(synthetixTxStatus: SynthetixTxStatus.done));
      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error minting axUSD: $e');
      emit(
        state.copyWith(
          isSynthetixAccountLoading: false,
          synthetixTxStatus: SynthetixTxStatus.error,
          synthetixTxError: e.toString(),
        ),
      );
    }
  }

  /// Wrap real collateral (USDC / USDT / WETH) into its synth (Trader path).
  Future<void> _onWrapCollateralRequested(
    WrapCollateralRequested event,
    Emitter<AccountState> emit,
  ) async {
    try {
      // Step 1 — approve SpotMarketProxy to spend the collateral token
      emit(
        state.copyWith(
          isSynthetixAccountLoading: true,
          synthetixTxStatus: SynthetixTxStatus.approving,
        ),
      );

      await _accountRepository.approveErc20(
        tokenAddress: event.collateralAddress,
        spenderAddress: SynthetixConfig.spotMarketProxy,
        amount: event.amount,
      );

      // Step 2 — wrap
      emit(
        state.copyWith(synthetixTxStatus: SynthetixTxStatus.depositing),
      );

      // Compute minAmountReceived from slippageBps:
      // minAmountReceived = amount × (10000 − slippageBps) / 10000
      final bps = event.slippageBps.clamp(0, 9999);
      final minAmountReceived =
          event.amount * BigInt.from(10000 - bps) ~/ BigInt.from(10000);

      await _accountRepository.wrapCollateral(
        marketId: event.marketId,
        collateralAddress: event.collateralAddress,
        wrapAmount: event.amount,
        minAmountReceived: minAmountReceived,
      );

      emit(state.copyWith(synthetixTxStatus: SynthetixTxStatus.done));
      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error wrapping collateral: $e');
      emit(
        state.copyWith(
          isSynthetixAccountLoading: false,
          synthetixTxStatus: SynthetixTxStatus.error,
          synthetixTxError: e.toString(),
        ),
      );
    }
  }
}
