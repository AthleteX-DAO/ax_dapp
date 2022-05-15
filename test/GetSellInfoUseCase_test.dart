import 'package:ax_dapp/repositories/subgraph/usecases/GetSellInfoUseCase.dart' as UseCase;
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
  late UseCase.GetSellInfoUseCase sellInfoUseCase;
  var mockRepo = MockGetSwapInfoUseCase();

  setUp(() {
    mockRepo = MockGetSwapInfoUseCase();
    sellInfoUseCase = UseCase.GetSellInfoUseCase(mockRepo);
  });

  test("Should successfully fetch sell info details", () async {
    final targetSellToken = "targetSellToken";
    final testAxInput = 1.13;
    final toPrice = 1.01;
    final fromPrice = 1.01;
    final minimumReceived = 0.21;
    final testReceivedAmount = 1.01;
    final testTotalFee = 4.01;

    final targetTokenSwapInfo = TokenSwapInfo(
        toPrice: toPrice,
        fromPrice: fromPrice,
        minimumReceived: minimumReceived,
        priceImpact: testReceivedAmount,
        receiveAmount: testReceivedAmount,
        totalFee: testTotalFee);
    final Success testSuccessResponse = Success(targetTokenSwapInfo);
    when(mockRepo.fetchSwapInfo(
        tokenTo: captureAnyNamed('tokenTo'),
        tokenFrom: targetSellToken,
        fromInput: testAxInput,
        slippage: null))
        .thenAnswer(
            (_) async => Future.value(Either.left(testSuccessResponse)));

    final response = await sellInfoUseCase.fetchAptSellInfo(
        aptAddress: targetSellToken, aptInput: testAxInput);
    await untilCalled(mockRepo.fetchSwapInfo(tokenFrom: anyNamed('tokenFrom'),
        tokenTo: anyNamed('tokenTo'),
        fromInput: anyNamed('fromInput'),
        slippage: anyNamed('slippage')));
    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.sellInfo == targetTokenSwapInfo);
    expect(
        verify(mockRepo.fetchSwapInfo(
            tokenTo: captureAnyNamed('tokenTo'),
            tokenFrom: targetSellToken,
            fromInput: testAxInput,
            slippage: null))
            .captured,
        [AXT.polygonAddress]);
  });
}
