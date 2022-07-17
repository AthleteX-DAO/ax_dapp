// ignore_for_file: prefer_asserts_with_message

import 'dart:convert';
import 'dart:io';

import 'package:ax_dapp/pages/pool/my_liqudity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_all_liquidity_info_use_case_test.mocks.dart';

@GenerateMocks([SubGraphRepo])
void main() {
  test('Get All Liquidity Pairs Info Successfully', () async {
    final subGraphRepo = MockSubGraphRepo();
    final file =
        File('test_resources/queries/all_pairs_for_wallet_address.json');
    final sampleQueryJson = await file.readAsString();
    const walletIdTest = '0x571f8E570EFE1fb0bA8ff75f4749b629a471f458';
    const walletIdTestToLower = '0x571f8e570efe1fb0ba8ff75f4749b629a471f458';

    when(subGraphRepo.queryAllPairsForWalletId(walletIdTestToLower)).thenAnswer(
      (_) => Future.value(
        Either.left(json.decode(sampleQueryJson) as Map<String, dynamic>),
      ),
    );

    final useCase = GetAllLiquidityInfoUseCase(subGraphRepo);
    final result =
        await useCase.fetchAllLiquidityPositions(walletAddress: walletIdTest);

    assert(result.isLeft());
    final myLiquidityItemInfos =
        result.getLeft().toNullable()!.liquidityPositionsList;
    assert(
      myLiquidityItemInfos![0] ==
          const LiquidityPositionInfo(
            token0Name: 'AthleteX',
            token1Name: 'Juan Soto Linear Short Token',
            token0Symbol: 'AX',
            token1Symbol: 'JSST1010',
            token0Address: '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
            token1Address: '0xce44443d4f652fc6c48f62258c75278e11909d6a',
            lpTokenPairAddress: '0x49c62531a60feb3ccc8f85a6bb897bce53036e5b',
            lpTokenPairBalance: '86.602540',
            token0LpAmount: '7500.000000',
            token1LpAmount: '1.000000',
            shareOfPool: '100.000000',
            apy: '0',
          ),
    );
    assert(
      myLiquidityItemInfos![1] ==
          const LiquidityPositionInfo(
            token0Name: 'Vladimir Guerrero Jr Linear Short Token',
            token1Name: 'AthleteX',
            token0Symbol: 'VGJST1010',
            token1Symbol: 'AX',
            token0Address: '0x37d388321c2ce1e130e36443e8dae91836a786c0',
            token1Address: '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
            lpTokenPairAddress: '0xe802266d4ed92cc5beb5c065c7b247d572f16ab5',
            lpTokenPairBalance: '54.772438',
            token0LpAmount: '0.999997',
            token1LpAmount: '3000.029968',
            shareOfPool: '100.000000',
            apy: '0',
          ),
    );
    assert(
      myLiquidityItemInfos![2] ==
          const LiquidityPositionInfo(
            token0Name: 'AthleteX',
            token1Name: 'Marcus Semien Linear Long Token',
            token0Symbol: 'AX',
            token1Symbol: 'MSLT1010',
            token0Address: '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
            token1Address: '0xdf40952aaa578272061bd40becc125a5a510a62f',
            lpTokenPairAddress: '0xfaaee596be3f5903b1904d7946c19ade39b5813d',
            lpTokenPairBalance: '86.602540',
            token0LpAmount: '7700.000000',
            token1LpAmount: '0.974102',
            shareOfPool: '100.000000',
            apy: '0',
          ),
    );
  });
}
