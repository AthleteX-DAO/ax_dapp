// ignore_for_file: unused_field

import 'dart:async';

import 'package:ax_dapp/account/models/models.dart';
import 'package:ax_dapp/account/repository/account_repository.dart';
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
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _streamAppDataChangesUseCase = streamAppDataChanges,
        _accountRepository = accountRepository,
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
    add(const WatchAppDataChangesStarted());
  }

  final TokensRepository _tokensRepository;
  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;
  final AccountRepository _accountRepository;

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
}
