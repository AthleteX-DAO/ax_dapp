import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:fpdart/fpdart.dart';

import 'SubgraphError.dart';

class GetPairInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetPairInfoUseCase(this._graphRepo);

  Future<Either<Success, SubgraphError>> fetchPairInfo(
      {required String tokenFrom, required String tokenTo}) async {
    final tokenFromAddress = tokenFrom.toLowerCase();
    final tokenToAddress = tokenTo.toLowerCase();
    try {
      print("token0 address: $tokenFromAddress");
      print("token1 address: $tokenToAddress");
      print("fetching swap info");
      final tokenPairData = await _graphRepo.queryPairDataForTokenAddress(
          tokenFromAddress, tokenToAddress);

      if (tokenPairData.isLeft()) {
        final data = tokenPairData.getLeft().toNullable();
        if (data != null) {
          print("data retrieved: ${data.toString()}");
          List pairs = data["pairs"];
          print("pairs =  ${pairs.toString()}");
          List<TokenPair> tokenPairs =
              pairs.map((pair) => TokenPair.fromJson(pair)).toList();
          TokenPair tokenPair = tokenPairs.firstWhere((tokenPair) =>
              ((tokenPair.token0.id == tokenFromAddress ||
                      tokenPair.token0.id == tokenToAddress) &&
                  (tokenPair.token1.id == tokenFromAddress ||
                      tokenPair.token1.id == tokenToAddress)));

          return Either.left(Success(tokenPair));
        } else {
          return Either.right(SubgraphError("Token Pair data was null"));
        }
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
  final TokenPair tokenPair;
  Success(this.tokenPair);
}
