import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/widgets/widget_factories/sports_details_widget.dart';
import 'package:flutter/material.dart';

class SportsPageWebView extends StatelessWidget {
  const SportsPageWebView({
    super.key,
    required this.sportsMarketsModel,
  });

  final SportsMarketsModel sportsMarketsModel;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    double _containerHgt;

    _containerHgt = (_height * 0.90) - AppBar().preferredSize.height;
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height + 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          SizedBox(
            height: _containerHgt,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 50),
              child: SportsDetailsWidget(context, sportsMarketsModel)
                  .sportsPageDetails(),
            ),
          ),
        ],
      ),
    );
  }
}
