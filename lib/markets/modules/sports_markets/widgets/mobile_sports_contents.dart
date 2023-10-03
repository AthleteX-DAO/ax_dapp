import 'package:ax_dapp/markets/markets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileSportsContents extends StatelessWidget {
  const MobileSportsContents({
    required this.sportsMarketsModel,
  });

  final SportsMarketsModel sportsMarketsModel;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: 70,
          child: OutlinedButton(
            onPressed: () {
              context.goNamed(
                'sports-markets',
                params: {
                  'name': sportsMarketsModel.name,
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: SportsDetailsWidget(sportsMarketsModel)
                      .sportsDetailsCardsForMobile(_width > 290, _width * 0.15),
                ),
                Flexible(
                  flex: 2,
                  child: Text('${sportsMarketsModel.line}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}