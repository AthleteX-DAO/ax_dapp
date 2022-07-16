// ignore_for_file: prefer_asserts_with_message

import 'package:ax_dapp/repositories/subgraph/usecases/GetBuyInfoUseCase.dart'
    as usecase;
import 'package:ax_dapp/repositories/subgraph/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPairInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'GetBuyInfoUseCase_test.mocks.dart';

@GenerateMocks([GetSwapInfoUseCase])
void main() {
  late usecase.GetBuyInfoUseCase buyInfoUseCase;
  var mockRepo = MockGetSwapInfoUseCase();

  setUp(() {
    mockRepo = MockGetSwapInfoUseCase();
    buyInfoUseCase = usecase.GetBuyInfoUseCase(mockRepo);
  });

  test('Should successfully fetch buy info details', () async {
    const targetBuyToken = 'targetBuyToken';
    const testAxInput = 1.13;
    const toPrice = 1.01;
    const fromPrice = 1.01;
    const testMinimumReceived = 0.21;
    const testPriceImpact = 12.01;
    const testReceivedAmount = 1.01;
    const testTotalFee = 4.01;

    const targetTokenSwapInfo = TokenSwapInfo(
      toPrice: toPrice,
      fromPrice: fromPrice,
      minimumReceived: testMinimumReceived,
      priceImpact: testPriceImpact,
      receiveAmount: testReceivedAmount,
      totalFee: testTotalFee,
    );
    const testSuccessResponse = Success(targetTokenSwapInfo);
    when(
      mockRepo.fetchSwapInfo(
        tokenFrom: captureAnyNamed('tokenFrom'),
        tokenTo: targetBuyToken,
        fromInput: testAxInput,
      ),
    ).thenAnswer(
      (_) async => Future.value(Either.left(testSuccessResponse)),
    );

    final response = await buyInfoUseCase.fetchAptBuyInfo(
      aptAddress: targetBuyToken,
      axInput: testAxInput,
    );

    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.aptBuyInfo == targetTokenSwapInfo);
    expect(
      verify(
        mockRepo.fetchSwapInfo(
          tokenFrom: captureAnyNamed('tokenFrom'),
          tokenTo: targetBuyToken,
          fromInput: testAxInput,
        ),
      ).captured,
      [AXT.polygonAddress],
    );
  });
}
