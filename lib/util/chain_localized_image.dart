import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

extension EthereumChainLocalizationImageX on EthereumChain {
  String get localizedImage {
    switch (this) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        throw UnsupportedError('$this');
      case EthereumChain.polygonMainnet:
        return 'assets/images/Polygon_Small.png';
      case EthereumChain.goerliTestNet:
        return 'assets/images/geth.png';
      case EthereumChain.optimism:
      case EthereumChain.arbitriumOne:
      case EthereumChain.sxMainnet:
        return 'assets/images/SX_Small.png';
      case EthereumChain.sxTestnet:
        return 'assets/images/SX_Small.png';
    }
  }
}
