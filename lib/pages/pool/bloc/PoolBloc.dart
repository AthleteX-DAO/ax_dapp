import 'package:ax_dapp/pages/pool/models/PoolEvent.dart';
import 'package:ax_dapp/pages/pool/models/PoolState.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPoolInfoUseCase.dart';
import 'package:ax_dapp/service/Controller/Pool/PoolController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PoolBloc extends Bloc<PoolEvent, PoolState> {
  final GetPoolInfoUseCase repo;
  final WalletController walletController;
  final PoolController poolController;

  PoolBloc(
      {required this.repo,
      required this.walletController,
      required this.poolController})
      : super(PoolState()) {
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

  get initialState => PoolState();

  Future<void> _mapRefreshEventToState(
      PageRefreshEvent event, Emitter<PoolState> emit) async {
    emit(state.copy(status: BlocStatus.loading));
    try {
      final balance0 =
          await walletController.getTokenBalance(state.token0!.address.value);
      final balance1 =
          await walletController.getTokenBalance(state.token1!.address.value);
      emit(state.copy(
          balance0: double.parse(balance0), balance1: double.parse(balance1)));
      final response = await repo.fetchPairInfo(
          tokenA: state.token0!.address.value,
          tokenB: state.token1!.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copy(
          status: BlocStatus.success,
          token0Price: poolInfo.token0Price,
          token1Price: poolInfo.token1Price,
        ));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken0SelectionChangedEventToState(
      Token0SelectionChanged event, Emitter<PoolState> emit) async {
    emit(state.copy(status: BlocStatus.loading));
    final token0 = event.token0;
    emit(state.copy(token0: token0));
    final double balance0 = double.parse(
        await walletController.getTokenBalance(token0.address.value));
    poolController.updateTknAddress1(token0.address.value);
    emit(state.copy(token0: token0, balance0: balance0));
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0!.address.value,
          tokenB: state.token1!.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copy(
          status: BlocStatus.success,
          token0Price: poolInfo.token0Price,
          token1Price: poolInfo.token1Price,
        ));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken1SelectionChangedEventToState(
      Token1SelectionChanged event, Emitter<PoolState> emit) async {
    emit(state.copy(status: BlocStatus.loading));
    final token1 = event.token1;
    emit(state.copy(token1: token1));
    final double balance1 = double.parse(
        await walletController.getTokenBalance(token1.address.value));
    poolController.updateTknAddress2(token1.address.value);
    emit(state.copy(token1: token1, balance1: balance1));
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0!.address.value,
          tokenB: state.token1!.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copy(
          status: BlocStatus.success,
          token0Price: poolInfo.token0Price,
          token1Price: poolInfo.token1Price,
        ));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  void _mapMaxToken0InputButtonClickedEventToState(
      MaxToken0InputButtonClicked event, Emitter<PoolState> emit) {}

  void _mapMaxToken1InputButtonClickedEventToState(
      MaxToken1InputButtonClicked event, Emitter<PoolState> emit) {}

  Future<void> _mapToken0InputChangedEventToState(
      Token0InputChanged event, Emitter<PoolState> emit) async {
    final token0InputAmount = event.token0Input;

    print("On New token0 Input: $token0InputAmount");
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0!.address.value,
          tokenB: state.token1!.address.value);
      final isSuccess = response.isLeft();
      if (isSuccess) {
        print("On New token0 Input: Success");
        if (poolController.amount1.value != token0InputAmount) {
          poolController.updateTopAmount(token0InputAmount);
        }
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copy(
          status: BlocStatus.success,
          token0Price: poolInfo.token0Price,
            token1Price: poolInfo.token1Price,
        ));
      } else {
        print("On New token0 Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken1InputChangedEventToState(
      Token1InputChanged event, Emitter<PoolState> emit) async {
    final token1InputAmount = event.token1Input;

    print("On New token1 Input: $token1InputAmount");
    try {
      final response = await repo.fetchPairInfo(
          tokenA: state.token0!.address.value,
          tokenB: state.token1!.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        print("On New token1 Input: Success");
        if (poolController.amount2.value != token1InputAmount) {
          poolController.updateBottomAmount(token1InputAmount);
        }
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(state.copy(
          status: BlocStatus.success,
          token0Price: poolInfo.token0Price,
          token1Price: poolInfo.token1Price,
        ));
      } else {
        print("On New token0 Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  void _mapAddLiquidityButtonClickedEventToState(
      AddLiquidityButtonClicked event, Emitter<PoolState> emit) {}

  void _mapSwapTokensEventToState(SwapTokens event, Emitter<PoolState> emit) {
    final Token? token0 = state.token1;
    final Token? token1 = state.token0;
    final token0AmountInput = state.token1AmountInput;
    final token1AmountInput = state.token0AmountInput;
    emit(state.copy(
        token0: token0,
        token1: token1,
        token0AmountInput: token0AmountInput,
        token1AmountInput: token1AmountInput));
  }
}
