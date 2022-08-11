import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// This WalletController usecase encapsulates functions for returning
/// the total balance for AX or any other given token address
class GetTotalTokenBalanceUseCase {
  GetTotalTokenBalanceUseCase({
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository;

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;

  Future<double> getTotalAxBalance() async {
    final currentAxt = _tokensRepository.currentAxt;
    final axBalance =
        await _walletRepository.getTokenBalance(currentAxt.address);
    return axBalance ?? 0;
  }

  Future<double> getTotalBalanceForToken(String tokenAddress) async {
    final balance = await _walletRepository.getTokenBalance(tokenAddress);
    return balance ?? 0;
  }
}
