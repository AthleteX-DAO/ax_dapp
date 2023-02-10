import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

extension EthereumChainLocalizationX on EthereumChain {
  String get localizedName {
    switch (this) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        throw UnsupportedError('$this');
      case EthereumChain.polygonMainnet:
        return 'Polygonscan';
      case EthereumChain.goerliTestNet:
        return 'Goerli';
      case EthereumChain.sxMainnet:
        return 'SX';
      case EthereumChain.sxTestnet:
        return 'SX Testnet';
    }
  }
}
