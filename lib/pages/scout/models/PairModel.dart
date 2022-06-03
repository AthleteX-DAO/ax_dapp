class PairModel {
  final String strId;
  final String strName;
  final double dToken0Price;
  final double dToken1Price;
  final String strToken0Name;
  final String strToken1Name;
  final String strToken0Address;
  final String strToken1Address;
  final double dReserve0;
  final double dReserve1;
  final double dTotalSupply;

  PairModel(
    this.strId,
    this.strName,
    this.dToken0Price,
    this.dToken1Price,
    this.strToken0Name,
    this.strToken1Name,
    this.strToken0Address,
    this.strToken1Address,
    this.dReserve0,
    this.dReserve1,
    this.dTotalSupply
  );

  @override
  String toString() {
    return 'PairInfo(id: "${this.strId}", name: "${this.strName}", token0Price: "${this.dToken0Price}", token1Price: "${this.dToken1Price}", token0Name: "${this.strToken0Name}", token1Name: "${this.strToken1Name}", token0Address: "${this.strToken0Address}", token1Address: "${this.strToken1Address}", reserve0: "${this.dReserve0}", reserve1: "${this.dReserve1}", totaSupply: "${this.dTotalSupply}")';
  }
}
