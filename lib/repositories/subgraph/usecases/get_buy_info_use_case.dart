import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:fpdart/fpdart.dart';

const String _noBuyInfoErrorMessage = 'No buy info found';

/// This is an abstraction on the GetSwapInfoUseCase to request
/// PairInfo in the context of a "Buy" scenario; Because every buy
/// is essentially a swap
/// This is simply accomplished by hardcoding the tokenFrom value
/// to the AX Token address
class GetBuyInfoUseCase {
  GetBuyInfoUseCase(GetSwapInfoUseCase repo) : _repo = repo;

  final GetSwapInfoUseCase _repo;

  Future<Either<Success, Error>> fetchAptBuyInfo({
    required String aptAddress,
    double? axInput,
  }) async {
    try {
      final newAxInput = axInput ?? 0.0;
      final response = await _repo.fetchSwapInfo(
        tokenFrom: AXT.polygonAddress,
        tokenTo: aptAddress,
        fromInput: newAxInput,
      );
      final isSuccess = response.isLeft();
      if (isSuccess) {
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        return Either.left(Success(swapInfo));
      } else {
        return Either.right(Error(_noBuyInfoErrorMessage));
      }
    } catch (e) {
      return Either.right(Error('Error occurred: ${e.toString()}'));
    }
  }
}

class Success {
  Success(this.aptBuyInfo);
  final TokenSwapInfo aptBuyInfo;
}

class Error {
  Error(this.errorMsg);
  final String errorMsg;
}
