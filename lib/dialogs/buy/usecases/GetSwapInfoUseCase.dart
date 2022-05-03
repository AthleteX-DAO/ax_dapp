import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/SwapInfo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:fpdart/fpdart.dart';

const String _no_swap_info_error_msg = "No swap info found";

class GetSwapInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetSwapInfoUseCase(this._graphRepo);

  Future<Either<Success, Error>> fetchSwapInfo(
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
          final String fromReserve;
          final String toReserve;
          final String toPrice;
          //If token0 id is the AX Polygon address then assign reserve0
          // and reserve1 to the liquidity variables respectively and vice versa
          if (tokenPair.token0.id == tokenFromAddress) {
            fromReserve = tokenPair.reserve0;
            toReserve = tokenPair.reserve1;
            toPrice = tokenPair.token1Price;
          } else {
            fromReserve = tokenPair.reserve1;
            toReserve = tokenPair.reserve0;
            toPrice = tokenPair.token0Price;
          }
          print("From Reserve = $fromReserve");
          print("To Reserve = $toReserve");
          print("To Price = $toPrice");
          final swapInfo = SwapInfo(
              fromReserve: double.parse(fromReserve),
              toReserve: double.parse(toReserve),
              toPrice: double.parse(toPrice));
          return Either.left(Success(swapInfo));
        } else {
          return Either.right(Error(_no_swap_info_error_msg));
        }
      } else {
        print(
            "fetching swap info failed: ${tokenPairData.getRight().toNullable().toString()}");
        final errorMsg = tokenPairData.getRight().toNullable().toString();
        return Either.right(
            Error("Error occurred fetching swap data: $errorMsg"));
      }
    } catch (e) {
      return Either.right(Error("Error occurred: ${e.toString()}"));
    }
  }
}

class Success {
  final SwapInfo swapInfo;

  Success(this.swapInfo);
}

class Error {
  final String errorMsg;

  Error(this.errorMsg);
}
