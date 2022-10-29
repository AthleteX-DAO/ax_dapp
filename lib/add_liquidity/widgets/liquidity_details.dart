import 'package:ax_dapp/add_liquidity/bloc/add_liquidity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiquidityDetails extends StatelessWidget {
  const LiquidityDetails({
    super.key,
    required double elementWdt,
  }) : _elementWdt = elementWdt;

  final double _elementWdt;

  @override
  Widget build(BuildContext context) {
    final token0 = context.read<AddLiquidityBloc>().state.token0;
    final token1 = context.read<AddLiquidityBloc>().state.token1;
    final poolInfo = context.read<AddLiquidityBloc>().state.poolPairInfo;
    return SizedBox(
      width: _elementWdt,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: _elementWdt / 4,
            child: Text(
              '${token0.ticker} Liquidity:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: _elementWdt / 4,
            child: Text(
              poolInfo.reserve0,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: _elementWdt / 4,
            child: Text(
              '${token1.ticker} Liquidity:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: _elementWdt / 4,
            child: Text(
              poolInfo.reserve1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
