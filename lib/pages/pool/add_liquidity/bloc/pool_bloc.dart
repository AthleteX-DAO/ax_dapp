import 'package:ax_dapp/pages/pool/add_liquidity/models/pool_pair_info.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'pool_event.dart';
part 'pool_state.dart';

class PoolBloc extends Bloc<PoolEvent, PoolState> {
  PoolBloc({
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
    required this.repo,
    required this.poolController,
  })  : _walletRepository = walletRepository,
        super(
          PoolState(
            token0: tokensRepository.tokens.first,
            token1: tokensRepository.tokens[1],
          ),
        ) {
    on<PageRefreshEvent>(_mapRefreshEventToState);
    on<Token0SelectionChanged>(_mapToken0SelectionChangedEventToState);
    on<Token1SelectionChanged>(_mapToken1SelectionChangedEventToState);
    on<MaxToken0InputButtonClicked>(
      _mapMaxToken0InputButtonClickedEventToState,
    );
    on<MaxToken1InputButtonClicked>(
      _mapMaxToken1InputButtonClickedEventToState,
    );
    on<Token0InputChanged>(_mapToken0InputChangedEventToState);
    on<Token1InputChanged>(_mapToken1InputChangedEventToState);
    on<AddLiquidityButtonClicked>(_mapAddLiquidityButtonClickedEventToState);
    on<SwapTokens>(_mapSwapTokensEventToState);
  }

  final WalletRepository _walletRepository;
  final GetPoolInfoUseCase repo;
  final PoolController poolController;

  Future<void> _mapRefreshEventToState(
    PageRefreshEvent event,
    Emitter<PoolState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    poolController
      ..updateTknAddress1(state.token0.address)
      ..updateTknAddress2(state.token1.address);
    try {
      final balance0 =
          await _walletRepository.getTokenBalance(state.token0.address);
      final balance1 =
          await _walletRepository.getTokenBalance(state.token1.address);
      emit(
        state.copyWith(
          balance0: balance0 ?? 0,
          balance1: balance1 ?? 0,
        ),
      );
      final response = await repo.fetchPairInfo(
        tokenA: state.token0.address,
        tokenB: state.token1.address,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(
          state.copyWith(
            status: BlocStatus.success,
            poolPairInfo: poolInfo,
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(
          state.copyWith(
            status: BlocStatus.noData,
            poolPairInfo: PoolPairInfo.empty,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken0SelectionChangedEventToState(
    Token0SelectionChanged event,
    Emitter<PoolState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final token0 = event.token0;
    emit(state.copyWith(token0: token0));
    final balance0 = await _walletRepository.getTokenBalance(token0.address);
    poolController.updateTknAddress1(token0.address);
    emit(state.copyWith(token0: token0, balance0: balance0 ?? 0));
    try {
      final response = await repo.fetchPairInfo(
        tokenA: state.token0.address,
        tokenB: state.token1.address,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(
          state.copyWith(
            status: BlocStatus.success,
            poolPairInfo: poolInfo,
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

  Future<void> _mapToken1SelectionChangedEventToState(
    Token1SelectionChanged event,
    Emitter<PoolState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final token1 = event.token1;
    emit(state.copyWith(token1: token1));
    final balance1 = await _walletRepository.getTokenBalance(token1.address);
    poolController.updateTknAddress2(token1.address);
    emit(state.copyWith(token1: token1, balance1: balance1 ?? 0));
    try {
      final response = await repo.fetchPairInfo(
        tokenA: state.token0.address,
        tokenB: state.token1.address,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(
          state.copyWith(
            status: BlocStatus.success,
            poolPairInfo: poolInfo,
          ),
        );
      } else {
        // TODO(aynone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(state.copyWith(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapMaxToken0InputButtonClickedEventToState(
    MaxToken0InputButtonClicked event,
    Emitter<PoolState> emit,
  ) {}

  void _mapMaxToken1InputButtonClickedEventToState(
    MaxToken1InputButtonClicked event,
    Emitter<PoolState> emit,
  ) {}

  Future<void> _mapToken0InputChangedEventToState(
    Token0InputChanged event,
    Emitter<PoolState> emit,
  ) async {
    final token0InputAmount = double.parse(event.token0Input);
    if (poolController.amount1.value != token0InputAmount) {
      poolController.updateTopAmount(token0InputAmount);
    }
    try {
      final response = await repo.fetchPairInfo(
        tokenA: state.token0.address,
        tokenB: state.token1.address,
        tokenAInput: token0InputAmount,
        tokenBInput: state.token1AmountInput,
      );
      final isSuccess = response.isLeft();
      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        final token1InputAmount = token0InputAmount / poolInfo.ratio;
        emit(
          state.copyWith(
            status: BlocStatus.success,
            token0AmountInput: token0InputAmount,
            poolPairInfo: poolInfo,
          ),
        );
        add(Token1InputChanged(token1InputAmount.toString()));
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(state.copyWith(status: BlocStatus.noData));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapToken1InputChangedEventToState(
    Token1InputChanged event,
    Emitter<PoolState> emit,
  ) async {
    final token1InputAmount = double.parse(event.token1Input);
    if (poolController.amount2.value != token1InputAmount) {
      poolController.updateBottomAmount(token1InputAmount);
    }
    try {
      final response = await repo.fetchPairInfo(
        tokenA: state.token0.address,
        tokenB: state.token1.address,
        tokenAInput: state.token0AmountInput,
        tokenBInput: token1InputAmount,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final poolInfo = response.getLeft().toNullable()!.pairInfo;
        emit(
          state.copyWith(
            status: BlocStatus.success,
            poolPairInfo: poolInfo,
            token1AmountInput: token1InputAmount,
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(state.copyWith(status: BlocStatus.noData));
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapAddLiquidityButtonClickedEventToState(
    AddLiquidityButtonClicked event,
    Emitter<PoolState> emit,
  ) {}

  void _mapSwapTokensEventToState(SwapTokens event, Emitter<PoolState> emit) {
    final token0 = state.token1;
    final token1 = state.token0;
    final token0AmountInput = state.token1AmountInput;
    final token1AmountInput = state.token0AmountInput;
    emit(
      state.copyWith(
        token0: token0,
        token1: token1,
        token0AmountInput: token0AmountInput,
        token1AmountInput: token1AmountInput,
      ),
    );
  }
}
