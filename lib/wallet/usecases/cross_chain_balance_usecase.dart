import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class CrossChainBalanceUseCase {
  CrossChainBalanceUseCase({
    required this.walletAddress,
    required this.chain,
    required WalletRepository walletRepository,
  }) : _walletRepository = walletRepository;

  final String walletAddress;
  final EthereumChain chain;
  final WalletRepository _walletRepository;

  Future<String> usdcBalance(EthereumChain chain) async {
    var usdcBalance = '';
    switch (chain) {
      case EthereumChain.none:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
      case EthereumChain.unsupported:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
      case EthereumChain.polygonMainnet:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
      case EthereumChain.goerliTestNet:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
      case EthereumChain.sxMainnet:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
      case EthereumChain.sxTestnet:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
      case EthereumChain.optimism:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
      case EthereumChain.arbitriumOne:
        final balance =
            await _walletRepository.getTokenBalance(Token.usdc(chain).address);
        usdcBalance = '${balance ?? 0}';
        break;
    }
    return usdcBalance;
  }

  String gasTokenBalance(EthereumChain chain) {
    String gasBalance = '';
    switch (chain) {
      case EthereumChain.none:
        break;
      case EthereumChain.unsupported:
        break;
      case EthereumChain.polygonMainnet:
        break;
      case EthereumChain.goerliTestNet:
        break;
      case EthereumChain.sxMainnet:
        break;
      case EthereumChain.sxTestnet:
        break;
      case EthereumChain.optimism:
        break;
      case EthereumChain.arbitriumOne:
        break;
    }
    return gasBalance;
  }
}
