part of 'pool_bloc.dart';

class PoolState extends Equatable {
  const PoolState({
    required this.shareOfPool,
    required this.apy,
    required this.balance0,
    required this.balance1,
    required this.token0AmountInput,
    required this.token1AmountInput,
    required this.token0,
    required this.token1,
    required this.status,
    required this.poolPairInfo,
  });

  factory PoolState.initial() {
    return PoolState(
      shareOfPool: '0.0',
      apy: '0.0',
      balance0: '0.0',
      balance1: '0.0',
      token0AmountInput: 0,
      token1AmountInput: 0,
      token0: TokenList.tokenList[0],
      token1: TokenList.tokenList[1],
      status: BlocStatus.initial,
      poolPairInfo: PoolPairInfo.empty(),
    );
  }
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
