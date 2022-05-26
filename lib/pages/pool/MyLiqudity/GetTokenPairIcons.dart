import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/TokenList.dart';

class GetTokenPairIcons {
  final Token token0;
  final Token token1;
  GetTokenPairIcons({
    required this.token0,
    required this.token1,
  });

  factory GetTokenPairIcons.fromTokenTicker(
      String token0Ticker, String token1Ticker) {
    int tokenAIndex = TokenList.tokenList.indexWhere(
        (token) => token.ticker.toUpperCase() == token0Ticker);
    int tokenBIndex = TokenList.tokenList.indexWhere(
        (token) => token.ticker.toUpperCase() == token1Ticker);
    print(
        '[Console] - tokenA index: $tokenAIndex token0 address: $token0Ticker');
    print(
        '[Console] - tokenB index: $tokenBIndex token1 address: $token1Ticker');

    return GetTokenPairIcons(
        token0: TokenList.tokenList[tokenAIndex],
        token1: TokenList.tokenList[tokenBIndex]);
  }
}