import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

extension ChainLocalizedErrorX on EthereumChain {
  String get localizedError {
    switch (this) {
      case EthereumChain.none:
        return 'Please Switch to a chain to view Markets!';
      case EthereumChain.unsupported:
        return 'Please Switch to a chain to view Markets!';
      case EthereumChain.polygonMainnet:
        return 'Change to SX Network for SX Betting Markets';
      case EthereumChain.goerliTestNet:
      case EthereumChain.optimism:
      case EthereumChain.arbitriumOne:
      case EthereumChain.sxMainnet:
        return 'Change to Polygon Network for MLB Tokens';
      case EthereumChain.sxTestnet:
        return 'Change to Polygon Network for MLB Tokens';
    }
  }
}
