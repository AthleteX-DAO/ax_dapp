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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Container(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${token0.ticker} Liquidity:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      poolInfo.reserve0,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${token1.ticker} Liquidity:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      poolInfo.reserve1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
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
                      fontFamily: 'OpenSans',
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
                      fontFamily: 'OpenSans',
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
                      fontFamily: 'OpenSans',
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
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
