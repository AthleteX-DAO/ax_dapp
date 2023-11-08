import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class CrossChainBalanceUseCase {
  CrossChainBalanceUseCase({
    required WalletRepository walletRepository,
  }) : _walletRepository = walletRepository;

  final WalletRepository _walletRepository;

  Future<double> usdcBalance(EthereumChain chain) async {
    final balance = await _walletRepository.getTokenBalance(Token.usdc(chain).address);
    return balance ?? 0;
  }

  Future<double> getGasBalance(EthereumChain chain) async {
    var gasBalance = 0.00;
    switch (chain) {
      case EthereumChain.none:
        gasBalance = 0;
        break;
      case EthereumChain.unsupported:
        gasBalance = 0;
        break;
      case EthereumChain.polygonMainnet:
        final balance = await _walletRepository.getTokenBalance(
          Token.matic(chain).address,
        );
        gasBalance = balance ?? 0;
        break;
      case EthereumChain.goerliTestNet:
        final balance =
            await _walletRepository.getTokenBalance(Token.weth(chain).address);
        gasBalance = balance ?? 0;
        break;
      case EthereumChain.sxMainnet:
        final balance = await _walletRepository.getTokenBalance(
          Token.sx(chain).address,
        );
        gasBalance = balance ?? 0;
        break;
      case EthereumChain.sxTestnet:
        gasBalance = 0;
        break;
      case EthereumChain.optimism:
        final balance =
            await _walletRepository.getTokenBalance(Token.weth(chain).address);
        gasBalance = balance ?? 0;
        break;
      case EthereumChain.arbitriumOne:
        final balance =
            await _walletRepository.getTokenBalance(Token.weth(chain).address);
        gasBalance = balance ?? 0;
        break;
    }
    return gasBalance;
  }
}
