import 'dart:developer';

import 'package:ax_dapp/service/controller/wallet_controller.dart';

/// This WalletController usecase encapsulates functions for returning
/// the total balance for AX or any other given token address
class GetTotalTokenBalanceUseCase {
  GetTotalTokenBalanceUseCase(this.walletController);

  final WalletController walletController;

  Future<double> getTotalAxBalance() async {
    await walletController.getYourAxBalance();
    final maxInput = double.parse(walletController.yourBalance.value);
    log('Max Possible Ax Input: $maxInput');
    return maxInput;
  }

  Future<double> getTotalBalanceForToken(String tokenAddress) async {
    final maxInput = await walletController.getTokenBalance(tokenAddress);
    await walletController.getTokenSymbol(tokenAddress).then(
          (tokenSymbol) => log('Max Input Value for $tokenSymbol: $maxInput'),
        );
    return double.parse(maxInput);
  }
}
