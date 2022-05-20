import 'dart:math';

import 'package:ax_dapp/pages/pool/AddLiquidity/models/PoolPairInfo.dart';
import 'package:fpdart/fpdart.dart';
import 'GetPairInfoUseCase.dart';
import 'SubgraphError.dart';

class GetPoolInfoUseCase {
  final GetPairInfoUseCase _repo;

  GetPoolInfoUseCase(this._repo);

  Future<Either<Success, SubgraphError>> fetchPairInfo(
      {double? tokenAInput,
      double? tokenBInput,
      required String tokenA,
      required String tokenB}) async {
    final tokenFromAddress = tokenA.toLowerCase();
    final tokenToAddress = tokenB.toLowerCase();
    final token0Input = tokenAInput ?? 0.0;
    final token1Input = tokenBInput ?? 0.0;
    try {
      print("token0 address: $tokenFromAddress");
      print("token1 address: $tokenToAddress");
      print("fetching swap info");
      final tokenPairData = await _repo.fetchPairInfo(
          tokenA: tokenFromAddress, tokenB: tokenToAddress);

      if (tokenPairData.isLeft()) {
        final tokenPair = tokenPairData.getLeft().toNullable()!.pairInfo;

        final double token0Price;
        final double token1Price;
        final double reserve0;
        final double reserve1;
        final double totalSupply = double.parse(tokenPair.totalSupply!);

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
        final double ratio = (reserve0/reserve1);
        final double recieveAmount = min(((token0Input * totalSupply)/reserve0),((token1Input * totalSupply)/reserve1));
        final double shareOfPool = (recieveAmount/totalSupply) * 100;
        final PoolPairInfo poolPairInfo = PoolPairInfo(
            token0Price: token0Price.toStringAsFixed(6),
            token1Price: token1Price.toStringAsFixed(6),
            apy: '0',
            shareOfPool: shareOfPool.toStringAsFixed(6),
            ratio: ratio,
            recieveAmount: recieveAmount.toStringAsFixed(6));
        return Either.left(Success(poolPairInfo));
      } else {
        return Either.right(
            SubgraphError("Failed to fetch PairInfo from Subgraph"));
      }
    } catch (e) {
      var errorMsg = "Error occurred fetching PairInfo: $e";
      print(errorMsg);
      return Either.right(SubgraphError(errorMsg));
    }
  }
}

class Success {
  final PoolPairInfo pairInfo;
  Success(this.pairInfo);
}
