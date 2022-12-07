import 'package:ax_dapp/my_liquidity/bloc/my_liquidity_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLiquiditySearchBar extends StatelessWidget {
  const MyLiquiditySearchBar({
    super.key,
    required double layoutHgt,
    required bool isWeb,
    required double layoutWdt,
  })  : _layoutHgt = layoutHgt,
        _isWeb = isWeb,
        _layoutWdt = layoutWdt;

  final double _layoutHgt;
  final bool _isWeb;
  final double _layoutWdt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: _layoutHgt * 0.01),
      //1 - title width
      width: _isWeb ? 300 : _layoutWdt * 0.6,
      //same as title
      height: _isWeb ? 40 : _layoutHgt * 0.05,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        children: [
          Container(width: 8),
          const Icon(Icons.search, color: Colors.white),
          Container(width: 10),
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                context
                    .read<MyLiquidityBloc>()
                    .add(SearchTermChanged(searchTerm: value));
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 8.5),
                hintText: 'Search a pair',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
