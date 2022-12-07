import 'package:ax_dapp/add_liquidity/add_liquidity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoolShareDetails extends StatelessWidget {
  const PoolShareDetails({
    super.key,
    required double elementWdt,
  }) : _elementWdt = elementWdt;

  final double _elementWdt;

  @override
  Widget build(BuildContext context) {
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
                      'Share of pool:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      '${poolInfo.shareOfPool}%',
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
                      'Expected yield:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    Text(
                      poolInfo.apy,
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
                    'Share of pool:',
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
                    '${poolInfo.shareOfPool}%',
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
                    'Expected yield:',
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
                    poolInfo.apy,
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
