import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// Aggregates balances across primary chains while keeping UX chain-agnostic.
class UnifiedPortfolioUseCase {
  UnifiedPortfolioUseCase({required WalletRepository walletRepository})
      : _walletRepository = walletRepository;

  final WalletRepository _walletRepository;

  /// Total USDC on the user's current chain.
  Future<double> totalUsdcOnCurrentChain() async {
    final currentChain = _walletRepository.currentChain;
    return _safeTokenBalance(Token.usdc(currentChain));
  }

  /// Total USDC across primary chains.
  Future<double> totalUsdcAcrossPrimaryChains() async {
    final primaryChains = EthereumChain.mainnetChains;
    var total = 0.0;
    for (final chain in primaryChains) {
      final usdcToken = Token.usdc(chain);
      final balance = await _safeTokenBalance(usdcToken);
      total += balance;
    }
    return total;
  }

  Future<double> _safeTokenBalance(Token token) async {
    final b = await _walletRepository.getTokenBalance(token.address);
    return b ?? 0.0;
    
  }
}
