import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:fpdart/fpdart.dart';

import '../SubGraphRepo.dart';

/// This is an abstraction on the SubgraphRepo that defines
/// the general usecase of requesting information for any given token pair
/// this can be used to fetch data to complete functions like swap, pool liquidity
const String _no_swap_info_error_msg = "No pair info found";
class GetPairInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetPairInfoUseCase(this._graphRepo);

  Future<Either<Success, Error>> fetchPairInfo(
      {required String tokenA,
      required String tokenB,
      double? fromTokenInput}) async {
    final tokenAddressA = tokenA.toLowerCase();
    final tokenAddressB = tokenB.toLowerCase();

    try {
      print("token0 address: $tokenAddressA");
      print("token1 address: $tokenAddressB");
      print("fetching swap info");
      final tokenPairData = await _graphRepo.queryPairDataForTokenAddress(
          tokenAddressA, tokenAddressB);

      if (tokenPairData.isLeft()) {
        final data = tokenPairData.getLeft().toNullable();
        if (data != null) {
          print("data retrieved: ${data.toString()}");
          List pairs = data["pairs"];
          print("pairs =  ${pairs.toString()}");
          List<TokenPair> tokenPairs =
              pairs.map((pair) => TokenPair.fromJson(pair)).toList();
          TokenPair tokenPair = tokenPairs.firstWhere((tokenPair) =>
              ((tokenPair.token0.id == tokenAddressA ||
                      tokenPair.token0.id == tokenAddressB) &&
                  (tokenPair.token1.id == tokenAddressA ||
                      tokenPair.token1.id == tokenAddressB)));
          return Either.left(Success(tokenPair));
        } else {
          return Either.right(Error(_no_swap_info_error_msg));
        }
      } else {
        print(
            "fetching pair info failed: ${tokenPairData.getRight().toNullable().toString()}");
        final errorMsg = tokenPairData.getRight().toNullable().toString();
        return Either.right(
            Error("Error occurred fetching pair data: $errorMsg"));
      }
    } catch (e) {
      return Either.right(Error("Error occurred: ${e.toString()}"));
    }
  }
}

class Success {
  final TokenPair pairInfo;

  Success(this.pairInfo);
}

class Error {
  final String errorMsg;

  Error(this.errorMsg);
}
