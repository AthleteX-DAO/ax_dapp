/*NEEDS TO BE UPDATED
import 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';
import 'package:ax_dapp/dialogs/buy/usecases/GetAPTBuyInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/usecases/GetMaxTokenInputUseCase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'BuyDialogBloc_test.mocks.dart';

@GenerateMocks(
    [GetAPTBuyInfoUseCase, GetTotalTokenBalanceUseCase, SwapController])
void main() {
  var mockRepoUseCase = MockGetAPTBuyInfoUseCase();
  var mockWalletController = MockGetTotalTokenBalanceUseCase();
  var mockSwapController = MockSwapController();
  var buyDialogBloc = BuyDialogBloc(
      repo: mockRepoUseCase,
      wallet: mockWalletController,
      swapController: mockSwapController);
  final testAptBuyInfo = AptBuyInfo(0.0234, 5);

  setUp(() {
    mockRepoUseCase = MockGetAPTBuyInfoUseCase();
    mockWalletController = MockGetTotalTokenBalanceUseCase();
    mockSwapController = MockSwapController();
    buyDialogBloc = BuyDialogBloc(
        repo: mockRepoUseCase,
        wallet: mockWalletController,
        swapController: mockSwapController);

    when(mockRepoUseCase.fetchAptBuyInfo(any))
        .thenAnswer((_) async => Either.left(Success(testAptBuyInfo)));
    when(mockSwapController.amount1).thenReturn(0.0.obs);
  });

  test("Should calculate slippage successfully ", () async {
    final inputAmount = 2.5;
    final result =
        buyDialogBloc.calculateTransactionInfo(testAptBuyInfo, inputAmount);
    print(result.receiveAmount!.toStringAsFixed(8));
    print(result.priceImpact!.toStringAsFixed(2));
    print(result.minimumReceived!.toStringAsFixed(8));
    print(result.price!.toStringAsFixed(6));
    print(result.totalFee!.toStringAsFixed(6));
    assert(result.receiveAmount!.toStringAsFixed(8) == "0.00777660");
    assert(result.priceImpact!.toStringAsFixed(2) == "55.44");
    assert(result.minimumReceived!.toStringAsFixed(8) == "0.00769883");
    assert(result.price!.toStringAsFixed(8) == "0.00468000");
    assert(result.totalFee!.toStringAsFixed(8) == "0.00750000");
  });

  test(
      "Should update state with new axInputAmount and transaction info, on max buy tap",
      () async {
    final testTokenAddress = "testTokenAddress";
    final targetMaxInput = 100.00;
    when(mockWalletController.getTotalAxBalance())
        .thenAnswer((_) async => targetMaxInput);
    buyDialogBloc.add(OnLoadDialog(currentTokenAddress: testTokenAddress));
    buyDialogBloc.add(OnMaxBuyTap());
    expectLater(
        buyDialogBloc.stream,
        emitsInOrder([
          isA<BuyDialogState>(),
          isA<BuyDialogState>(),
          isA<BuyDialogState>(),
          predicate<BuyDialogState>((state) =>
              state.balance == targetMaxInput &&
              state.status == Status.success &&
              state.receiveAmount == 0.022218857142857144 &&
              state.priceImpact == 99.75894846955019 &&
              state.minimumReceived == 0.02199666857142857 &&
              state.price == 0.00468 &&
              state.totalFee == 0.3 &&
              state.axInputAmount == targetMaxInput &&
              state.tokenAddress == testTokenAddress)
        ]));
  });
}*/