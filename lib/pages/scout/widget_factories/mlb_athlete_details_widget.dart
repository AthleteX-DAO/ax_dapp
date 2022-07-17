import 'package:ax_dapp/pages/scout/models/sports_model/mlb_athlete_scout_model.dart';
import 'package:ax_dapp/pages/scout/widget_factories/athlete_details_widget.dart';
import 'package:ax_dapp/util/abbreviation_mappings_helper.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class MLBAthleteDetailsWidget implements AthleteDetailsWidget {
  const MLBAthleteDetailsWidget(this.athlete);

  final MLBAthleteScoutModel athlete;

  @override
  Widget athletePageDetails() {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Details',
              style: textStyle(Colors.white, 24, false, false),
            ),
          ),
          Divider(thickness: 1, color: greyTextColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sport / League',
                style: textStyle(greyTextColor, 20, false, false),
              ),
              Text(
                athlete.sport.name,
                //toDo add map for the different league
                style: textStyle(greyTextColor, 20, false, false),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team',
                style: textStyle(greyTextColor, 20, false, false),
              ),
              Text(
                '''${retrieveTeamCityName(athlete.team)} ${retrieveTeamNickname(athlete.team)}''',
                style: textStyle(greyTextColor, 20, false, false),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Position',
                style: textStyle(greyTextColor, 20, false, false),
              ),
              Text(
                retrieveFullMLBAthletePosition(athlete.position),
                style: textStyle(greyTextColor, 20, false, false),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Season Start',
                style: textStyle(greyTextColor, 20, false, false),
              ),
              Text(
                'Mar 31, 2022',
                style: textStyle(greyTextColor, 20, false, false),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Season End',
                style: textStyle(greyTextColor, 20, false, false),
              ),
              Text(
                'Nov 2, 2022',
                style: textStyle(greyTextColor, 20, false, false),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget athletePageKeyStatistics() {
    return SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Key Statistics',
                style: textStyle(Colors.white, 24, false, false),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'AtBat',
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'HR',
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'wOBA',
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'SB',
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Err',
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'InPl',
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(thickness: 1, color: greyTextColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Season Stats',
                style: textStyle(greyTextColor, 20, false, false),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.atBats.toString(),
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.homeRuns.toString(),
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.weightedOnBasePercentage.toStringAsFixed(3),
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.stolenBases.toString(),
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.errors.toString(),
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.inningsPlayed.toString(),
                        style: textStyle(greyTextColor, 15, false, false),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget athleteDetailsCardsForWeb(
    dynamic team,
    double _width,
    double athNameBx,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icon
        SizedBox(
          width: 50,
          child: Icon(
            Icons.sports_baseball,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(
          width: athNameBx,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                athlete.name,
                style: textStyle(
                  Colors.white,
                  18,
                  false,
                  false,
                ),
              ),
              Text(
                retrieveFullMLBAthletePosition(athlete.position),
                style: textStyle(
                  Colors.grey[700]!,
                  10,
                  false,
                  false,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: _width * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                retrieveTeamCityName(athlete.team),
                style: textStyle(
                  Colors.white,
                  18,
                  false,
                  false,
                ),
              ),
              Text(
                retrieveTeamNickname(athlete.team),
                style: textStyle(
                  Colors.grey[700]!,
                  10,
                  false,
                  false,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget athleteDetailsCardsForMobile(
    bool team,
    double _width,
    double athNameBx,
  ) {
    return Row(
      children: [
        // Icon
        SizedBox(
          width: 50,
          child: Icon(
            Icons.sports_baseball,
            color: Colors.grey[700],
          ),
        ),
        // Athlete Name
        SizedBox(
          width: athNameBx,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                athlete.name,
                style: textStyle(
                  Colors.white,
                  18,
                  false,
                  false,
                ),
              ),
              Text(
                retrieveFullMLBAthletePosition(
                  athlete.position,
                ),
                style: textStyle(
                  Colors.grey[700]!,
                  10,
                  false,
                  false,
                ),
              )
            ],
          ),
        ),
        // Team
        if (team)
          SizedBox(
            width: _width * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  retrieveTeamCityName(athlete.team),
                  style: textStyle(
                    Colors.white,
                    18,
                    false,
                    false,
                  ),
                ),
                Text(
                  retrieveTeamNickname(athlete.team),
                  style: textStyle(
                    Colors.grey[700]!,
                    10,
                    false,
                    false,
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}
