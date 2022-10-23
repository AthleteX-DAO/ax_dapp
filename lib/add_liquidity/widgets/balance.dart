import 'package:ax_dapp/add_liquidity/add_liquidity.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Balance extends StatelessWidget {
  const Balance({super.key, required this.tokenNumber});

  final int tokenNumber;

  @override
  Widget build(BuildContext context) {
    final balance0 = context.read<AddLiquidityBloc>().state.balance0;
    final balance1 = context.read<AddLiquidityBloc>().state.balance1;
    return Container(
      padding: const EdgeInsets.only(right: 10),
      alignment: Alignment.bottomRight,
      child: Text(
        tokenNumber == 1
            ? 'Balance: ${toDecimal(balance0, 6)}'
            : 'Balance: ${toDecimal(balance1, 6)}',
        style: TextStyle(color: Colors.grey[400], fontSize: 13),
      ),
    );
  }
}
