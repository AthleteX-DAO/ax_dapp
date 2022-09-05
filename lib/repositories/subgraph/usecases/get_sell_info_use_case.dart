import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tokens_repository/tokens_repository.dart';

/// This is an abstraction on the GetSwapInfoUseCase to request
/// PairInfo in the context of a "Sell" scenario; Because every sell
/// is essentially a swap
/// This is simply accomplished by hardcoding the tokenTo value
/// to the AX Token address
const String _noSellInfoErrorMessage = 'No sell info found';

class GetSellInfoUseCase {
  GetSellInfoUseCase({
    required TokensRepository tokensRepository,
    required GetSwapInfoUseCase repo,
  })  : _tokensRepository = tokensRepository,
        _repo = repo;

  final TokensRepository _tokensRepository;
  final GetSwapInfoUseCase _repo;

  Future<Either<Success, Error>> fetchAptSellInfo({
    required String aptAddress,
    double? aptInput,
  }) async {
    try {
      final newAptInput = aptInput ?? 0.0;
      final currentAxt = _tokensRepository.currentAxt;
      final response = await _repo.fetchSwapInfo(
        tokenFrom: aptAddress,
        tokenTo: currentAxt.address,
        fromInput: newAptInput,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        return Either.left(Success(swapInfo));
      } else {
        return Either.right(const Error(_noSellInfoErrorMessage));
      }
    } catch (e) {
      return Either.right(Error('Error occurred: ${e.toString()}'));
    }
  }
}

class Success {
  const Success(this.sellInfo);

  final TokenSwapInfo sellInfo;
}

class Error {
  const Error(this.errorMsg);

  final String errorMsg;
}
