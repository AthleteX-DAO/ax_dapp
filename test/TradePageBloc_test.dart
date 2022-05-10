import 'package:ax_dapp/pages/trade/bloc/TradePageBloc.dart';
import 'package:ax_dapp/repositories/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/SwapInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'TradePageBloc_test.mocks.dart';

@GenerateMocks([GetSwapInfoUseCase, WalletController, SwapController])
void main() {
  test("Should Calculate the Metrics Correctly on the Trade Page ", () async {
    final mockUseCase = MockGetSwapInfoUseCase();
    final mockWalletController = MockWalletController();
    final mockSwapController = MockSwapController();
    final tradePage = TradePageBloc(
        repo: mockUseCase,
        walletController: mockWalletController,
        swapController: mockSwapController);
    final swapInfo = SwapInfo(toReserve: 1, fromReserve: 7500, toPrice: 0.0001333333333333333333333333333333333);
    final double inputAmount = 1;

    final result = tradePage.calculateTransactionInfo(
        swapInfo, inputAmount);
    print(result.receiveAmount!.toStringAsFixed(17));
    print(result.priceImpact!.toStringAsFixed(2));    
    print(result.minimumReceived!.toStringAsFixed(8));
    print(result.totalFee!.toStringAsFixed(6));
    print(result.price!.toStringAsFixed(6));
    assert(result.receiveAmount!.toStringAsFixed(17) == "0.00013291566441101");
    assert(result.priceImpact!.toStringAsFixed(2) == "0.03");
    assert(result.minimumReceived!.toStringAsFixed(8) == "0.00013159");
    assert(result.totalFee!.toStringAsFixed(6) == "0.003000");
    assert(result.price!.toStringAsFixed(6) == "0.000133");
  });
}
