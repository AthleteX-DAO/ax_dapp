import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

class ExplorerUseCase {
  ExplorerUseCase({required this.walletAddress, required this.chain});

  final String walletAddress;
  final EthereumChain chain;

  String buttonMessage(EthereumChain chain) {
    var buttonName = '';
    switch (chain) {
      case EthereumChain.none:
        // TODO: Handle this case.
        break;
      case EthereumChain.unsupported:
        // TODO: Handle this case.
        break;
      case EthereumChain.polygonMainnet:
        buttonName = 'Show on Polygonscan';
        break;
      case EthereumChain.goerliTestNet:
        buttonName = 'Show on Goerli';
        break;
      case EthereumChain.sxMainnet:
        buttonName = 'Show on SX';
        break;
      case EthereumChain.sxTestnet:
        // TODO: Handle this case.
        break;
    }
    return buttonName;
  }

  String explorerUrl(EthereumChain chain) {
    var explorerUrl = '';
    switch (chain) {
      case EthereumChain.none:
        // TODO: Handle this case.
        break;
      case EthereumChain.unsupported:
        // TODO: Handle this case.
        break;
      case EthereumChain.polygonMainnet:
        explorerUrl = 'https://polygonscan.com/address/$walletAddress';
        break;
      case EthereumChain.goerliTestNet:
        explorerUrl = 'https://goerli.etherscan.io/address/$walletAddress';
        break;
      case EthereumChain.sxMainnet:
        explorerUrl = 'https://explorer.sx.technology/address/$walletAddress';
        break;
      case EthereumChain.sxTestnet:
        // TODO: Handle this case.
        break;
    }
    return explorerUrl;
  }
}
