import 'package:ax_dapp/pages/pool/AddLiquidity/models/PoolPairInfo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPoolInfoUseCase.dart';
import 'package:ax_dapp/service/Controller/Pool/PoolController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/service/TokenList.dart' show TokenList;
import 'package:equatable/equatable.dart';

part 'package:ax_dapp/pages/pool/AddLiquidity/models/PoolEvent.dart';
part 'package:ax_dapp/pages/pool/AddLiquidity/models/PoolState.dart';

class PoolBloc extends Bloc<PoolEvent, PoolState> {
  final GetPoolInfoUseCase repo;
  final WalletController walletController;
  final PoolController poolController;

  PoolBloc(
      {required this.repo,
      required this.walletController,
      required this.poolController})
      : super(PoolState.initial()) {
    on<PageRefreshEvent>(_mapRefreshEventToState);
    on<Token0SelectionChanged>(_mapToken0SelectionChangedEventToState);
    on<Token1SelectionChanged>(_mapToken1SelectionChangedEventToState);
    on<MaxToken0InputButtonClicked>(
        _mapMaxToken0InputButtonClickedEventToState);
    on<MaxToken1InputButtonClicked>(
        _mapMaxToken1InputButtonClickedEventToState);
    on<Token0InputChanged>(_mapToken0InputChangedEventToState);
    on<Token1InputChanged>(_mapToken1InputChangedEventToState);
    on<AddLiquidityButtonClicked>(_mapAddLiquidityButtonClickedEventToState);
    on<SwapTokens>(_mapSwapTokensEventToState);
  }

  Future<void> _mapRefreshEventToState(
      PageRefreshEvent event, Emitter<PoolState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    poolController.updateTknAddress1(state.token0.address.value);
    poolController.updateTknAddress2(state.token1.address.value);
    try {
      final balance0 =
          await walletController.getTokenBalance(state.token0.address.value);
      final balance1 =
          await walletController.getTokenBalance(state.token1.address.value);
      emit(state.copyWith(
          balance0: balance0, balance1: balance1));
      final response = await repo.fetchPairInfo(
          tokenA: state.token0.address.value,
          tokenB: state.token1.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copyWith(
          status: BlocStatus.success,
          poolPairInfo: poolInfo
        ));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.no_data, poolPairInfo: PoolPairInfo.empty()));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken0SelectionChangedEventToState(
      Token0SelectionChanged event, Emitter<PoolState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final token0 = event.token0;
    emit(state.copyWith(token0: token0));
    final balance0 = double.parse(await walletController.getTokenBalance(token0.address.value));
    poolController.updateTknAddress1(token0.address.value);
    emit(state.copyWith(token0: token0, balance0: balance0.toStringAsFixed(6)));
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0.address.value,
          tokenB: state.token1.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copyWith(
          status: BlocStatus.success,
          poolPairInfo: poolInfo
        ));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken1SelectionChangedEventToState(
      Token1SelectionChanged event, Emitter<PoolState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final token1 = event.token1;
    emit(state.copyWith(token1: token1));
    final balance1 = double.parse(await walletController.getTokenBalance(token1.address.value));
    poolController.updateTknAddress2(token1.address.value);
    emit(state.copyWith(token1: token1, balance1: balance1.toStringAsFixed(6)));
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0.address.value,
          tokenB: state.token1.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copyWith(
          status: BlocStatus.success,
          poolPairInfo: poolInfo
        ));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapMaxToken0InputButtonClickedEventToState(
      MaxToken0InputButtonClicked event, Emitter<PoolState> emit) {}

  void _mapMaxToken1InputButtonClickedEventToState(
      MaxToken1InputButtonClicked event, Emitter<PoolState> emit) {}

  Future<void> _mapToken0InputChangedEventToState(
      Token0InputChanged event, Emitter<PoolState> emit) async {
    final token0InputAmount = double.parse(event.token0Input);
    if (poolController.amount1.value != token0InputAmount) {
      poolController.updateTopAmount(token0InputAmount);
    }
    print("On New token0 Input: $token0InputAmount");
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0.address.value,
          tokenB: state.token1.address.value,
          tokenAInput: token0InputAmount,
          tokenBInput: state.token1AmountInput);
      final isSuccess = response.isLeft();
      if (isSuccess) {
        print("On New token0 Input: Success");
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        final token1InputAmount = token0InputAmount / poolInfo.ratio;
        emit(state.copyWith(
          status: BlocStatus.success,
          token0AmountInput: token0InputAmount,
          poolPairInfo: poolInfo
        ));
        add(Token1InputChanged(token1InputAmount.toString()));
      } else {
        print("On New token0 Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.no_data));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken1InputChangedEventToState(
      Token1InputChanged event, Emitter<PoolState> emit) async {
    final token1InputAmount = double.parse(event.token1Input);
    if (poolController.amount2.value != token1InputAmount) {
      poolController.updateBottomAmount(token1InputAmount);
    }
    print("On New token1 Input: $token1InputAmount");
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0.address.value,
          tokenB: state.token1.address.value,
          tokenAInput: state.token0AmountInput,
          tokenBInput: token1InputAmount);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        print("On New token1 Input: Success");
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copyWith(
          status: BlocStatus.success,
          poolPairInfo: poolInfo,
          token1AmountInput: token1InputAmount
        ));
      } else {
        print("On New token0 Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.no_data));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapAddLiquidityButtonClickedEventToState(
      AddLiquidityButtonClicked event, Emitter<PoolState> emit) {}

  void _mapSwapTokensEventToState(SwapTokens event, Emitter<PoolState> emit) {
    final Token? token0 = state.token1;
    final Token? token1 = state.token0;
    final token0AmountInput = state.token1AmountInput;
    final token1AmountInput = state.token0AmountInput;
    emit(state.copyWith(
        token0: token0,
        token1: token1,
        token0AmountInput: token0AmountInput,
        token1AmountInput: token1AmountInput));
  }
}
