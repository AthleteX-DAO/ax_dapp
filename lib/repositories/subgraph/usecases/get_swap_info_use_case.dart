import 'package:ax_dapp/repositories/subgraph/usecases/get_pair_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:fpdart/fpdart.dart';

const String _noSwapInfoErrorMessage = 'No swap info found';

/// This is an abstraction on GetPairInfoUseCase that encapsulates
/// the logic for fetching the swap transaction information needed for a swap
/// betweenany two given tokens.
class GetSwapInfoUseCase {
  GetSwapInfoUseCase(GetPairInfoUseCase repo) : _repo = repo;

  final GetPairInfoUseCase _repo;

  Future<Either<Success, Error>> fetchSwapInfo({
    required String tokenFrom,
    required String tokenTo,
    double? fromInput,
    double? slippage,
  }) async {
    try {
      final tokenFromAddress = tokenFrom.toLowerCase();
      final tokenToAddress = tokenTo.toLowerCase();
      final tokenFromInput = fromInput ?? 0.0;
      final slippageTolerance = slippage ?? 0.01;

      final response = await _repo.fetchPairInfo(
        tokenA: tokenFromAddress,
        tokenB: tokenToAddress,
        fromTokenInput: tokenFromInput,
      );

      final isSuccess = response.isLeft();
      if (isSuccess) {
        final tokenPair = response.getLeft().toNullable()!.pairInfo;
        final double fromReserve;
        final double toReserve;
        final double fromPrice;
        final double toPrice;
        //If token0 id is the AX Polygon address then assign reserve0
        // and reserve1 to the liquidity variables respectively and vice versa
        if (tokenPair.token0.id == tokenFromAddress) {
          fromReserve = double.parse(tokenPair.reserve0);
          toReserve = double.parse(tokenPair.reserve1);
          fromPrice = double.parse(tokenPair.token0Price);
          toPrice = double.parse(tokenPair.token1Price);
        } else {
          fromReserve = double.parse(tokenPair.reserve1);
          toReserve = double.parse(tokenPair.reserve0);
          fromPrice = double.parse(tokenPair.token1Price);
          toPrice = double.parse(tokenPair.token0Price);
        }

        final lpFee = tokenFromInput * 0.0025;
        final protocolFee = tokenFromInput * 0.0005;
        final totalFees = lpFee + protocolFee;
        final tokenFromInputAfterFee = tokenFromInput - totalFees;
        final receiveAmount = tokenFromInputAfterFee *
            (toReserve / (fromReserve + tokenFromInputAfterFee));
        final priceImpact = 100 *
            (1 -
                ((fromReserve * (toReserve - receiveAmount)) /
                    (toReserve * (fromReserve + tokenFromInputAfterFee))));

        final minimumReceiveAmt = receiveAmount * (1 - slippageTolerance);

        final swapInfo = TokenSwapInfo(
          toPrice: toPrice,
          fromPrice: fromPrice,
          minimumReceived: minimumReceiveAmt,
          priceImpact: priceImpact,
          receiveAmount: receiveAmount,
          totalFee: totalFees,
        );

        return Either.left(Success(swapInfo));
      } else {
        return Either.right(const Error(_noSwapInfoErrorMessage));
      }
    } catch (e) {
      return Either.right(Error('Error occurred: ${e.toString()}'));
    }
  }
}

class Success {
  const Success(this.swapInfo);

  final TokenSwapInfo swapInfo;
}

class Error {
  const Error(this.errorMsg);

  final String errorMsg;
}
