import 'package:ax_dapp/pages/pool/MyLiqudity/models/MyLiquidityItemInfo.dart';
import 'package:ax_dapp/repositories/subgraph/SubGraphRepo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/SubgraphError.dart';
import 'package:ax_dapp/service/BlockchainModels/LiquidityPosition.dart';
import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';

class GetAllLiquidityInfoUseCase {
  final SubGraphRepo _graphRepo;

  GetAllLiquidityInfoUseCase(this._graphRepo);

  Future<Either<Success, SubgraphError>> fetchAllLiquidityPositions(
      {required String walletAddress}) async {
    final walletId = walletAddress.toLowerCase();
    try {
      print("wallet address: $walletId");
      print("fetching liquidity pairs info");
      final tokenPairData = await _graphRepo.queryAllPairsForWalletId(walletId);

      if (tokenPairData.isLeft()) {
        final data = tokenPairData.getLeft().toNullable();
        if (data != null) {
          print("data retrieved: ${data.toString()}");
          final user = data["user"];
          print("user retrieved: ${user.toString()}");
          final liquidityPositions = user["liquidityPositions"];
          print("liquidityPositions =  ${liquidityPositions.toString()}");
          List<LiquidityPosition> liquidityPositionsParsed = liquidityPositions
              .map<LiquidityPosition>((liquidityPosition) =>
                  LiquidityPosition.fromJson(liquidityPosition))
              .toList();
          final List<LiquidityPositionInfo> liquidityPositionsWithZeroBalance =
              liquidityPositionsParsed
                  .map((liquidityPosition) =>
                      getMyLiquidityItemInfoFromLiquidityPosition(
                          liquidityPosition))
                  .toList();
          final List<LiquidityPositionInfo> liquidityPositionsNoZeroBalance =
              liquidityPositionsWithZeroBalance
                  .where((lpPosition) => lpPosition.lpTokenPairBalance != '0').toList();
          print(liquidityPositionsNoZeroBalance);
          return Either.left(Success(liquidityPositionsNoZeroBalance));
        } else {
          return Either.left(Success(null));
        }
      } else {
        return Either.right(SubgraphError(
            "Failed to fetch allLiquidityPairsInfo from Subgraph"));
      }
    } catch (e) {
      var errorMsg = "Error occurred fetching allLiquidityPairsInfo: $e";
      print(errorMsg);
      return Either.right(SubgraphError(errorMsg));
    }
  }

  LiquidityPositionInfo getMyLiquidityItemInfoFromLiquidityPosition(
      LiquidityPosition liquidityPosition) {
    final String token0Name = liquidityPosition.pair.token0.name;
    final String token1Name = liquidityPosition.pair.token1.name;
    final String token0Symbol = liquidityPosition.pair.token0.symbol!;
    final String token1Symbol = liquidityPosition.pair.token1.symbol!;
    final String token0Address = liquidityPosition.pair.token0.id;
    final String token1Address = liquidityPosition.pair.token1.id;
    final String lpTokenPairAddress = liquidityPosition.pair.id;
    final Decimal reserve0 = Decimal.parse(liquidityPosition.pair.reserve0);
    final Decimal reserve1 = Decimal.parse(liquidityPosition.pair.reserve1);
    final Decimal lpTokenPairBalance =
        Decimal.parse(liquidityPosition.liquidityTokenBalance);
    final Decimal lpTokenTotalSupply =
        Decimal.parse(liquidityPosition.pair.totalSupply!);
    final Decimal shareOfPool = (lpTokenPairBalance / lpTokenTotalSupply)
        .toDecimal(
            scaleOnInfinitePrecision:
                37); //TODO: How to round irrational numbers? https://athletex.atlassian.net/browse/AX-519
    final String token0LpAmount = (shareOfPool * reserve0).toString();
    final String token1LpAmount = (shareOfPool * reserve1).toString();
    final String apy = '0'; // TODO: Implement APY calculation. https://athletex.atlassian.net/browse/AX-509
    return LiquidityPositionInfo(
        token0Name: token0Name,
        token1Name: token1Name,
        token0Symbol: token0Symbol,
        token1Symbol: token1Symbol,
        token0Address: token0Address,
        token1Address: token1Address,
        lpTokenPairAddress: lpTokenPairAddress,
        lpTokenPairBalance: lpTokenPairBalance.toString(),
        token0LpAmount: token0LpAmount,
        token1LpAmount: token1LpAmount,
        shareOfPool: shareOfPool.toString(),
        apy: apy);
  }
}

class Success {
  final List<LiquidityPositionInfo>? liquidityPositionsList;
  Success(this.liquidityPositionsList);
}
