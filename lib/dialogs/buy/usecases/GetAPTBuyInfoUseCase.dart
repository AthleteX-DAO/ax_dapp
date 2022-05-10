import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/usecases/GetPairInfoUseCase.dart';
import 'package:fpdart/fpdart.dart';

const String _no_buy_info_error_msg = "No buy info found";

class GetAPTBuyInfoUseCase {
  final SubGraphRepo _repo;

  GetAPTBuyInfoUseCase(this._repo);

  Future<Either<Success, Error>> fetchAptBuyInfo(
      {required String aptAddress, double? axInput}) async {
    try {
      final _pairRepo = GetTokenPairInfoUseCase(_repo);
      final newAxInput = axInput ?? 0.0;
      final response = await _pairRepo.fetchPairInfo(
          tokenFrom: AXT.polygonAddress, tokenTo: aptAddress, fromTokenInput: newAxInput);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final pairInfo = response.getLeft().toNullable()!.pairInfo;
        final aptSellInfo = AptBuyInfo(
            aptPrice: pairInfo.toPrice,
            minimumReceived: pairInfo.minimumReceived,
            priceImpact: pairInfo.priceImpact,
            receiveAmount: pairInfo.receiveAmount,
            totalFee: pairInfo.totalFee);
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
