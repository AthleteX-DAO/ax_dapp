import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

extension EthereumChainLocalizationX on EthereumChain {
  String get localizedName {
    switch (this) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        throw UnsupportedError('$this');
      case EthereumChain.polygonMainnet:
        return 'Matic Network';
      case EthereumChain.optimism:
        return 'Optimism';
      case EthereumChain.arbitriumOne:
        return 'Arbitrium One';
      case EthereumChain.goerliTestNet:
        return 'Goerli Test Network';
      case EthereumChain.sxMainnet:
        return 'SX Network';
      case EthereumChain.sxTestnet:
        return 'SX Test Network';
      case EthereumChain.ethereumMainnet:
        return 'Ethereum';
      case EthereumChain.ethereumSepolia:
        return 'Sepolia Testnet';
      case EthereumChain.baseSepolia:
        return 'Base Sepolia Testnet';
    }
  }
}
