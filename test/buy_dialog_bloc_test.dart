import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/apt_buy_info.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'buy_dialog_bloc_test.mocks.dart';

@GenerateMocks([GetBuyInfoUseCase, GetTotalTokenBalanceUseCase, SwapController])
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
      swapController: mockSwapController,
    );
  });

  test('Should successfully update Bloc State up on New AX input Event',
      () async {
    const testAxInput = 30.0;
    const testWalletBalance = 100.0;
    const testSwapInfo = TokenSwapInfo(
      toPrice: 1.09,
      fromPrice: 3.90,
      minimumReceived: 1.34,
      priceImpact: 42.5,
      totalFee: 0.54,
      receiveAmount: 0.54,
    );
    when(mockWalletController.getTotalAxBalance())
        .thenAnswer((_) => Future.value(testWalletBalance));
    when(
      mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: captureThat(isEmpty, named: 'aptAddress'),
        axInput: captureThat(same(testAxInput), named: 'axInput'),
      ),
    ).thenAnswer((_) => Future.value(Either.left(Success(testSwapInfo))));

    when(mockSwapController.updateFromAmount(testAxInput)).thenReturn(null);
    when(mockSwapController.amount1).thenReturn(0.0.obs);

    buyDialogBloc.add(OnNewAxInput(axInputAmount: testAxInput));

    await untilCalled(
      mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: anyNamed('aptAddress'),
        axInput: anyNamed('axInput'),
      ),
    );

    final verificationResult = verify(
      mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: captureAnyNamed('aptAddress'),
        axInput: captureAnyNamed('axInput'),
      ),
    )..called(1);

    expect(verificationResult.captured, ['', testAxInput]);

    await expectLater(
      buyDialogBloc.stream,
      emitsInOrder([
        predicate<BuyDialogState>(
          (state) =>
              state.axInputAmount == state.axInputAmount &&
              state.balance == state.balance &&
              state.status == BlocStatus.success &&
              state.aptBuyInfo ==
                  AptBuyInfo(
                    axPerAptPrice: testSwapInfo.fromPrice,
                    minimumReceived: testSwapInfo.minimumReceived,
                    priceImpact: testSwapInfo.priceImpact,
                    receiveAmount: testSwapInfo.receiveAmount,
                    totalFee: testSwapInfo.totalFee,
                  ) &&
              state.tokenAddress.isEmpty,
        )
      ]),
    );
  });

  test('Should successfully update Bloc State up on Load Dialog Event',
      () async {
    const testTokenAddress = 'testTokenAddress';
    const testWalletBalance = 100.0;
    const testSwapInfo = TokenSwapInfo(
      toPrice: 1.09,
      fromPrice: 3.90,
      minimumReceived: 1.34,
      priceImpact: 42.5,
      totalFee: 0.54,
      receiveAmount: 0.54,
    );
    when(mockWalletController.getTotalAxBalance())
        .thenAnswer((_) => Future.value(testWalletBalance));
    when(
      mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: captureAnyNamed('aptAddress'),
      ),
    ).thenAnswer((_) => Future.value(Either.left(Success(testSwapInfo))));

    buyDialogBloc.add(OnLoadDialog(currentTokenAddress: testTokenAddress));

    await untilCalled(
      mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: anyNamed('aptAddress'),
        axInput: anyNamed('axInput'),
      ),
    );

    final verificationResult = verify(
      mockRepoUseCase.fetchAptBuyInfo(
        aptAddress: captureAnyNamed('aptAddress'),
      ),
    )..called(1);

    expect(verificationResult.captured, [testTokenAddress]);

    await expectLater(
      buyDialogBloc.stream,
      emitsInOrder([
        predicate<BuyDialogState>(
          (state) =>
              state.axInputAmount == state.axInputAmount &&
              state.balance == testWalletBalance &&
              state.status == BlocStatus.success &&
              state.aptBuyInfo ==
                  AptBuyInfo(
                    axPerAptPrice: testSwapInfo.fromPrice,
                    minimumReceived: testSwapInfo.minimumReceived,
                    priceImpact: testSwapInfo.priceImpact,
                    receiveAmount: testSwapInfo.receiveAmount,
                    totalFee: testSwapInfo.totalFee,
                  ) &&
              state.tokenAddress == testTokenAddress,
        )
      ]),
    );
  });
}
