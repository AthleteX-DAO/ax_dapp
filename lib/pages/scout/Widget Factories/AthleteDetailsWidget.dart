import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/SportsModel/AthleteScoutModelExports.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:flutter/material.dart';

import 'AthleteDetailsWidgetExports.dart';

abstract class AthleteDetailsWidget {
  factory AthleteDetailsWidget(AthleteScoutModel athlete) {
    switch (athlete.sport) {
      case SupportedSport.MLB:
        return MLBAthleteDetailsWidget(athlete as MLBAthleteScoutModel);
      case SupportedSport.NFL:
        return NFLAthleteDetailsWidget(athlete as NFLAthleteScoutModel);
      default:
        return NoStatsShownWidget();
    }
  }

  Widget athletePageDetails();
  Widget athletePageKeyStatistics();
  Widget athleteDetailsCardsForWeb(team, _width, athNameBx);
  Widget athleteDetailsCardsForMobile(team, _width, athNameBx);
}

class NoStatsShownWidget implements AthleteDetailsWidget {
  @override
  Widget athletePageDetails() {
    return Center(
      child: Text('No details for selected athlete'),
    );
  }

  @override
  Widget athletePageKeyStatistics() {
    return Center(
      child: Text('No statistics shown for selected athlete'),
    );
  }

  @override
  Widget athleteDetailsCardsForWeb(team, _width, athNameBx){
    return Center(
      child: Text('No data shown for Athlete Card'),
    );
  }

  @override
  Widget athleteDetailsCardsForMobile(team, _width, athNameBx){
    return Center(
      child: Text('No data shown for Athlete Card'),
    );
  }
}
