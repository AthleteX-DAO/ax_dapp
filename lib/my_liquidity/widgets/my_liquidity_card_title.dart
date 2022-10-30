import 'package:ax_dapp/my_liquidity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/my_liquidity/widgets/widgets.dart';
import 'package:ax_dapp/util/assets/token_image.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MyLiquidityCardTitle extends StatelessWidget {
  const MyLiquidityCardTitle({
    super.key,
    required this.token0,
    required this.token1,
    required this.liquidityPositionInfo,
  });

  final Token token0;
  final Token token1;
  final LiquidityPositionInfo liquidityPositionInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              scale: 0.5,
              image: tokenImage(token0),
            ),
          ),
        ),
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              scale: 0.5,
              image: tokenImage(token1),
            ),
          ),
        ),
        SportToken(
          sport: token0.sport,
          symbol: liquidityPositionInfo.token0Symbol,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(' - '),
        ),
        SportToken(
          sport: token1.sport,
          symbol: liquidityPositionInfo.token1Symbol,
        ),
      ],
    );
  }
}
