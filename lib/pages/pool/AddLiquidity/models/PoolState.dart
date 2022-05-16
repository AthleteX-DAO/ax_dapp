part of 'package:ax_dapp/pages/pool/AddLiquidity/bloc/PoolBloc.dart';

class PoolState extends Equatable {
  final double shareOfPoolPercentage;
  final double expectedYield;
  final double balance0;
  final double balance1;
  final Token? token0;
  final Token? token1;
  final double token0AmountInput;
  final double token1AmountInput;
  final BlocStatus status;
  final double token0Price;
  final double token1Price;

  PoolState(
      {this.status = BlocStatus.initial,
      Token? token0,
      Token? token1,
      double? balance0,
      double? balance1,
      double? shareOfPoolPercentage,
      double? expectedYield,
      double? token0AmountInput,
      double? token1AmountInput,
      double? token0Price,
      double? token1Price})
      : token0 = token0 ?? TokenList.tokenList[0],
        token1 = token1 ?? TokenList.tokenList[1],
        balance0 = balance0 ?? 0.0,
        balance1 = balance1 ?? 0.0,
        shareOfPoolPercentage = shareOfPoolPercentage ?? 0.0,
        expectedYield = expectedYield ?? 0.0,
        token0AmountInput = token0AmountInput ?? 0.0,
        token1AmountInput = token1AmountInput ?? 0.0,
        token0Price = token0Price ?? 0.0,
        token1Price = token1Price ?? 0.0;

  @override
  List<Object?> get props => [
        token0,
        token1,
        shareOfPoolPercentage,
        expectedYield,
        status,
        token0Price,
        token1Price
      ];

  PoolState copy(
      {BlocStatus? status,
      Token? token0,
      Token? token1,
      PoolPairInfo? pairInfo,
      double? shareOfPoolPercentage,
      double? expectedYield,
      double? balance0,
      double? balance1,
      double? token0AmountInput,
      double? token1AmountInput,
      double? token0Price,
      double? token1Price}) {
    return PoolState(
        status: status ?? BlocStatus.initial,
        token0: token0 ?? this.token0,
        token1: token1 ?? this.token1,
        shareOfPoolPercentage:
            shareOfPoolPercentage ?? this.shareOfPoolPercentage,
        expectedYield: expectedYield ?? this.expectedYield,
        balance0: balance0 ?? this.balance0,
        balance1: balance1 ?? this.balance1,
        token0AmountInput: token0AmountInput ?? this.token0AmountInput,
        token1AmountInput: token1AmountInput ?? this.token1AmountInput,
        token0Price: token0Price ?? this.token0Price,
        token1Price: token1Price ?? this.token1Price);
  }
}
