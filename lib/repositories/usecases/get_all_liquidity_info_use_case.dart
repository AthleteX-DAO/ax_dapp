// ignore_for_file: avoid_dynamic_calls

import 'package:ax_dapp/pages/pool/my_liqudity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/subgraph_error.dart';
import 'package:ax_dapp/service/blockchain_models/liquidity_position.dart';
import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';

class GetAllLiquidityInfoUseCase {
  GetAllLiquidityInfoUseCase(SubGraphRepo graphRepo) : _graphRepo = graphRepo;

  final SubGraphRepo _graphRepo;

  Future<Either<Success, SubgraphError>> fetchAllLiquidityPositions({
    required String walletAddress,
  }) async {
    final walletId = walletAddress.toLowerCase();
    try {
      final tokenPairData = await _graphRepo.queryAllPairsForWalletId(walletId);

      if (tokenPairData.isLeft()) {
        final data = tokenPairData.getLeft().toNullable();
        final user = data!['user'];
        if (user != null) {
          final liquidityPositions =
              user['liquidityPositions'] as List<dynamic>;
          final liquidityPositionsParsed =
              List<Map<String, dynamic>>.from(liquidityPositions)
                  .map(LiquidityPosition.fromJson)
                  .toList();
          final liquidityPositionsWithZeroBalance = liquidityPositionsParsed
              .map(getMyLiquidityItemInfoFromLiquidityPosition)
              .toList();
          final liquidityPositionsNoZeroBalance =
              liquidityPositionsWithZeroBalance
                  .where(
                    (lpPosition) => lpPosition.lpTokenPairBalance != '0.000000',
                  )
                  .toList();
          return Either.left(Success(liquidityPositionsNoZeroBalance));
        } else {
          return Either.left(const Success(null));
        }
      } else {
        return Either.right(
          const SubgraphError(
            'Failed to fetch allLiquidityPairsInfo from Subgraph',
          ),
        );
      }
    } catch (e) {
      final errorMsg = 'Error occurred fetching allLiquidityPairsInfo: $e';
      return Either.right(SubgraphError(errorMsg));
    }
  }

  LiquidityPositionInfo getMyLiquidityItemInfoFromLiquidityPosition(
    LiquidityPosition liquidityPosition,
  ) {
    final token0Name = liquidityPosition.pair.token0.name;
    final token1Name = liquidityPosition.pair.token1.name;
    final token0Symbol = liquidityPosition.pair.token0.symbol!;
    final token1Symbol = liquidityPosition.pair.token1.symbol!;
    final token0Address = liquidityPosition.pair.token0.id;
    final token1Address = liquidityPosition.pair.token1.id;
    final lpTokenPairAddress = liquidityPosition.pair.id;
    final reserve0 = Decimal.parse(liquidityPosition.pair.reserve0);
    final reserve1 = Decimal.parse(liquidityPosition.pair.reserve1);
    final lpTokenPairBalance =
        Decimal.parse(liquidityPosition.liquidityTokenBalance);
    final lpTokenTotalSupply =
        Decimal.parse(liquidityPosition.pair.totalSupply!);
    final shareOfPool = (lpTokenPairBalance / lpTokenTotalSupply).toDecimal(
      scaleOnInfinitePrecision: 37,
    );
    // TODO(Jak): How to round irrational numbers? https://athletex.atlassian.net/browse/AX-519
    final token0LpAmount = shareOfPool * reserve0;
    final token1LpAmount = shareOfPool * reserve1;
    const apy = '0';
    // TODO(Jak): Implement APY calculation. https://athletex.atlassian.net/browse/AX-509
    return LiquidityPositionInfo(
      token0Name: token0Name,
      token1Name: token1Name,
      token0Symbol: token0Symbol,
      token1Symbol: token1Symbol,
      token0Address: token0Address,
      token1Address: token1Address,
      lpTokenPairAddress: lpTokenPairAddress,
      lpTokenPairBalance: lpTokenPairBalance.toStringAsFixed(6),
      token0LpAmount: token0LpAmount.toStringAsFixed(6),
      token1LpAmount: token1LpAmount.toStringAsFixed(6),
      shareOfPool: (shareOfPool * Decimal.fromInt(100)).toStringAsFixed(6),
      apy: apy,
    );
  }
}

class Success {
  const Success(this.liquidityPositionsList);

  final List<LiquidityPositionInfo>? liquidityPositionsList;
}
