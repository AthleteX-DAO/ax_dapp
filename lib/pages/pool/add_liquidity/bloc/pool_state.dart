part of 'pool_bloc.dart';

class PoolState extends Equatable {
  const PoolState({
    this.shareOfPool = '0.0',
    this.apy = '0.0',
    this.balance0 = '0.0',
    this.balance1 = '0.0',
    this.token0AmountInput = 0,
    this.token1AmountInput = 0,
    required this.token0,
    required this.token1,
    this.status = BlocStatus.initial,
    this.poolPairInfo = PoolPairInfo.empty,
  });

  final String shareOfPool;
  final String apy;
  final String balance0;
  final String balance1;
  final double token0AmountInput;
  final double token1AmountInput;
  final Token token0;
  final Token token1;
  final BlocStatus status;
  final PoolPairInfo poolPairInfo;

  @override
  List<Object> get props => [
        shareOfPool,
        apy,
        balance0,
        balance1,
        token0AmountInput,
        token1AmountInput,
        token0,
        token1,
        status,
        poolPairInfo,
      ];

  @override
  String toString() {
    return '''PoolState(shareOfPool: $shareOfPool, apy: $apy, balance0: $balance0, balance1: $balance1, token0AmountInput: $token0AmountInput, token1AmountInput: $token1AmountInput, token0: $token0, token1: $token1, status: $status, poolPairInfo: $poolPairInfo)''';
  }

  PoolState copyWith({
    String? shareOfPool,
    String? apy,
    String? balance0,
    String? balance1,
    double? token0AmountInput,
    double? token1AmountInput,
    Token? token0,
    Token? token1,
    BlocStatus? status,
    PoolPairInfo? poolPairInfo,
  }) {
    return PoolState(
      shareOfPool: shareOfPool ?? this.shareOfPool,
      apy: apy ?? this.apy,
      balance0: balance0 ?? this.balance0,
      balance1: balance1 ?? this.balance1,
      token0AmountInput: token0AmountInput ?? this.token0AmountInput,
      token1AmountInput: token1AmountInput ?? this.token1AmountInput,
      token0: token0 ?? this.token0,
      token1: token1 ?? this.token1,
      status: status ?? this.status,
      poolPairInfo: poolPairInfo ?? this.poolPairInfo,
    );
  }
}
