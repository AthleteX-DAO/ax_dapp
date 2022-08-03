import 'package:tokens_repository/tokens_repository.dart';

extension EthereumChainX on EthereumChain {
  Token computeScoutToken() {
    switch (this) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        return Token.empty;
      case EthereumChain.polygonMainnet:
      case EthereumChain.polygonTestnet:
        return Token.ax(this);
      case EthereumChain.sxMainnet:
      case EthereumChain.sxTestnet:
        return Token.sx(this);
    }
  }
}
