import 'package:ax_dapp/markets/markets.dart' hide ViewButton;
import 'package:ax_dapp/markets/modules/sports_markets/widgets/sports_view_button.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class DesktopSportsCard extends StatelessWidget {
  const DesktopSportsCard({required this.sportsMarketsModel, super.key});

  final SportsMarketsModel sportsMarketsModel;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Text('Sport'),
              ],
            ),
            Row(
              children: [
                // ScoutBuyButton(
                //   athlete: athlete,
                //   isLongToken: isLongToken,
                // ),
                if (_width >= 1090) ...[
                  const SizedBox(width: 25),
                  Container(
                    width: 100,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.transparent,
                      100,
                      2,
                      Colors.white,
                    ),
                    child: ViewButton(sports: sportsMarketsModel),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}