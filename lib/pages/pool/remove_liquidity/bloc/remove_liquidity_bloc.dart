import 'dart:async';

import 'package:ax_dapp/pages/pool/my_liqudity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/pages/pool/remove_liquidity/bloc/remove_liquidity_event.dart';
import 'package:ax_dapp/pages/pool/remove_liquidity/bloc/remove_liquidity_state.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoveLiquidityBloc
    extends Bloc<RemoveLiquidityEvent, RemoveLiquidityState> {
  RemoveLiquidityBloc({
    required this.liquidityPositionInfo,
    required this.poolController,
  }) : super(RemoveLiquidityState.initial()) {
    on<PageRefreshEvent>(_mapPageRefreshEventToState);
    on<RemoveInput>(_mapRemoveInputEventToState);
  }

  final LiquidityPositionInfo liquidityPositionInfo;
  final PoolController poolController;

  FutureOr<void> _mapPageRefreshEventToState(
    PageRefreshEvent event,
    Emitter<RemoveLiquidityState> emit,
  ) {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      poolController
      ..lpTokenAAddress = liquidityPositionInfo.token0Address
      ..lpTokenBAddress = liquidityPositionInfo.token1Address
      ..lpTokenPairAddress = liquidityPositionInfo.lpTokenPairAddress;
      emit(
        state.copyWith(
          lpTokenPairBalance: liquidityPositionInfo.lpTokenPairBalance,
          shareOfPool: liquidityPositionInfo.shareOfPool,
          lpTokenOneAmount: liquidityPositionInfo.token0LpAmount,
          lpTokenTwoAmount: liquidityPositionInfo.token1LpAmount,
          tokenOneAddress: liquidityPositionInfo.token0Address,
          tokenTwoAddress: liquidityPositionInfo.token1Address,
          lpTokenPairAddress: liquidityPositionInfo.lpTokenPairAddress,
          percentRemoval: 0,
          tokenOneRemoveAmount: 0,
          tokenTwoRemoveAmount: 0,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  FutureOr<void> _mapRemoveInputEventToState(
    RemoveInput event,
    Emitter<RemoveLiquidityState> emit,
  ) {
    final input = event.removeInput;
    try {
      final tokenOneRemoveAmount =
          double.parse(state.lpTokenOneAmount) * (input / 100);
      final tokenTwoRemoveAmount =
          double.parse(state.lpTokenTwoAmount) * (input / 100);
      poolController.removePercentage = input;
      emit(
        state.copyWith(
          status: BlocStatus.success,
          tokenOneRemoveAmount: tokenOneRemoveAmount,
          tokenTwoRemoveAmount: tokenTwoRemoveAmount,
          percentRemoval: input,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}
