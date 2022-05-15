import 'package:ax_dapp/repositories/subgraph/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPairInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';

const String _no_buy_info_error_msg = "No buy info found";

/// This is an abstraction on the GetSwapInfoUseCase to request
/// PairInfo in the context of a "Buy" scenario; Because every buy
/// is essentially a swap
/// This is simply accomplished by hardcoding the tokenFrom value
/// to the AX Token address
class GetBuyInfoUseCase {
  final  GetSwapInfoUseCase _repo;

  GetBuyInfoUseCase(this._repo);

  Future<Either<Success, Error>> fetchAptBuyInfo(
      {required String aptAddress, double? axInput}) async {
    try {
      final newAxInput  = axInput ?? 0.0;
      final response = await _repo.fetchSwapInfo(
          tokenFrom: AXT.polygonAddress, tokenTo: aptAddress, fromInput: newAxInput);
      final isSuccess = response.isLeft();
      if (isSuccess) {
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        return Either.left(Success(swapInfo));
      } else {
        return Either.right(Error(_no_buy_info_error_msg));
      }
    } catch (e) {
      return Either.right(Error("Error occurred: ${e.toString()}"));
    }
  }
}

class Success {
  final TokenSwapInfo aptBuyInfo;

  Success(this.aptBuyInfo);
}

class Error {
  final String errorMsg;

  Error(this.errorMsg);
}
