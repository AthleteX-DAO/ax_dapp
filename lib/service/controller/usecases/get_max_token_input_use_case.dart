import 'dart:developer';

import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:tokens_repository/tokens_repository.dart';

/// This WalletController usecase encapsulates functions for returning
/// the total balance for AX or any other given token address
class GetTotalTokenBalanceUseCase {
  GetTotalTokenBalanceUseCase({
    required TokensRepository tokensRepository,
    required this.walletController,
  }) : _tokensRepository = tokensRepository;

  final TokensRepository _tokensRepository;
  final WalletController walletController;

  Future<double> getTotalAxBalance() async {
    final chainToken = _tokensRepository.chainToken;
    await walletController.getYourAxBalance(chainToken.address);
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
