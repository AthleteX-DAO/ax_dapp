import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/service/token_list.dart';

class AddLiquidityTokenPair {
  AddLiquidityTokenPair({
    required this.token0,
    required this.token1,
  });

  factory AddLiquidityTokenPair.fromTokenPairAddresses(
    String token0Address,
    String token1Address,
  ) {
    final tokenAIndex = TokenList.tokenList.indexWhere(
      (token) => token.address.value.toLowerCase() == token0Address,
    );
    final tokenBIndex = TokenList.tokenList.indexWhere(
      (token) => token.address.value.toLowerCase() == token1Address,
    );
    return AddLiquidityTokenPair(
      token0: TokenList.tokenList[tokenAIndex],
      token1: TokenList.tokenList[tokenBIndex],
    );
  }

  final Token token0;
  final Token token1;
}
