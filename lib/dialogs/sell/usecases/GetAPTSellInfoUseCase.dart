import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/Controller/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptSellInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';

const String _no_sell_info_error_msg = "No sell info found";

class GetAPTSellInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetAPTSellInfoUseCase(this._graphRepo);

  Future<Either<Success, Error>> fetchAptSellInfo(
      {required String aptAddress, double? aptInput}) async {
    try {
      final _pairRepo = GetTokenPairInfoUseCase(_graphRepo);
      final newAptInput = aptInput ?? 0.0;
      final response = await _pairRepo.fetchPairInfo(
          tokenFrom: aptAddress, tokenTo: AXT.polygonAddress, fromTokenInput: newAptInput);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final pairInfo = response.getLeft().toNullable()!.pairInfo;
        final aptSellInfo = AptSellInfo(
            axPrice: pairInfo.toPrice,
            minimumReceived: pairInfo.minimumReceived,
            priceImpact: pairInfo.priceImpact,
            receiveAmount: pairInfo.receiveAmount,
            totalFee: pairInfo.totalFee);
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
