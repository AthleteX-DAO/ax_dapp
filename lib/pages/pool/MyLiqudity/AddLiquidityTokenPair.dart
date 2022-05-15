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
    int tokenAIndex = TokenList.tokenList
        .indexWhere((element) => element.address.value == token0Address);
    int tokenBIndex = TokenList.tokenList
        .indexWhere((element) => element.address.value == token1Address);

    print('[Console] - token0: ${TokenList.tokenList[tokenAIndex]}');
    print('[Console] - token1: ${TokenList.tokenList[tokenBIndex]}');

    return AddLiquidityTokenPair(
        token0: TokenList.tokenList[tokenAIndex],
        token1: TokenList.tokenList[tokenBIndex]);
  }
}
