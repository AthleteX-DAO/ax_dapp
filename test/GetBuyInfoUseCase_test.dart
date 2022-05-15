import 'package:ax_dapp/repositories/subgraph/usecases/GetBuyInfoUseCase.dart'
    as UseCase;
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
  late UseCase.GetBuyInfoUseCase buyInfoUseCase;
  var mockRepo = MockGetSwapInfoUseCase();

  setUp(() {
    mockRepo = MockGetSwapInfoUseCase();
    buyInfoUseCase = UseCase.GetBuyInfoUseCase(mockRepo);
  });

  test("Should successfully fetch buy info details", () async {
    final targetBuyToken = "targetBuyToken";
    final testAxInput = 1.13;
    final toPrice = 1.01;
    final fromPrice = 1.01;
    final testMinimumReceived = 0.21;
    final testPriceImpact = 12.01;
    final testReceivedAmount = 1.01;
    final testTotalFee = 4.01;

    final targetTokenSwapInfo = TokenSwapInfo(
        toPrice: toPrice,
        fromPrice: fromPrice,
        minimumReceived: testMinimumReceived,
        priceImpact: testPriceImpact,
        receiveAmount: testReceivedAmount,
        totalFee: testTotalFee);
    final Success testSuccessResponse = Success(targetTokenSwapInfo);
    when(mockRepo.fetchSwapInfo(
            tokenFrom: captureAnyNamed('tokenFrom'),
            tokenTo: targetBuyToken,
            fromInput: testAxInput,
            slippage: null))
        .thenAnswer(
            (_) async => Future.value(Either.left(testSuccessResponse)));

    final response = await buyInfoUseCase.fetchAptBuyInfo(
        aptAddress: targetBuyToken, axInput: testAxInput);

    assert(response.isLeft());
    assert(response.getLeft().toNullable()!.aptBuyInfo == targetTokenSwapInfo);
    expect(
        verify(mockRepo.fetchSwapInfo(
                tokenFrom: captureAnyNamed('tokenFrom'),
                tokenTo: targetBuyToken,
                fromInput: testAxInput,
                slippage: null))
            .captured,
        [AXT.polygonAddress]);
  });
}
