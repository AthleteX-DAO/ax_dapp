import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair.dart';
import 'package:fpdart/fpdart.dart';

/// This is an abstraction on the SubgraphRepo that defines
/// the general usecase of requesting information for any given token pair
/// this can be used to fetch data to complete functions like swap, pool
/// liquidity
const String _noSwapInfoErrorMessage = 'No pair info found';

class GetPairInfoUseCase {
  GetPairInfoUseCase(SubGraphRepo graphRepo) : _graphRepo = graphRepo;

  final SubGraphRepo _graphRepo;

  Future<Either<Success, Error>> fetchPairInfo({
    required String tokenA,
    required String tokenB,
    double? fromTokenInput,
  }) async {
    final tokenAddressA = tokenA.toLowerCase();
    final tokenAddressB = tokenB.toLowerCase();

    try {
      final tokenPairData = await _graphRepo.queryPairDataForTokenAddress(
        tokenAddressA,
        tokenAddressB,
      );

      if (tokenPairData.isLeft()) {
        final data = tokenPairData.getLeft().toNullable();
        if (data != null) {
          final pairs = data['pairs'] as List<dynamic>;
          final tokenPairs = List<Map<String, dynamic>>.from(pairs)
              .map(TokenPair.fromJson)
              .toList();
          final tokenPair = tokenPairs.firstWhere(
            (tokenPair) =>
                (tokenPair.token0.id == tokenAddressA ||
                    tokenPair.token0.id == tokenAddressB) &&
                (tokenPair.token1.id == tokenAddressA ||
                    tokenPair.token1.id == tokenAddressB),
          );
          return Either.left(Success(tokenPair));
        } else {
          return Either.right(const Error(_noSwapInfoErrorMessage));
        }
      } else {
        final errorMsg = tokenPairData.getRight().toNullable().toString();
        return Either.right(
          Error('Error occurred fetching pair data: $errorMsg'),
        );
      }
    } catch (e) {
      return Either.right(Error('Error occurred: ${e.toString()}'));
    }
  }
}

class Success {
  const Success(this.pairInfo);

  final TokenPair pairInfo;
}

class Error {
  const Error(this.errorMsg);

  final String errorMsg;
}
