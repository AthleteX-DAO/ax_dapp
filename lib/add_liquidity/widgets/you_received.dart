import 'package:ax_dapp/add_liquidity/add_liquidity.dart';
import 'package:ax_dapp/add_liquidity/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YouReceived extends StatelessWidget {
  const YouReceived({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final amountToReceive =
        context.read<AddLiquidityBloc>().state.poolPairInfo.recieveAmount;
    final token0 = context.read<AddLiquidityBloc>().state.token0;
    final token1 = context.read<AddLiquidityBloc>().state.token0;
    return Column(
      children: [
        SizedBox(
          height: 25,
          child: Row(
            mainAxisAlignment:
                isWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'You will receive:',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 6),
                child: const YouReceiveToolTip(),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: isWeb
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Text(
                    amountToReceive,
                    style: const TextStyle(color: Colors.white, fontSize: 21),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${token0.ticker}/${token1.ticker}',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const Text(
                      'LP Tokens',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
