import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';

class SportsPageWebView extends StatelessWidget {
  const SportsPageWebView({
    required this.sportsMarketsModel,
  });

  final SportsMarketsModel sportsMarketsModel;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    double _containerWdt, _containerHgt;

    return const SizedBox(
      child: Center(child: Text('')),
    );
  }
}
