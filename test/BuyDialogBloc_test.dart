

import 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';
import 'package:ax_dapp/dialogs/buy/usecases/GetAPTBuyInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'BuyDialogBloc_test.mocks.dart';

@GenerateMocks([GetAPTBuyInfoUseCase])
void main() {

  test("Should calculate slippage successfully ", () async{
      final mockUseCase = MockGetAPTBuyInfoUseCase();
      final buyDialog  = BuyDialogBloc(repo: mockUseCase);
      final aptBuyInfo = AptBuyInfo(0.0234, 5);
      final inputAmount = 0.01;
      final slippageTolerance = 0.01;

      final result = buyDialog.calculateTransactionInfo(aptBuyInfo, inputAmount, slippageTolerance);
      assert (result.receiveAmount!.toStringAsPrecision(8)== "0.0000467");
      assert (result.priceImpact!.toStringAsPrecision(8) == "0.00356");
      assert (result.minimumReceived!.toStringAsPrecision(8) ==  "0.034000");
  });
}