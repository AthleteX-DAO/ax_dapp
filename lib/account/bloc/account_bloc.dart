// ignore_for_file: unused_field

import 'dart:async';

import 'package:ax_dapp/account/models/models.dart';
import 'package:ax_dapp/account/repository/account_repository.dart';
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
    on<SelectedAccountAssetsChanged>(_onSelectedAccountAssetsChanged);
    on<SelectTokenRequested>(_onSelectTokenRequested);
    on<UpdateBalanceRequested>(_onUpdateBalanceRequested);
    on<FetchTokenInfoRequested>(_onFetchTokenInfoRequested);
    on<UpdateWithdrawInput>(_onUpdateWithdrawInput);
    on<AccountWithdrawConfirm>(_onAccountWithdrawConfirm);
    on<UpdateRecipentAddressRequested>(_onUpdateRecipentAddressRequested);
    on<WithdrawChainSelected>(_onWithdrawChainSelected);
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
    on<CreateSynthetixAccountRequested>(_onCreateSynthetixAccountRequested);
    add(const WatchAppDataChangesStarted());
  }

  final TokensRepository _tokensRepository;
  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;
  final AccountRepository _accountRepository;
  final VaultRepository _vaultRepository;

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
        add(const FetchSynthetixAccountRequested()); // Fetch Synthetix account data
      },
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

  Future<void> _onAccountDetailsViewRequested(
    AccountDetailsViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.details),
    );
  }

  Future<void> _onAccountWithdrawViewRequested(
    AccountWithdrawViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.withdraw),
    );
  }

  Future<void> _onAccountDepositViewRequested(
    AccountDepositViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.deposit),
    );
  }

  Future<void> _onAccountBuyAndSellViewRequested(
    AccountBuyAndSellViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.buySell),
    );
  }

  Future<void> _onAccountTokenViewRequested(
    AccountTokenViewRequested event,
    Emitter<AccountState> emit,
  ) async {
    final token = event.token;
    emit(
      state.copyWith(
        accountViewStatus: AccountViewStatus.token,
        selectedToken: token,
      ),
    );
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
      emit(
        state.copyWith(
          selectedAssets: event.selectedAssets,
        ),
      );
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
    final input = event.tokenAmountInput;
    emit(state.copyWith(tokenAmountInput: input));
  }

  Future<void> _onUpdateRecipentAddressRequested(
    UpdateRecipentAddressRequested event,
    Emitter<AccountState> emit,
  ) async {
    final recipentAddress = event.recipentAddress;
    emit(state.copyWith(recipentAddress: recipentAddress));
  }

  Future<void> _onWithdrawChainSelected(
    WithdrawChainSelected event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(withdrawTargetChain: event.chain));
  }

  // ========== Synthetix V3 Account Event Handlers ==========

  /// Fetches Synthetix account data (ID, collateral, debt, c-ratio)
  Future<void> _onFetchSynthetixAccountRequested(
    FetchSynthetixAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (state.walletAddress.isEmpty || state.walletAddress == kEmptyAddress) {
      return;
    }

    emit(state.copyWith(isSynthetixAccountLoading: true));

    try {
      // Get account IDs for this wallet
      final accountIds = await _accountRepository.getSynthetixAccountIds(
        state.walletAddress,
      );

      if (accountIds.isEmpty) {
        emit(
          state.copyWith(
            hasSynthetixAccount: false,
            isSynthetixAccountLoading: false,
          ),
        );
        return;
      }

      // Use first account (primary account)
      final accountId = accountIds.first.toInt();

      // TODO(integration): Get collateral address from config - hardcoded for now
      const collateralAddress = '0x...'; // Replace with actual USDC address
      const poolId = 1; // Replace with actual pool ID

      // Fetch account data in parallel
      final collateralData = await _accountRepository
          .getSynthetixAccountCollateral(
        accountId: accountId,
        collateralAddress: collateralAddress,
      );

      final availableCollateral = await _accountRepository
          .getSynthetixAvailableCollateral(
        accountId: accountId,
        collateralAddress: collateralAddress,
      );

      final debt = await _accountRepository.getSynthetixPositionDebt(
        accountId: accountId,
        poolId: poolId,
        collateralAddress: collateralAddress,
      );

      final cRatio = await _accountRepository.getSynthetixCollateralRatio(
        accountId: accountId,
        poolId: poolId,
        collateralAddress: collateralAddress,
      );

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

  /// Deposits collateral to Synthetix account
  Future<void> _onDepositSynthetixCollateralRequested(
    DepositSynthetixCollateralRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (!state.hasSynthetixAccount) return;

    try {
      emit(state.copyWith(isSynthetixAccountLoading: true));

      await _accountRepository.depositSynthetixCollateral(
        accountId: state.synthetixAccountId,
        collateralAddress: event.collateralAddress,
        amount: event.amount,
      );

      // Refresh account data after deposit
      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error depositing collateral: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  /// Withdraws collateral from Synthetix account
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

      // Refresh account data after withdrawal
      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error withdrawing collateral: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  /// Delegates collateral to a pool for earning yield
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

      // Refresh account data after delegation
      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error delegating collateral: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  /// Creates a new Synthetix account and shows loading during tx
  Future<void> _onCreateSynthetixAccountRequested(
    CreateSynthetixAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (state.walletAddress.isEmpty || state.walletAddress == kEmptyAddress) {
      return;
    }

    emit(state.copyWith(isSynthetixAccountLoading: true));

    try {
      final accountId = _deriveAccountId(state.walletAddress);
      await _accountRepository.createSynthetixAccount(accountId: accountId);

      // After creation, fetch the account to display details
      add(const FetchSynthetixAccountRequested());
    } catch (e) {
      debugPrint('Error creating Synthetix account: $e');
      emit(state.copyWith(isSynthetixAccountLoading: false));
    }
  }

  int _deriveAccountId(String walletAddress) {
    final normalized = walletAddress.toLowerCase().replaceFirst('0x', '');
    final trimmed = normalized.padLeft(8, '0').substring(0, normalized.length < 20 ? normalized.length : 20);
    final hash = BigInt.parse(trimmed, radix: 16);
    final mod = BigInt.from(1000000000000); // 1e12
    return (hash % mod).toInt();
  }
}
