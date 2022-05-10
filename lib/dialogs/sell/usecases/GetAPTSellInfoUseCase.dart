import 'package:ax_dapp/dialogs/buy/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/AptSellInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';

const String _no_sell_info_error_msg = "No sell info found";

class GetAPTSellInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetAPTSellInfoUseCase(this._graphRepo);

  Future<Either<Success, Error>> fetchAptSellInfo(
      {required String aptAddress}) async {
    final _repo = GetSwapInfoUseCase(_graphRepo);
    try {
      final response = await _repo.fetchSwapInfo(
          tokenFrom: aptAddress, tokenTo: AXT.polygonAddress);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        final aptSellInfo = AptSellInfo(
            aptLiquidity: swapInfo.fromReserve,
            axLiquidity: swapInfo.toReserve,
            axPrice: swapInfo.toPrice);
         return Either.left(Success(aptSellInfo));
      } else {
        return Either.right(Error(_no_sell_info_error_msg));
      }
    } catch (e) {
      return Either.right(Error("Error occurred: ${e.toString()}"));
    }
  }
}

class Success {
  final AptSellInfo aptSellInfo;

  Success(this.aptSellInfo);
}

class Error {
  final String errorMsg;

  Error(this.errorMsg);
}
