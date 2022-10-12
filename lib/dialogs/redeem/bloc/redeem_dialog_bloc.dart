import 'dart:async';
import 'dart:math';

import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'redeem_dialog_event.dart';
part 'redeem_dialog_state.dart';

class RedeemDialogBloc extends Bloc<RedeemDialogEvent, RedeemDialogState> {
  RedeemDialogBloc({
    required TokensRepository tokensRepository,
    required this.getTotalTokenBalanceUseCase,
    required this.lspController,
    required int athleteId,
    required this.supportedSport,
  })  : _tokensRepository = tokensRepository,
        super(
          RedeemDialogState(
            aptPair: tokensRepository.currentAptPair(athleteId),
          ),
        ) {
    on<WatchAptPairStarted>(_onWatchAptPairStarted);
    on<OnShortRedeemInput>(_onShortRedeemInput);
    on<OnLongRedeemInput>(_onLongRedeemInput);
    on<OnMaxRedeemTap>(_onMaxRedeemTap);
    on<FetchRedeemInfo>(_fetchRedeemInfo);

    add(WatchAptPairStarted(athleteId));
  }

  final TokensRepository _tokensRepository;
  final GetTotalTokenBalanceUseCase getTotalTokenBalanceUseCase;
  final LSPController lspController;
  final SupportedSport supportedSport;

  Future<void> _onWatchAptPairStarted(
    WatchAptPairStarted event,
    Emitter<RedeemDialogState> emit,
  ) async {
    await emit.onEach<AptPair>(
      _tokensRepository.aptPairChanges(event.athleteId),
      onData: (aptPair) {
        emit(
          state.copyWith(longApt: aptPair.longApt, shortApt: aptPair.shortApt),
        );
        add(FetchRedeemInfo(event.athleteId));
      },
    );
  }

  Future<void> _fetchRedeemInfo(
    FetchRedeemInfo event,
    Emitter<RedeemDialogState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final aptPair = _tokensRepository.currentAptPair(event.athleteId);
      lspController.updateAptAddress(aptPair.address);
      final longBalance = await getTotalTokenBalanceUseCase
          .getTotalBalanceForToken(aptPair.longApt.address);
      final shortBalance = await getTotalTokenBalanceUseCase
          .getTotalBalanceForToken(aptPair.shortApt.address);
      final collateralPerPair = getCollateralPerPair(supportedSport);
      final smallestBalance = min(longBalance, shortBalance);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          longBalance: longBalance,
          shortBalance: shortBalance,
          collateralPerPair: collateralPerPair,
          smallestBalance: smallestBalance,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onShortRedeemInput(
    OnShortRedeemInput event,
    Emitter<RedeemDialogState> emit,
  ) async {
    final shortInput = event.redeemShortInputAmount;
    final collateralPerPair = getCollateralPerPair(supportedSport);
    try {
      if (lspController.createAmt.value != shortInput) {
        lspController.updateRedeemAmt(shortInput);
      }
      emit(
        state.copyWith(
          status: BlocStatus.success,
          shortRedeemInput: shortInput,
          receiveAmount: shortInput * collateralPerPair,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onLongRedeemInput(
    OnLongRedeemInput event,
    Emitter<RedeemDialogState> emit,
  ) async {
    final longInput = event.redeemLongInputAmount;
    final collateralPerPair = getCollateralPerPair(supportedSport);
    try {
      if (lspController.createAmt.value != longInput) {
        lspController.updateRedeemAmt(longInput);
      }
      emit(
        state.copyWith(
          status: BlocStatus.success,
          longRedeemInput: longInput,
          receiveAmount: longInput * collateralPerPair,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onMaxRedeemTap(
    OnMaxRedeemTap event,
    Emitter<RedeemDialogState> emit,
  ) async {
    final aptPair = _tokensRepository.currentAptPair(event.athleteId);
    lspController.updateAptAddress(aptPair.address);
    final longBalance = await getTotalTokenBalanceUseCase
        .getTotalBalanceForToken(aptPair.longApt.address);
    final shortBalance = await getTotalTokenBalanceUseCase
        .getTotalBalanceForToken(aptPair.shortApt.address);
    final maxRedeemInput = min(longBalance, shortBalance);
    lspController.updateRedeemAmt(maxRedeemInput);
    final collateralPerPair = getCollateralPerPair(supportedSport);
    try {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          shortRedeemInput: maxRedeemInput,
          longRedeemInput: maxRedeemInput,
          receiveAmount: maxRedeemInput * collateralPerPair,
          smallestBalance: maxRedeemInput,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  int getCollateralPerPair(SupportedSport supportedSport) {
    var collateralPerPair = state.collateralPerPair;
    switch (supportedSport) {
      case SupportedSport.all:
      case SupportedSport.MLB:
        collateralPerPair = 15000;
        break;
      case SupportedSport.NFL:
        collateralPerPair = 1000;
        break;
      case SupportedSport.NBA:
    }

    return collateralPerPair;
  }
}
