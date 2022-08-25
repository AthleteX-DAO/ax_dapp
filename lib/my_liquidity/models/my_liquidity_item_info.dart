import 'package:equatable/equatable.dart';

class LiquidityPositionInfo extends Equatable {
  const LiquidityPositionInfo({
    required this.token0Name,
    required this.token1Name,
    required this.token0Symbol,
    required this.token1Symbol,
    required this.token0Address,
    required this.token1Address,
    required this.lpTokenPairAddress,
    required this.lpTokenPairBalance,
    required this.token0LpAmount,
    required this.token1LpAmount,
    required this.shareOfPool,
    required this.apy,
  });

  factory LiquidityPositionInfo.empty() {
    return const LiquidityPositionInfo(
      token0Name: 'token0Name',
      token1Name: 'token1Name',
      token0Symbol: 'token0Symbol',
      token1Symbol: 'token1Symbol',
      token0Address: 'token0Address',
      token1Address: 'token1Address',
      lpTokenPairAddress: 'lpTokenPairAddress',
      lpTokenPairBalance: '0.0',
      token0LpAmount: '0.0',
      token1LpAmount: '0.0',
      shareOfPool: '0.0',
      apy: '0.0',
    );
  }

  final String token0Name;
  final String token1Name;
  final String token0Symbol;
  final String token1Symbol;
  final String token0Address;
  final String token1Address;
  final String lpTokenPairAddress;
  final String lpTokenPairBalance;
  final String token0LpAmount;
  final String token1LpAmount;
  final String shareOfPool;
  final String apy;

  @override
  List<Object> get props {
    return [
      token0Name,
      token1Name,
      token0Symbol,
      token1Symbol,
      token0Address,
      token1Address,
      lpTokenPairAddress,
      lpTokenPairBalance,
      token0LpAmount,
      token1LpAmount,
      shareOfPool,
      apy,
    ];
  }

  @override
  String toString() {
    return '''MyLiquidityItemInfo(token0Name: "$token0Name", token1Name: "$token1Name", token0Symbol: "$token0Symbol", token1Symbol: "$token1Symbol", token0Address: "$token0Address", token1Address: "$token1Address", lpTokenPairAddress: "$lpTokenPairAddress", lpTokenPairBalance: "$lpTokenPairBalance", token0LpAmount: "$token0LpAmount", token1LpAmount: "$token1LpAmount", shareOfPool: "$shareOfPool", apy: "$apy")''';
  }
}
