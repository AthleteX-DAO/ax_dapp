import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

class ExplorerUseCase {
  ExplorerUseCase({required this.walletAddress, required this.chain});

  final String walletAddress;
  final EthereumChain chain;

  String buttonMessage(EthereumChain chain) {
    var buttonName = '';
    switch (chain) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
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
        break;
      case EthereumChain.optimism:
        buttonName = 'Show on Optimism';
        break;
      case EthereumChain.arbitriumOne:
        buttonName = 'Show on Arbitrum';
        break;
      case EthereumChain.ethereumMainnet:
        buttonName = 'Show on Etherscan';
        break;
      case EthereumChain.ethereumSepolia:
        buttonName = 'Show on Sepolia';
        break;
      case EthereumChain.baseSepolia:
        buttonName = 'Show on Base Sepolia';
        break;
    }
    return buttonName;
  }

  String explorerUrl(EthereumChain chain) {
    var explorerUrl = '';
    switch (chain) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
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
        break;
      case EthereumChain.optimism:
        explorerUrl = 'https://optimistic.etherscan.io/address/$walletAddress';
        break;
      case EthereumChain.arbitriumOne:
        explorerUrl = 'https://arbiscan.io/address/$walletAddress';
        break;
      case EthereumChain.ethereumMainnet:
        explorerUrl = 'https://etherscan.io/address/$walletAddress';
        break;
      case EthereumChain.ethereumSepolia:
        explorerUrl = 'https://sepolia.etherscan.io/address/$walletAddress';
        break;
      case EthereumChain.baseSepolia:
        explorerUrl = 'https://sepolia.basescan.org/address/$walletAddress';
        break;
    }
    return explorerUrl;
  }
}
