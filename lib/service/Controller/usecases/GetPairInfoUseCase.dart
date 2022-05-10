import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPairInfo.dart';
import 'package:fpdart/fpdart.dart';

const String _no_swap_info_error_msg = "No pair info found";

class GetTokenPairInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetTokenPairInfoUseCase(this._graphRepo);

  Future<Either<Success, Error>> fetchPairInfo(
      {required String tokenFrom,
      required String tokenTo,
      double? fromTokenInput, double? slippage}) async {
    final tokenFromAddress = tokenFrom.toLowerCase();
    final tokenToAddress = tokenTo.toLowerCase();
    final tokenFromInput = fromTokenInput ?? 0.0;
    final double slippageTolerance = slippage ?? 0.01;
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
          final double fromReserve;
          final double toReserve;
          final double fromPrice;
          final double toPrice;
          //If token0 id is the AX Polygon address then assign reserve0
          // and reserve1 to the liquidity variables respectively and vice versa
          if (tokenPair.token0.id == tokenFromAddress) {
            fromReserve = double.parse(tokenPair.reserve0);
            toReserve = double.parse(tokenPair.reserve1);
            fromPrice = double.parse(tokenPair.token0Price);
            toPrice = double.parse(tokenPair.token1Price);
          } else {
            fromReserve = double.parse(tokenPair.reserve1);
            toReserve = double.parse(tokenPair.reserve0);
            fromPrice = double.parse(tokenPair.token1Price);
            toPrice = double.parse(tokenPair.token0Price);
          }

          final lpFee = tokenFromInput * 0.0025;
          final protocolFee = tokenFromInput * 0.0005;
          final totalFees = lpFee + protocolFee;
          final tokenFromInputNoFee = tokenFromInput - totalFees;
          final receiveAmount = (tokenFromInputNoFee) *
              (toReserve / (fromReserve + tokenFromInputNoFee));
          final priceImpact = 100 *
              (1 -
                  ((fromReserve * (toReserve - receiveAmount)) /
                      (toReserve * (fromReserve + tokenFromInputNoFee))));

          final minimumReceiveAmt = receiveAmount * (1 - slippageTolerance);

          final pairInfo = TokenPairInfo(
              toPrice: toPrice,
              fromPrice: fromPrice,
              minimumReceived: minimumReceiveAmt,
              priceImpact: priceImpact,
              receiveAmount: receiveAmount,
              totalFee: totalFees);
          return Either.left(Success(pairInfo));
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
  final TokenPairInfo pairInfo;

  Success(this.pairInfo);
}

class Error {
  final String errorMsg;

  Error(this.errorMsg);
}
