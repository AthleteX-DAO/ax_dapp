import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/repositories/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';

const String _no_buy_info_error_msg = "No buy info found";

class GetAPTBuyInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetAPTBuyInfoUseCase(this._graphRepo);

  Future<Either<Success, Error>> fetchAptBuyInfo(
       String aptAddress) async {
    final _repo = GetSwapInfoUseCase(_graphRepo);
    try {
      final response = await _repo.fetchSwapInfo(
          tokenFrom: AXT.polygonAddress, tokenTo: aptAddress);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        final aptSellInfo = AptBuyInfo(
          swapInfo.toReserve,
          swapInfo.fromReserve,          
        );
        return Either.left(Success(aptSellInfo));
      } else {
        return Either.right(Error(_no_buy_info_error_msg));
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
