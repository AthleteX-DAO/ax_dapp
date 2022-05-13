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
      {required String tokenFrom,
      required String tokenTo,
      double? fromTokenInput}) async {
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
