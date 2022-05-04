import 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';
import 'package:ax_dapp/dialogs/buy/usecases/GetAPTBuyInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'BuyDialogBloc_test.mocks.dart';

@GenerateMocks([GetAPTBuyInfoUseCase, WalletController, SwapController])
void main() {
  test("Should calculate slippage successfully ", () async {
    final mockUseCase = MockGetAPTBuyInfoUseCase();
    final mockWalletController = MockWalletController();
    final mockSwapController = MockSwapController();
    final buyDialog = BuyDialogBloc(
        repo: mockUseCase,
        walletController: mockWalletController,
        swapController: mockSwapController);
    final aptBuyInfo = AptBuyInfo(0.0234, 5);
    final inputAmount = 2.5;

    final result = buyDialog.calculateTransactionInfo(
        aptBuyInfo, inputAmount);
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
}
