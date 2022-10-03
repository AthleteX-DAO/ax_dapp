import 'dart:async';

import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'mint_dialog_event.dart';
part 'mint_dialog_state.dart';

class MintDialogBloc extends Bloc<MintDialogEvent, MintDialogState> {
  MintDialogBloc({
    required TokensRepository tokensRepository,
    required this.getTotalTokenBalanceUseCase,
    required this.lspController,
    required int athleteId,
    required this.supportedSport,
  })  : _tokensRepository = tokensRepository,
        super(
          MintDialogState(
            aptPair: tokensRepository.currentAptPair(athleteId),
          ),
        ) {
    on<WatchAptPairStarted>(_onWatchAptPairStarted);
    on<OnNewMintInput>(_onNewMintInput);
    on<OnMaxMintTap>(_onMaxMintTap);
    on<FetchMintInfo>(_fetchMintInfo);

    add(WatchAptPairStarted(athleteId));
  }

  final TokensRepository _tokensRepository;
  final GetTotalTokenBalanceUseCase getTotalTokenBalanceUseCase;
  final LSPController lspController;
  final SupportedSport supportedSport;

  Future<void> _onWatchAptPairStarted(
    WatchAptPairStarted event,
    Emitter<MintDialogState> emit,
  ) async {
    await emit.onEach<AptPair>(
      _tokensRepository.aptPairChanges(event.athleteId),
      onData: (aptPair) {
        emit(
          state.copyWith(longApt: aptPair.longApt, shortApt: aptPair.shortApt),
        );
        add(FetchMintInfo(event.athleteId));
      },
    );
  }

  Future<void> _fetchMintInfo(
    FetchMintInfo event,
    Emitter<MintDialogState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final aptPair = _tokensRepository.currentAptPair(event.athleteId);
      lspController.updateAptAddress(aptPair.address);
      final balance = await getTotalTokenBalanceUseCase.getTotalAxBalance();
      final collateralPerPair = getCollateralPerPair(supportedSport);
      emit(state.copyWith(status: BlocStatus.success, balance: balance, collateralPerPair: collateralPerPair));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onNewMintInput(
    OnNewMintInput event,
    Emitter<MintDialogState> emit,
  ) async {
    final input = event.mintInputAmount;
    final balance = await getTotalTokenBalanceUseCase.getTotalAxBalance();
    final collateralPerPair = getCollateralPerPair(supportedSport);
    try {
      if (lspController.createAmt.value != input) {
        lspController.updateCreateAmt(input);
      }
      if (input > (balance / collateralPerPair)) {
        emit(
          state.copyWith(
            status: BlocStatus.error,
            failure: InsufficientFailure(),
            errorMessage: 'Insufficient Balance',
            mintInputAmount: input,
            longReceiveAmount: input,
            shortReceiveAmount: input,
            spendAmount: input * collateralPerPair,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            mintInputAmount: input,
            longReceiveAmount: input,
            shortReceiveAmount: input,
            spendAmount: input * collateralPerPair,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onMaxMintTap(
    OnMaxMintTap event,
    Emitter<MintDialogState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final balance = await getTotalTokenBalanceUseCase.getTotalAxBalance();
      final collateralPerPair = getCollateralPerPair(supportedSport);
      final maxMintInputAmount = balance / collateralPerPair;
      emit(
        state.copyWith(
          status: BlocStatus.success,
          mintInputAmount: maxMintInputAmount,
        ),
      );
      add(OnNewMintInput(mintInputAmount: maxMintInputAmount));
    } catch (_) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          errorMessage: 'Insufficient balance',
        ),
      );
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
