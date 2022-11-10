import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/widgets/widget_factories/athlete_details_widget.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/abbreviation_mappings_helper.dart';
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
              style: textStyle(
                Colors.white,
                24,
                isBold: false,
                isUline: false,
              ),
            ),
          ),
          Divider(thickness: 1, color: greyTextColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sport / League',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                athlete.sport.name,
                //toDo add map for the different league
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                '''${retrieveTeamCityName(athlete.team)} ${retrieveTeamNickname(athlete.team)}''',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Position',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                retrieveFullMLBAthletePosition(athlete.position),
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Season Start',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                'Mar 31, 2022',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Season End',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                'Nov 2, 2022',
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
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
                style: textStyle(
                  Colors.white,
                  24,
                  isBold: false,
                  isUline: false,
                ),
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
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'HR',
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'wOBA',
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'SB',
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Err',
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'InPl',
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
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
                style: textStyle(
                  greyTextColor,
                  20,
                  isBold: false,
                  isUline: false,
                ),
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
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.homeRuns.toString(),
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.weightedOnBasePercentage.toStringAsFixed(3),
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.stolenBases.toString(),
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.errors.toString(),
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        athlete.inningsPlayed.toString(),
                        style: textStyle(
                          greyTextColor,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
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
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                retrieveFullMLBAthletePosition(athlete.position),
                style: textStyle(
                  Colors.grey[700]!,
                  10,
                  isBold: false,
                  isUline: false,
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
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                retrieveTeamNickname(athlete.team),
                style: textStyle(
                  Colors.grey[700]!,
                  10,
                  isBold: false,
                  isUline: false,
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
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                retrieveFullMLBAthletePosition(
                  athlete.position,
                ),
                style: textStyle(
                  Colors.grey[700]!,
                  10,
                  isBold: false,
                  isUline: false,
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
                    isBold: false,
                    isUline: false,
                  ),
                ),
                Text(
                  retrieveTeamNickname(athlete.team),
                  style: textStyle(
                    Colors.grey[700]!,
                    10,
                    isBold: false,
                    isUline: false,
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}
