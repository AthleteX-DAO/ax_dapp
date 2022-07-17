// ignore_for_file: prefer_asserts_with_message

import 'package:ax_dapp/repositories/subgraph/usecases/get_sell_info_use_case.dart'
    as usecase;
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_sell_info_use_case_test.mocks.dart';

@GenerateMocks([GetSwapInfoUseCase])
void main() {
  late usecase.GetSellInfoUseCase sellInfoUseCase;
  var mockRepo = MockGetSwapInfoUseCase();

  setUp(() {
    mockRepo = MockGetSwapInfoUseCase();
    sellInfoUseCase = usecase.GetSellInfoUseCase(mockRepo);
  });

  test('Should successfully fetch sell info details', () async {
    const targetSellToken = 'targetSellToken';
    const testAxInput = 1.13;
    const toPrice = 1.01;
    const fromPrice = 1.01;
    const minimumReceived = 0.21;
    const testReceivedAmount = 1.01;
    const testTotalFee = 4.01;

    const targetTokenSwapInfo = TokenSwapInfo(
      toPrice: toPrice,
      fromPrice: fromPrice,
      minimumReceived: minimumReceived,
      priceImpact: testReceivedAmount,
      receiveAmount: testReceivedAmount,
      totalFee: testTotalFee,
    );
    const testSuccessResponse = Success(targetTokenSwapInfo);
    when(
      mockRepo.fetchSwapInfo(
        tokenTo: captureAnyNamed('tokenTo'),
        tokenFrom: targetSellToken,
        fromInput: testAxInput,
      ),
    ).thenAnswer(
      (_) async => Future.value(Either.left(testSuccessResponse)),
    );

    final response = await sellInfoUseCase.fetchAptSellInfo(
      aptAddress: targetSellToken,
      aptInput: testAxInput,
    );
    await untilCalled(
      mockRepo.fetchSwapInfo(
        tokenFrom: anyNamed('tokenFrom'),
        tokenTo: anyNamed('tokenTo'),
        fromInput: anyNamed('fromInput'),
        slippage: anyNamed('slippage'),
      ),
    );
    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.sellInfo == targetTokenSwapInfo);
    expect(
      verify(
        mockRepo.fetchSwapInfo(
          tokenTo: captureAnyNamed('tokenTo'),
          tokenFrom: targetSellToken,
          fromInput: testAxInput,
        ),
      ).captured,
      [AXT.polygonAddress],
    );
  });
}
