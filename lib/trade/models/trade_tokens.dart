import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';

class TradeTokens extends Equatable {
  const TradeTokens({
    required this.tokenFrom,
    required this.tokenTo,
  });

  final Token tokenFrom;
  final Token tokenTo;

  static const empty =
      TradeTokens(tokenFrom: Token.empty, tokenTo: Token.empty);

  @override
  List<Object?> get props => [tokenFrom, tokenTo];
}

extension EthereumChainX on EthereumChain {
  TradeTokens computeTradeTokens({required bool isBuyAX}) {
    final axt = Token.ax(this);
    final weth = Token.weth(this);
    var tokenFrom = axt;
    var tokenTo = weth;
    if (isBuyAX) {
      switch (this) {
        case EthereumChain.none:
        case EthereumChain.unsupported:
          return TradeTokens.empty;
        case EthereumChain.polygonMainnet:
        case EthereumChain.goerliTestNet:
          tokenFrom = Token.matic(this);
          tokenTo = axt;
          break;
        case EthereumChain.sxMainnet:
        case EthereumChain.sxTestnet:
          tokenFrom = Token.sx(this);
          tokenTo = axt;
          break;
        case EthereumChain.optimism:
          return TradeTokens.empty;
        case EthereumChain.arbitriumOne:
          return TradeTokens.empty;
      }
    }
    return TradeTokens(tokenFrom: tokenFrom, tokenTo: tokenTo);
  }
}
