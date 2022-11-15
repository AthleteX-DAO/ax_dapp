// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/models/sports_model/sports_model.dart';
import 'package:ax_dapp/scout/widgets/widget_factories/mlb_athlete_details_widget.dart';
import 'package:ax_dapp/scout/widgets/widget_factories/nfl_athlete_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

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
  Widget athletePageKeyStatisticsForMobile();
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
  Widget athletePageKeyStatisticsForMobile() {
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
