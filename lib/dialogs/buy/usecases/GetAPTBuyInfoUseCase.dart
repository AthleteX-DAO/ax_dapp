import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:ax_dapp/service/BlockchainModels/AptPair.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';

const String _no_buy_info_error_msg = "No buy info found";

class GetAPTBuyInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetAPTBuyInfoUseCase(this._graphRepo);

  Future<Either<Success, Error>> fetchAptBuyInfo(String targetAddress) async {
    final tokenAddress = targetAddress.toLowerCase();
    try {
      print("target token address: $tokenAddress");
      print("fetching apt buy info");
      final tokenPairData = await _graphRepo.queryAllPairs();

      if (tokenPairData.isLeft()) {
        final data = tokenPairData.getLeft().toNullable();
        if (data != null) {
          print("data retrieved: ${data.toString()}");
          List pairs = data["pairs"];
          print("pairs =  ${pairs.toString()}");
          List<AptPair> aptPairs =
              pairs.map((pair) => AptPair.fromJson(pair)).toList();
          AptPair aptPair = aptPairs.firstWhere((aptPair) =>
              (aptPair.token0.id == tokenAddress ||
                  aptPair.token1.id == tokenAddress));
          final String aptLiquidity;
          final String axLiquidity;
          //If token0 id is the AX Polygon address then assign reserve0
          // and reserve1 to the liquidity variables respectively and vice versa
          if (aptPair.token0.id == AXT.polygonAddress) {
            axLiquidity = aptPair.reserve0;
            aptLiquidity = aptPair.reserve1;
          } else {
            axLiquidity = aptPair.reserve1;
            aptLiquidity = aptPair.reserve0;
          }
          print("Ax Liquidity = $axLiquidity");
          print("Apt Liquidity = $aptLiquidity");
          final aptBuyInfo =
              AptBuyInfo(double.parse(aptLiquidity), double.parse(axLiquidity));
          return Either.left(Success(aptBuyInfo));
        } else {
          return Either.right(Error(_no_buy_info_error_msg));
        }
      } else {
        print("fetching apt buy info failed: ${tokenPairData.getRight().toNullable().toString()}");
        final errorMsg = tokenPairData.getRight().toNullable().toString();
        return Either.right(
            Error("Error occurred fetching buy data: $errorMsg"));
      }
    } catch (e) {
      return Either.right(Error("Error occurred: ${e.toString()}"));
    }
  }
}

class Success {
  final AptBuyInfo aptBuyInfo;

  Success(this.aptBuyInfo);
}

class Error {
  final String errorMsg;

  Error(this.errorMsg);
}
