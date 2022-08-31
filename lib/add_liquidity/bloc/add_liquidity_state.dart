part of 'add_liquidity_bloc.dart';

class AddLiquidityState extends Equatable {
  const AddLiquidityState({
    this.shareOfPool = '0.0',
    this.apy = '0.0',
    this.balance0 = 0.0,
    this.balance1 = 0.0,
    this.amount0 = 0,
    this.amount1 = 0,
    required this.token0,
    required this.token1,
    this.status = BlocStatus.initial,
    this.poolPairInfo = PoolPairInfo.empty,
    this.failure = Failure.none,
  });

  final String shareOfPool;
  final String apy;
  final double balance0;
  final double balance1;
  final double amount0;
  final double amount1;
  final Token token0;
  final Token token1;
  final BlocStatus status;
  final PoolPairInfo poolPairInfo;
  final Failure failure;

  @override
  List<Object?> get props => [
        shareOfPool,
        apy,
        balance0,
        balance1,
        amount0,
        amount1,
        token0,
        token1,
        status,
        poolPairInfo,
        failure,
      ];

  AddLiquidityState copyWith({
    String? shareOfPool,
    String? apy,
    double? balance0,
    double? balance1,
    double? token0AmountInput,
    double? token1AmountInput,
    Token? token0,
    Token? token1,
    BlocStatus? status,
    PoolPairInfo? poolPairInfo,
    Failure? failure,
  }) {
    return AddLiquidityState(
      shareOfPool: shareOfPool ?? this.shareOfPool,
      apy: apy ?? this.apy,
      balance0: balance0 ?? this.balance0,
      balance1: balance1 ?? this.balance1,
      amount0: token0AmountInput ?? amount0,
      amount1: token1AmountInput ?? amount1,
      token0: token0 ?? this.token0,
      token1: token1 ?? this.token1,
      status: status ?? this.status,
      poolPairInfo: poolPairInfo ?? this.poolPairInfo,
      failure: failure ?? this.failure,
    );
  }
}

/// {@template temp_failure}
/// Temporary failure, this should come from the bottom most layer.
/// {@endtemplate}
class NoPoolInfoFailure extends Failure {
  /// {@macro temp_failure}
  NoPoolInfoFailure() : super(Exception('No pool info'), StackTrace.empty);
}
