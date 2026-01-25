class GetPoolInfoUseCase {
  Future<PoolPairInfo> call() async {
    return PoolPairInfo.empty;
  }
}

/// Placeholder model for pool pair info while liquidity module is unavailable.
class PoolPairInfo {
  const PoolPairInfo();

  static const empty = PoolPairInfo();
}
