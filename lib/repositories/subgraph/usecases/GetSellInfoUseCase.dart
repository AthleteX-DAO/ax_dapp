import 'package:ax_dapp/repositories/subgraph/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPairInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';


/// This is an abstraction on the GetSwapInfoUseCase to request
/// PairInfo in the context of a "Sell" scenario; Because every sell
/// is essentially a swap
/// This is simply accomplished by hardcoding the tokenTo value
/// to the AX Token address
const String _no_sell_info_error_msg = "No sell info found";

class GetSellInfoUseCase {
  final GetSwapInfoUseCase _repo;

  GetSellInfoUseCase(this._repo);

  Future<Either<Success, Error>> fetchAptSellInfo(
      {required String aptAddress, double? aptInput}) async {
    try {
      final newAptInput = aptInput ?? 0.0;
      final response = await _repo.fetchSwapInfo(
          tokenFrom: aptAddress, tokenTo: AXT.polygonAddress, fromInput: newAptInput);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        return Either.left(Success(swapInfo));
      } else {
        return Either.right(Error(_no_sell_info_error_msg));
      }
    } catch (e) {
      return Either.right(Error("Error occurred: ${e.toString()}"));
    }
  }
}

class Success {
  final TokenSwapInfo sellInfo;
  Success(this.sellInfo);
}

class Error {
  final String errorMsg;

  Error(this.errorMsg);
}
