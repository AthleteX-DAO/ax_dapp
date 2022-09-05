// ignore_for_file: prefer_asserts_with_message

import 'package:ax_dapp/repositories/subgraph/usecases/get_pair_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart'
    as usecase;
import 'package:ax_dapp/service/blockchain_models/token.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_swap_info_use_case_test.mocks.dart';

const String targetTokenFrom = 'targetTokenFrom';
const String targetTokenTo = 'targetTokenTo';
const String testTokenFromPrice = '0.325';
const String testTokenToPrice = '0.343';
const double tokenFromReserve = 0.0234;
const double tokenToReserve = 5;
const double inputAmount = 2.5;

const double expectedMinimumReceived = 4.90396080925315;
const double expectedPriceImpact = 99.99134942522345;
const double expectedReceivedAmount = 4.953495766922374;
const double expectedTotalFee = 0.007500000000000001;

@GenerateMocks([GetPairInfoUseCase])
void main() {
  late usecase.GetSwapInfoUseCase getPoolInfoUseCase;
  var mockRepo = MockGetPairInfoUseCase();
  // these values are not accurate as they aren't used in the calculations

  setUp(() {
    mockRepo = MockGetPairInfoUseCase();
    getPoolInfoUseCase = usecase.GetSwapInfoUseCase(mockRepo);
  });

  test(
      '''Should successfully fetch swap info details,  when tokenFrom is returned as token0''',
      () async {
    final tokenPairInfo = TokenPair(
      'testId',
      'testName',
      tokenFromReserve.toString(),
      tokenToReserve.toString(),
      Token(targetTokenFrom.toLowerCase(), 'targetTokenFrom', null),
      Token(targetTokenTo.toLowerCase(), 'targetTokenTo', null),
      testTokenFromPrice,
      testTokenToPrice,
      null,
      null,
    );

    final testSuccessResponse = Success(tokenPairInfo);
    when(
      mockRepo.fetchPairInfo(
        tokenA: captureAnyNamed('tokenA'),
        tokenB: captureAnyNamed('tokenB'),
        fromTokenInput: inputAmount,
      ),
    ).thenAnswer(
      (_) async => Future.value(Either.left(testSuccessResponse)),
    );

    final response = await getPoolInfoUseCase.fetchSwapInfo(
      tokenFrom: targetTokenFrom,
      tokenTo: targetTokenTo,
      fromInput: inputAmount,
    );

    assert(response.isLeft());
    confirmSwapInfo(response);
    expect(
      verify(
        mockRepo.fetchPairInfo(
          tokenA: captureAnyNamed('tokenA'),
          tokenB: captureAnyNamed('tokenB'),
          fromTokenInput: inputAmount,
        ),
      ).captured,
      [targetTokenFrom.toLowerCase(), targetTokenTo.toLowerCase()],
    );
  });

  test(
      '''Should successfully fetch swap info details,  when tokenFrom is returned as token1''',
      () async {
    final tokenPairInfo = TokenPair(
      'testId',
      'testName',
      tokenToReserve.toString(),
      //reserve0
      tokenFromReserve.toString(),
      //reserve1
      Token(targetTokenTo.toLowerCase(), 'targetTokenFrom', null),
      //token0
      Token(targetTokenFrom.toLowerCase(), 'targetTokenTo', null),
      //token1
      testTokenToPrice,
      testTokenFromPrice,
      null,
      null,
    );

    final testSuccessResponse = Success(tokenPairInfo);
    when(
      mockRepo.fetchPairInfo(
        tokenA: captureAnyNamed('tokenA'),
        tokenB: captureAnyNamed('tokenB'),
        fromTokenInput: inputAmount,
      ),
    ).thenAnswer((_) async => Future.value(Either.left(testSuccessResponse)));

    final response = await getPoolInfoUseCase.fetchSwapInfo(
      tokenFrom: targetTokenFrom,
      tokenTo: targetTokenTo,
      fromInput: inputAmount,
    );

    assert(response.isLeft());
    // TokenSwapInfo should return the same way despite tokenFrom returning as
    // token1
    confirmSwapInfo(response);
    expect(
      verify(
        mockRepo.fetchPairInfo(
          tokenA: captureAnyNamed('tokenA'),
          tokenB: captureAnyNamed('tokenB'),
          fromTokenInput: inputAmount,
        ),
      ).captured,
      [targetTokenFrom.toLowerCase(), targetTokenTo.toLowerCase()],
    );
  });
}

void confirmSwapInfo(Either<usecase.Success, usecase.Error> response) {
  assert(
    response.getLeft().toNullable()!.swapInfo ==
        TokenSwapInfo(
          fromPrice: double.parse(testTokenFromPrice),
          toPrice: double.parse(testTokenToPrice),
          minimumReceived: expectedMinimumReceived,
          priceImpact: expectedPriceImpact,
          receiveAmount: expectedReceivedAmount,
          totalFee: expectedTotalFee,
        ),
  );
}
