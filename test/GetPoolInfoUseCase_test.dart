import 'package:ax_dapp/repositories/subgraph/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPoolInfoUseCase.dart'
    as UseCase;
import 'package:ax_dapp/service/BlockchainModels/Token.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'GetPoolInfoUseCase_test.mocks.dart';


@GenerateMocks([GetPairInfoUseCase])
void main() {
  late UseCase.GetPoolInfoUseCase getPoolInfoUseCase;
  var mockRepo = MockGetPairInfoUseCase();

  setUp(() {
    mockRepo = MockGetPairInfoUseCase();
    getPoolInfoUseCase = UseCase.GetPoolInfoUseCase(mockRepo);
  });

  test(
      "Should successfully fetch pair info details, and return tokenOPrice as tokenA price,  when tokenA is token0",
      () async {
    final targetTokenA = "targetTokenA";
    final targetTokenB = "targetTokenB";
    final tokenAPrice = "1.01";
    final tokenBPrice = "1.3";

    final poolPairInfo = TokenPair(
      "testId",
      "testName",
      "testReserve0",
      "testReserve1",
      Token(targetTokenA.toLowerCase(), "tokenAName"),
      Token(targetTokenB.toLowerCase(), "tokenBName"),
      tokenAPrice,
      tokenBPrice,
    );

    final Success testSuccessResponse = Success(poolPairInfo);
    when(mockRepo.fetchPairInfo(
      tokenA: captureAnyNamed('tokenA'),
      tokenB: captureAnyNamed('tokenB'),
    )).thenAnswer((_) async => Future.value(Either.left(testSuccessResponse)));

    final response = await getPoolInfoUseCase.fetchPairInfo(
        tokenA: targetTokenA, tokenB: targetTokenB);

    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.pairInfo.token0Price ==
        double.parse(tokenAPrice));
    assert(response.getLeft().toNullable()!.pairInfo.token1Price ==
        double.parse(tokenBPrice));
    expect(
        verify(mockRepo.fetchPairInfo(
                tokenA: captureAnyNamed('tokenA'),
                tokenB: captureAnyNamed('tokenB')))
            .captured,
        [targetTokenA.toLowerCase(), targetTokenB.toLowerCase()]);
  });

  test(
      "Should successfully fetch pair info details, and return tokenOPrice as tokenB Price,  when tokenA is returned one token1",
      () async {
    final targetTokenA = "targetTokenA";
    final targetTokenB = "targetTokenB";
    final tokenAPrice = "1.01";
    final tokenBPrice = "1.3";

    final poolPairInfo = TokenPair(
      "testId",
      "testName",
      "testReserve0",
      "testReserve1",
      Token(targetTokenB.toLowerCase(), "tokenBName"),
      Token(targetTokenA.toLowerCase(), "tokenAName"),
      tokenAPrice,
      tokenBPrice,
    );

    final Success testSuccessResponse = Success(poolPairInfo);
    when(mockRepo.fetchPairInfo(
      tokenA: captureAnyNamed('tokenA'),
      tokenB: captureAnyNamed('tokenB'),
    )).thenAnswer((_) async => Future.value(Either.left(testSuccessResponse)));

    final response = await getPoolInfoUseCase.fetchPairInfo(
        tokenA: targetTokenA, tokenB: targetTokenB);

    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.pairInfo.token0Price ==
        double.parse(tokenBPrice));
    assert(response.getLeft().toNullable()!.pairInfo.token1Price ==
        double.parse(tokenAPrice));
    expect(
        verify(mockRepo.fetchPairInfo(
          tokenB: captureAnyNamed('tokenB'),
          tokenA: captureAnyNamed('tokenA'),
        )).captured,
        [targetTokenB.toLowerCase(), targetTokenA.toLowerCase()]);
  });
}
