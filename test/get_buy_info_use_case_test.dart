// ignore_for_file: prefer_asserts_with_message, prefer_const_constructors

import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart'
    as usecase;
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tokens_repository/tokens_repository.dart';

import 'get_buy_info_use_case_test.mocks.dart';

@GenerateMocks([GetSwapInfoUseCase, TokensRepository])
void main() {
  late usecase.GetBuyInfoUseCase buyInfoUseCase;
  var mockRepo = MockGetSwapInfoUseCase();
  late TokensRepository mockTokensRepository;

  setUp(() {
    mockTokensRepository = MockTokensRepository();
    mockRepo = MockGetSwapInfoUseCase();
    buyInfoUseCase = usecase.GetBuyInfoUseCase(
      tokensRepository: mockTokensRepository,
      repo: mockRepo,
    );
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
    final axt = Token.ax(EthereumChain.polygonMainnet);
    when(mockTokensRepository.currentAxt).thenReturn(axt);
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

    expect(response.isLeft(), isTrue);
    expect(response.getLeft().toNullable()!.aptBuyInfo, targetTokenSwapInfo);
    expect(
      verify(
        mockRepo.fetchSwapInfo(
          tokenFrom: captureAnyNamed('tokenFrom'),
          tokenTo: targetBuyToken,
          fromInput: testAxInput,
        ),
      ).captured,
      [axt.address],
    );
  });
}
