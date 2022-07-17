// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/pages/scout/models/sports_model/athlete_scout_model_exports.dart';
import 'package:ax_dapp/pages/scout/widget_factories/athlete_details_widget_exports.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:flutter/material.dart';

abstract class AthleteDetailsWidget {
  factory AthleteDetailsWidget(AthleteScoutModel athlete) {
    switch (athlete.sport) {
      case SupportedSport.MLB:
        return MLBAthleteDetailsWidget(athlete as MLBAthleteScoutModel);
      case SupportedSport.NFL:
        return NFLAthleteDetailsWidget(athlete as NFLAthleteScoutModel);
      case SupportedSport.NBA:
      case SupportedSport.all:
        return NoStatsShownWidget();
    }
  }

  Widget athletePageDetails();
  Widget athletePageKeyStatistics();
  Widget athleteDetailsCardsForWeb(
    bool team,
    double _width,
    double athNameBx,
  );

  Widget athleteDetailsCardsForMobile(
    bool team,
    double _width,
    double athNameBx,
  );
}

class NoStatsShownWidget implements AthleteDetailsWidget {
  @override
  Widget athletePageDetails() {
    return const Center(
      child: Text('No details for selected athlete'),
    );
  }

  @override
  Widget athletePageKeyStatistics() {
    return const Center(
      child: Text('No statistics shown for selected athlete'),
    );
  }

  @override
  Widget athleteDetailsCardsForWeb(
    bool team,
    double? _width,
    double? athNameBx,
  ) {
    return const Center(
      child: Text('No data shown for Athlete Card'),
    );
  }

  @override
  Widget athleteDetailsCardsForMobile(
    bool team,
    double _width,
    double athNameBx,
  ) {
    return const Center(
      child: Text('No data shown for Athlete Card'),
    );
  }
}
