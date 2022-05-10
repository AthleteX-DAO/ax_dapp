import 'package:ax_dapp/service/Controller/WalletController.dart';

/// This WalletController usecase encapsulates functions for returning
/// the total balance for AX or any other given token address
class GetTotalTokenBalanceUseCase {
  final WalletController walletController;

  GetTotalTokenBalanceUseCase(this.walletController);

  Future<double> getTotalAxBalance() async {
    await walletController.getYourAxBalance();
    final maxInput = double.parse(walletController.yourBalance.value);
    print("Max Possible Ax Input: $maxInput");
    return maxInput;
  }

  Future<double> getTotalBalanceForToken(tokenAddress) async {
    final maxInput = await walletController.getTokenBalance(tokenAddress);
    walletController.getTokenSymbol(tokenAddress).then(
        (tokenSymbol) => print("Max Input Value for $tokenSymbol: $maxInput"));
    return double.parse(maxInput);
  }
}
