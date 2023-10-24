import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/widgets/widget_factories/sx_bet_sports_details_widgets.dart';
import 'package:flutter/material.dart';

abstract class SportsDetailsWidget {
  factory SportsDetailsWidget(
    BuildContext context,
    SportsMarketsModel sportsMarkets,
  ) {
    return SXBetSportsDetailsWidget(
      sportsMarketsModel: sportsMarkets,
      context: context,
    );
  }
  Widget sportsPageDetails();
  Widget sportsPageKeyStatistics();
  Widget sportsPageKeyStatisticsForMobile();
  Widget sportsDetailsCardsForWeb(
    bool team,
    double _width,
  );

  Widget sportsDetailsCardsForMobile(
    bool showIcon,
    double athNameBx,
  );
}

class NoSportsStatsShownWidget implements SportsDetailsWidget {
  Widget sportsPagedetails() {
    return const Center(
      child: Text('No Details for this sports market'),
    );
  }

  @override
  Widget sportsDetailsCardsForMobile(bool showIcon, double athNameBx) {
    return const Center(
      child: Text('No details for this sports market'),
    );
  }

  @override
  Widget sportsDetailsCardsForWeb(bool team, double _width) {
    return const Center(
      child: Text('No details for this sports market'),
    );
  }

  @override
  Widget sportsPageDetails() {
    return const Center(
      child: Text('No details for this sports market'),
    );
  }

  @override
  Widget sportsPageKeyStatistics() {
    return const Center(
      child: Text('No details for this sports market'),
    );
  }

  @override
  Widget sportsPageKeyStatisticsForMobile() {
    return const Center(
      child: Text('No details for this sports market'),
    );
  }
}
