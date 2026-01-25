import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// Aggregates balances across primary chains while keeping UX chain-agnostic.
class UnifiedPortfolioUseCase {
  UnifiedPortfolioUseCase({required WalletRepository walletRepository})
      : _walletRepository = walletRepository;

  final WalletRepository _walletRepository;

  /// Total USDC across Ethereum Mainnet and Polygon Mainnet.
  Future<double> totalUsdcAcrossPrimaryChains() async {
    final eth = await _safeTokenBalance(Token.usdc(EthereumChain.ethereumMainnet));
    final poly = await _safeTokenBalance(Token.usdc(EthereumChain.polygonMainnet));
    return eth + poly;
  }

  Future<double> _safeTokenBalance(Token token) async {
    final b = await _walletRepository.getTokenBalance(token.address);
    return b ?? 0.0;
    
  }
}
