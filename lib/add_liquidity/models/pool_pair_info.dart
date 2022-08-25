class PoolPairInfo {
  const PoolPairInfo({
    required this.token0Price,
    required this.token1Price,
    required this.apy,
    required this.shareOfPool,
    required this.ratio,
    required this.recieveAmount,
    required this.reserve0,
    required this.reserve1,
  });

  static const empty = PoolPairInfo(
    token0Price: '0',
    token1Price: '0',
    apy: '0',
    shareOfPool: '0',
    ratio: 0,
    recieveAmount: '0',
    reserve0: '0',
    reserve1: '0',
  );

  final String token0Price;
  final String token1Price;
  final String apy;
  final String shareOfPool;
  final double ratio;
  final String recieveAmount;
  final String reserve0;
  final String reserve1;

  @override
  String toString() {
    return '''PoolPairInfo(token0Price: $token0Price, token1Price: $token1Price, apy: $apy, shareOfPool: $shareOfPool, ratio: $ratio, recieveAmount: $recieveAmount)''';
  }
}
