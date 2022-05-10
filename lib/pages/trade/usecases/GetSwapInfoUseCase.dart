import 'package:ax_dapp/repositories/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/SwapInfo.dart';
import 'package:ax_dapp/service/Controller/usecases/GetPairInfoUseCase.dart';
import 'package:fpdart/fpdart.dart';

const String _no_swap_info_error_msg = "No swap info found";

class GetSwapInfoUseCase {
  final SubGraphRepo _repo;

  GetSwapInfoUseCase(this._repo);

  Future<Either<Success, Error>> fetchSwaplInfo(
      {required String tokenFrom, required String tokenTo, fromInput}) async {
    try {
      final _swapRepo = GetTokenPairInfoUseCase(_repo);
      final newFromInput = fromInput ?? 0.0;
      final response = await _swapRepo.fetchPairInfo(
          tokenFrom: tokenFrom, tokenTo: tokenTo, fromTokenInput: newFromInput);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final pairInfo = response.getLeft().toNullable()!.pairInfo;
        final swapInfo = SwapInfo(
            toPrice: pairInfo.toPrice,
            minimumReceived: pairInfo.minimumReceived,
            priceImpact: pairInfo.priceImpact,
            receiveAmount: pairInfo.receiveAmount,
            totalFee: pairInfo.totalFee);
        return Either.left(Success(swapInfo));
      } else {
        return Either.right(Error(_no_swap_info_error_msg));
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
