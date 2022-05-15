import 'package:ax_dapp/pages/pool/models/PoolPairInfo.dart';
import 'package:fpdart/fpdart.dart';
import 'GetPairInfoUseCase.dart';
import 'SubgraphError.dart';

class GetPoolInfoUseCase {
  final GetPairInfoUseCase _repo;

  GetPoolInfoUseCase(this._repo);

  Future<Either<Success, SubgraphError>> fetchPairInfo(
      {required String tokenA, required String tokenB}) async {
    final tokenFromAddress = tokenA.toLowerCase();
    final tokenToAddress = tokenB.toLowerCase();
    try {
      print("token0 address: $tokenFromAddress");
      print("token1 address: $tokenToAddress");
      print("fetching swap info");
      final tokenPairData = await _repo.fetchPairInfo(
          tokenA: tokenFromAddress, tokenB: tokenToAddress);

      if (tokenPairData.isLeft()) {
        final tokenPair = tokenPairData.getLeft().toNullable()!.pairInfo;

        final token0Price;
        final token1Price;

        if (tokenPair.token0.id == tokenFromAddress) {
          token0Price = tokenPair.token0Price;
          token1Price = tokenPair.token1Price;
        } else {
          token0Price = tokenPair.token1Price;
          token1Price = tokenPair.token0Price;
        }

        final poolPairInfo = PoolPairInfo(
            token0Price: double.parse(token0Price),
            token1Price: double.parse(token1Price));
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
