// ignore_for_file: unused_field

import 'dart:async';

import 'package:ax_dapp/account/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required TokensRepository tokensRepository,
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        super(
          AccountState(
            chain: walletRepository.currentChain,
            walletAddress: walletRepository.currentWallet.address,
            selectedToken: tokensRepository.currentTokens.usdc,
            tokenAddress: tokensRepository.currentTokens.usdc.address,
          ),
        ) {
    on<AccountDetailsViewRequested>(_onAccountDetailsViewRequested);
    on<AccountWithdrawViewRequested>(_onAccountWithdrawViewRequested);
    on<AccountDepositViewRequested>(_onAccountDepositViewRequested);
    on<AccountBuyAndSellViewRequested>(_onAccountBuyAndSellViewRequested);
    on<SelectedAccountAssetsChanged>(_onSelectedAccountAssetsChanged);
    on<SwitchTokenRequested>(_onSwitchTokenRequested);
    on<UpdateBalanceRequested>(_onUpdateBalanceRequested);
  }

  // TODO(kevin): use the repositories when needed
  final TokensRepository _tokensRepository;
  final WalletRepository _walletRepository;

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

  Future<void> _onSwitchTokenRequested(
    SwitchTokenRequested event,
    Emitter<AccountState> emit,
  ) async {
    final selectedTokenAddress = event.tokenAddress;
    final balance =
        await _walletRepository.getTokenBalance(selectedTokenAddress);
    emit(
      state.copyWith(
        tokenAddress: selectedTokenAddress,
        tokenBalance: balance,
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
}
