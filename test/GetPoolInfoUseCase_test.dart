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
    final tokenAPrice = "1.010000";
    final tokenBPrice = "1.300000";

    final poolPairInfo = TokenPair(
      "testId",
      "testName",
      "100",
      "100",
      Token(targetTokenA.toLowerCase(), "tokenAName", null),
      Token(targetTokenB.toLowerCase(), "tokenBName", null),
      tokenAPrice,
      tokenBPrice,
      "100"
    );

    final Success testSuccessResponse = Success(poolPairInfo);
    when(mockRepo.fetchPairInfo(
      tokenA: captureAnyNamed('tokenA'),
      tokenB: captureAnyNamed('tokenB'),
    )).thenAnswer((_) async => Future.value(Either.left(testSuccessResponse)));

    final response = await getPoolInfoUseCase.fetchPairInfo(
        tokenA: targetTokenA, tokenB: targetTokenB);

    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.pairInfo.token0Price == tokenAPrice);
    assert(response.getLeft().toNullable()!.pairInfo.token1Price == tokenBPrice);
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
    final tokenAPrice = "1.010000";
    final tokenBPrice = "1.300000";

    final poolPairInfo = TokenPair(
      "testId",
      "testName",
      "100",
      "100",
      Token(targetTokenB.toLowerCase(), "tokenBName", null),
      Token(targetTokenA.toLowerCase(), "tokenAName", null),
      tokenAPrice,
      tokenBPrice,
      "100",
    );

    final Success testSuccessResponse = Success(poolPairInfo);
    when(mockRepo.fetchPairInfo(
      tokenA: captureAnyNamed('tokenA'),
      tokenB: captureAnyNamed('tokenB'),
    )).thenAnswer((_) async => Future.value(Either.left(testSuccessResponse)));

    final response = await getPoolInfoUseCase.fetchPairInfo(
        tokenA: targetTokenA, tokenB: targetTokenB);

    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.pairInfo.token0Price == tokenBPrice);
    assert(response.getLeft().toNullable()!.pairInfo.token1Price == tokenAPrice);
    expect(
        verify(mockRepo.fetchPairInfo(
          tokenB: captureAnyNamed('tokenB'),
          tokenA: captureAnyNamed('tokenA'),
        )).captured,
        [targetTokenB.toLowerCase(), targetTokenA.toLowerCase()]);
  });
}
