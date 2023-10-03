import 'package:ax_dapp/markets/markets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileAthleteContents extends StatelessWidget {
  const MobileAthleteContents({
    required this.athlete,
    required this.marketVsBookPriceIndex,
    required this.isLongToken,
    super.key,
  });

  final AthleteScoutModel athlete;
  final int marketVsBookPriceIndex;
  final bool isLongToken;

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
                'athlete',
                params: {'id': athlete.id.toString() + athlete.name},
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: AthleteDetailsWidget(
                    athlete,
                  ).athleteDetailsCardsForMobile(
                    _width > 290,
                    _width * 0.15,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: MobileMarketBookPrice(
                    marketVsBookPriceIndex: marketVsBookPriceIndex,
                    athlete: athlete,
                    isLongToken: isLongToken,
                  ),
                ),
                Expanded(
                  child: ScoutBuyButton(
                    athlete: athlete,
                    isLongToken: isLongToken,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
