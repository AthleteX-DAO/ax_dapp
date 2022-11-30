import 'dart:math';

import 'package:ax_dapp/add_liquidity/models/models.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pair_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/subgraph_error.dart';
import 'package:fpdart/fpdart.dart';

class GetPoolInfoUseCase {
  GetPoolInfoUseCase(GetPairInfoUseCase repo) : _repo = repo;

  final GetPairInfoUseCase _repo;

  Future<Either<Success, SubgraphError>> fetchPairInfo({
    double? tokenAInput,
    double? tokenBInput,
    double? lpTokenBalance,
    required String tokenA,
    required String tokenB,
  }) async {
    final tokenFromAddress = tokenA.toLowerCase();
    final tokenToAddress = tokenB.toLowerCase();
    final token0Input = tokenAInput ?? 0.0;
    final token1Input = tokenBInput ?? 0.0;
    try {
      final tokenPairData = await _repo.fetchPairInfo(
        tokenA: tokenFromAddress,
        tokenB: tokenToAddress,
      );

      if (tokenPairData.isLeft()) {
        final tokenPair = tokenPairData.getLeft().toNullable()!.pairInfo;

        final double token0Price;
        final double token1Price;
        final double reserve0;
        final double reserve1;
        final totalSupply = double.parse(tokenPair.totalSupply!);

        if (tokenPair.token0.id == tokenFromAddress) {
          token0Price = double.parse(tokenPair.token0Price);
          reserve0 = double.parse(tokenPair.reserve0);
          token1Price = double.parse(tokenPair.token1Price);
          reserve1 = double.parse(tokenPair.reserve1);
        } else {
          token0Price = double.parse(tokenPair.token1Price);
          reserve0 = double.parse(tokenPair.reserve1);
          token1Price = double.parse(tokenPair.token0Price);
          reserve1 = double.parse(tokenPair.reserve0);
        }
        final ratio = reserve0 / reserve1;
        final double recieveAmount = min(
          (token0Input * totalSupply) / reserve0,
          (token1Input * totalSupply) / reserve1,
        );
        final tokenPairBalance = lpTokenBalance ?? 0;
        final shareOfPool = ((tokenPairBalance + recieveAmount) /
                (totalSupply + recieveAmount)) *
            100;
        final poolPairInfo = PoolPairInfo(
          token0Price: token0Price.toStringAsFixed(6),
          token1Price: token1Price.toStringAsFixed(6),
          apy: '0',
          shareOfPool: shareOfPool.toStringAsFixed(6),
          ratio: ratio,
          recieveAmount: recieveAmount.toStringAsFixed(6),
          reserve0: reserve0.toStringAsFixed(6),
          reserve1: reserve1.toStringAsFixed(6),
        );
        return Either.left(Success(poolPairInfo));
      } else {
        return Either.right(
          const SubgraphError('Failed to fetch PairInfo from Subgraph'),
        );
      }
    } catch (e) {
      final errorMsg = 'Error occurred fetching PairInfo: $e';
      return Either.right(SubgraphError(errorMsg));
    }
  }
}

class Success {
  const Success(this.pairInfo);

  final PoolPairInfo pairInfo;
}
