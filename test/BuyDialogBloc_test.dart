import 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetBuyInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPairInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/usecases/GetMaxTokenInputUseCase.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'BuyDialogBloc_test.mocks.dart';

 @GenerateMocks(
    [GetBuyInfoUseCase, GetTotalTokenBalanceUseCase, SwapController])
void main() {
  var mockRepoUseCase = MockGetBuyInfoUseCase();
  var mockWalletController = MockGetTotalTokenBalanceUseCase();
  var mockSwapController = MockSwapController();

  late BuyDialogBloc buyDialogBloc;

  setUp(() {
    mockRepoUseCase = MockGetBuyInfoUseCase();
    mockWalletController = MockGetTotalTokenBalanceUseCase();
    mockSwapController = MockSwapController();

    buyDialogBloc = BuyDialogBloc(
        repo: mockRepoUseCase,
        wallet: mockWalletController,
        swapController: mockSwapController);
  });

  test("Should successfully update Bloc State up on New AX input Event", () async {
    final double testAxInput = 30.00;
    final double testWalletBalance = 100.00;
    final testSwapInfo = TokenSwapInfo(
        toPrice: 1.09,
        fromPrice: 3.90,
        minimumReceived: 1.34,
        priceImpact: 42.5,
        totalFee: 0.54,
        receiveAmount: 0.54,
    );
    when(mockWalletController.getTotalAxBalance())
        .thenAnswer((_) => Future.value(testWalletBalance));
    when(mockRepoUseCase.fetchAptBuyInfo(
            aptAddress: captureThat(isEmpty, named: 'aptAddress'),
            axInput: captureThat(same(testAxInput), named: 'axInput')))
        .thenAnswer((_) => Future.value(Either.left(Success(testSwapInfo))));

    when(mockSwapController.updateFromAmount(testAxInput)).thenReturn(null);
    when(mockSwapController.amount1).thenReturn(0.0.obs);

    buyDialogBloc.add(OnNewAxInput(axInputAmount: testAxInput));

    await untilCalled(
        mockRepoUseCase.fetchAptBuyInfo(
            aptAddress: anyNamed('aptAddress'),
            axInput: anyNamed('axInput'))
    );

    final verificationResult = verify(mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: captureAnyNamed('aptAddress'),
        axInput: captureAnyNamed('axInput')));

    verificationResult.called(1);
    expect(verificationResult.captured, ['', testAxInput]);

    expectLater(
        buyDialogBloc.stream,
        emitsInOrder([
          predicate<BuyDialogState>((state) =>
              state.axInputAmount == state.axInputAmount &&
              state.balance == state.balance &&
              state.status == BlocStatus.success &&
              state.aptBuyInfo ==
                  AptBuyInfo(
                      aptPrice: testSwapInfo.toPrice,
                      minimumReceived: testSwapInfo.minimumReceived,
                      priceImpact: testSwapInfo.priceImpact,
                      receiveAmount: testSwapInfo.receiveAmount,
                      totalFee: testSwapInfo.totalFee) &&
              state.tokenAddress.isEmpty)
        ]));
  });

  test("Should successfully update Bloc State up on Load Dialog Event", () async {
    final testTokenAddress = "testTokenAddress";
    final double testWalletBalance = 100.00;
    final testSwapInfo = TokenSwapInfo(
      toPrice: 1.09,
      fromPrice: 3.90,
      minimumReceived: 1.34,
      priceImpact: 42.5,
      totalFee: 0.54,
      receiveAmount: 0.54,
    );
    when(mockWalletController.getTotalAxBalance())
        .thenAnswer((_) => Future.value(testWalletBalance));
    when(mockRepoUseCase.fetchAptBuyInfo(
            aptAddress: captureAnyNamed('aptAddress')))
        .thenAnswer((_) => Future.value(Either.left(Success(testSwapInfo))));

    buyDialogBloc.add(OnLoadDialog(currentTokenAddress: testTokenAddress));

    await untilCalled(mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: anyNamed('aptAddress'),
        axInput: anyNamed('axInput')));

    final verificationResult = verify(mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: captureAnyNamed('aptAddress')));

    verificationResult.called(1);
    expect(verificationResult.captured, [testTokenAddress]);

    expectLater(
        buyDialogBloc.stream,
        emitsInOrder([
          predicate<BuyDialogState>((state) =>
              state.axInputAmount == state.axInputAmount &&
              state.balance == testWalletBalance &&
              state.status == BlocStatus.success &&
              state.aptBuyInfo ==
                  AptBuyInfo(
                      aptPrice: testSwapInfo.toPrice,
                      minimumReceived: testSwapInfo.minimumReceived,
                      priceImpact: testSwapInfo.priceImpact,
                      receiveAmount: testSwapInfo.receiveAmount,
                      totalFee: testSwapInfo.totalFee) &&
              state.tokenAddress == testTokenAddress)
        ]));
  });
}