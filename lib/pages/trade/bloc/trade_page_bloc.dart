import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/service/token_list.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trade_page_event.dart';
part 'trade_page_state.dart';

class TradePageBloc extends Bloc<TradePageEvent, TradePageState> {
  TradePageBloc({
    required this.repo,
    required this.controller,
    required this.swapController,
    required this.walletController,
    required this.isBuyAX,
  }) : super(TradePageState.initial(controller, isBuyAX)) {
    on<PageRefreshEvent>(_mapRefreshEventToState);
    on<MaxSwapTapEvent>(_mapMaxSwapTapEventToState);
    on<NewTokenFromInputEvent>(_mapNewTokenFromInputEventToState);
    on<NewTokenToInputEvent>(_mapNewTokenToInputEventToState);
    on<SetTokenFrom>(_mapSetTokenFromEventToState);
    on<SetTokenTo>(_mapSetTokenToEventToState);
    on<SwapTokens>(_mapSwapTokensEventToState);
  }

  final GetSwapInfoUseCase repo;
  final Controller controller;
  final SwapController swapController;
  final WalletController walletController;
  final bool isBuyAX;

  Future<void> _mapRefreshEventToState(
    PageRefreshEvent event,
    Emitter<TradePageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final tokenFromBalance =
          await walletController.getTokenBalance(state.tokenFrom.address.value);
      final tokenToBalance =
          await walletController.getTokenBalance(state.tokenTo.address.value);
      emit(
        state.copyWith(
          tokenFromBalance: double.parse(tokenFromBalance),
          tokenToBalance: double.parse(tokenToBalance),
        ),
      );
      final response = await repo.fetchSwapInfo(
        tokenFrom: state.tokenFrom.address.value,
        tokenTo: state.tokenTo.address.value,
      );
      final isSuccess = response.isLeft();
      if (isSuccess) {
        swapController
          ..updateFromAddress(state.tokenFrom.address.value)
          ..updateToAddress(state.tokenTo.address.value);
        final swapInfo = response.getLeft().toNullable()!.swapInfo;

        //do some math
        emit(
          state.copyWith(
            status: BlocStatus.success,
            swapInfo: swapInfo,
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(state.copyWith(status: BlocStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapNewTokenFromInputEventToState(
    NewTokenFromInputEvent event,
    Emitter<TradePageState> emit,
  ) async {
    final tokenInputFromAmount = event.tokenInputFromAmount;
    try {
      final response = await repo.fetchSwapInfo(
        tokenFrom: state.tokenFrom.address.value,
        tokenTo: state.tokenTo.address.value,
        fromInput: tokenInputFromAmount,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        if (swapController.amount1.value != tokenInputFromAmount) {
          swapController.updateFromAmount(tokenInputFromAmount);
        }
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        //do some math
        emit(state.copyWith(status: BlocStatus.success, swapInfo: swapInfo));
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(state.copyWith(status: BlocStatus.error));
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapNewTokenToInputEventToState(
    NewTokenToInputEvent event,
    Emitter<TradePageState> emit,
  ) async {}

  Future<void> _mapMaxSwapTapEventToState(
    MaxSwapTapEvent event,
    Emitter<TradePageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final tokenFromBalance =
          await walletController.getTokenBalance(state.tokenFrom.address.value);
      final maxInput = double.parse(tokenFromBalance);
      emit(
        state.copyWith(
          tokenInputFromAmount: maxInput,
          tokenFromBalance: maxInput,
        ),
      );
    } catch (_) {
      // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapSetTokenFromEventToState(
    SetTokenFrom event,
    Emitter<TradePageState> emit,
  ) {
    swapController.updateFromAddress(event.tokenFrom.address.value);
    emit(state.copyWith(tokenFrom: event.tokenFrom));
  }

  void _mapSetTokenToEventToState(
    SetTokenTo event,
    Emitter<TradePageState> emit,
  ) {
    swapController.updateToAddress(event.tokenTo.address.value);
    emit(state.copyWith(tokenTo: event.tokenTo));
  }

  void _mapSwapTokensEventToState(
    SwapTokens event,
    Emitter<TradePageState> emit,
  ) {
    final tokenFrom = state.tokenTo;
    final tokenTo = state.tokenFrom;
    final tokenInputFromAmount = state.tokenInputToAmount;
    final tokenInputToAmount = state.tokenInputFromAmount;
    emit(
      state.copyWith(
        tokenFrom: tokenFrom,
        tokenTo: tokenTo,
        tokenInputFromAmount: tokenInputFromAmount,
        tokenInputToAmount: tokenInputToAmount,
      ),
    );
  }
}
