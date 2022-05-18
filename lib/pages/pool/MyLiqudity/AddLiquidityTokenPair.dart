import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/TokenList.dart';

class AddLiquidityTokenPair {
  final Token token0;
  final Token token1;
  AddLiquidityTokenPair({
    required this.token0,
    required this.token1,
  });

  factory AddLiquidityTokenPair.fromTokenPairAddresses(
      String token0Address, String token1Address) {
    int tokenAIndex = TokenList.tokenList.indexWhere(
        (token) => token.address.value.toLowerCase() == token0Address);
    int tokenBIndex = TokenList.tokenList.indexWhere(
        (token) => token.address.value.toLowerCase() == token1Address);
    print(
        '[Console] - tokenA index: $tokenAIndex token0 address: $token0Address');
    print(
        '[Console] - tokenB index: $tokenBIndex token1 address: $token1Address');

    return AddLiquidityTokenPair(
        token0: TokenList.tokenList[tokenAIndex],
        token1: TokenList.tokenList[tokenBIndex]);
  }
}
