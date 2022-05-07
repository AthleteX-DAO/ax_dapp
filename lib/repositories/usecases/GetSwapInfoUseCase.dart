import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/repositories/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/SwapInfo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:fpdart/fpdart.dart';
class GetSwapInfoUseCase {
  final GetPairInfoUseCase _pairInfoFetcher;

  GetSwapInfoUseCase(this._pairInfoFetcher);

  Future<Either<Success, Error>> fetchSwapInfo(
      {required String tokenFrom, required String tokenTo}) async {
    final tokenFromAddress = tokenFrom.toLowerCase();
    final tokenToAddress = tokenTo.toLowerCase();
    try {
      final result = await _pairInfoFetcher.fetchPairInfo(
          tokenFrom: tokenFrom, tokenTo: tokenTo);
      final isSuccess = result.isLeft();
      if (isSuccess) {
        final tokenPair = result.getLeft().toNullable()!.tokenPair;
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
        print(
            "fetching swap info failed: ${result.getRight().toNullable().toString()}");
        final errorMsg = result.getRight().toNullable().toString();
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
