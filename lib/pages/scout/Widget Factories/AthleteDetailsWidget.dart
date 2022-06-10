import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/SportsModel/MLBAthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/SportsModel/NFLAthleteScoutModel.dart';
import 'package:ax_dapp/util/AbbreviationMappingsHelper.dart';
import 'package:ax_dapp/util/AthletePageFormatHelper.dart';
import 'package:ax_dapp/util/Colors.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:flutter/material.dart';

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

  Widget athleteDetails();
  Widget keyStatistics();
}

class MLBAthleteDetailsWidget implements AthleteDetailsWidget {
  final MLBAthleteScoutModel _athlete;
  MLBAthleteDetailsWidget(this._athlete);
  @override
  Widget athleteDetails() {
    return Container(
        height: 250,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Details",
                      style: textStyle(Colors.white, 24, false, false))),
              Divider(thickness: 1, color: greyTextColor),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sport / League",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("${_athlete.sport.name}",
                        //toDo add map for the different league
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Team",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text(
                        "${retrieveTeamCityName(_athlete.team)} ${retrieveTeamNickname(_athlete.team)}",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Position",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text(retrieveFullMLBAthletePosition(_athlete.position),
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Season Start",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("Mar 31, 2022",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Season End",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("Nov 2, 2022",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
            ]));
  }

  @override
  Widget keyStatistics() {
    // TODO: implement keyStatistics
    return Container(
        height: 150,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
          Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Container(
                  child: Text("Key Statistics",
                      style: textStyle(Colors.white, 24, false, false)),
                ),
                Container(
                    width: 260,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("AtBat",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("HR",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("wOBA",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("SB",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Err",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("InPl",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                        ])),
              ])),
          Divider(thickness: 1, color: greyTextColor),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
              Widget>[
            Container(
              child: Text("Current season Stats",
                  style: textStyle(greyTextColor, 16, false, false)),
            ),
            Container(
                width: 260,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.atBats.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.homeRuns.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                            _athlete.weightedOnBasePercentage
                                .toStringAsFixed(3),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.stolenBases.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.errors.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.inningsPlayed.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                    ]))
          ]),
        ]));
  }
}

class NFLAthleteDetailsWidget implements AthleteDetailsWidget {
  final NFLAthleteScoutModel _athlete;
  NFLAthleteDetailsWidget(this._athlete);

  @override
  Widget athleteDetails() {
    return Container(
        height: 250,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Details",
                      style: textStyle(Colors.white, 24, false, false))),
              Divider(thickness: 1, color: greyTextColor),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sport / League",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("${_athlete.sport.name}",
                        //toDo add map for the different league
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Team",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text(
                        "${retrieveTeamCityName(_athlete.team)} ${retrieveTeamNickname(_athlete.team)}",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Position",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text(retrieveFullMLBAthletePosition(_athlete.position),
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Season Start",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("Mar 31, 2022",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Season End",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("Nov 2, 2022",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
            ]));
  }

  @override
  Widget keyStatistics() {
    // TODO: implement keyStatistics
    return Container(
        height: 150,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
          Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Container(
                  child: Text("Key Statistics",
                      style: textStyle(Colors.white, 24, false, false)),
                ),
                Container(
                    width: 260,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Passing Yards",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Passing Touchdowns",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Reception",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Receive Yards",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Receive Touch",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Rushing yards",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Offensive Snaps",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Defensive Snaps",
                                style:
                                    textStyle(greyTextColor, 10, false, false)),
                          ),
                        ])),
              ])),
          Divider(thickness: 1, color: greyTextColor),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
              Widget>[
            Container(
              child: Text("Current season Stats",
                  style: textStyle(greyTextColor, 16, false, false)),
            ),
            Container(
                width: 260,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.passingYards.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.passingTouchDowns.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.reception.toStringAsFixed(3),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.receiveYards.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.receiveTouch.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.rushingYards.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.offensiveSnapsPlayed.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.defensiveSnapsPlayed.toString(),
                            style: textStyle(greyTextColor, 10, false, false)),
                      ),
                    ]))
          ]),
        ]));
  }
}

class NoStatsShownWidget implements AthleteDetailsWidget {
  @override
  Widget athleteDetails() {
    return Center(
      child: Text('No details for selected athlete'),
    );
  }

  @override
  Widget keyStatistics() {
    return Center(
      child: Text('No statistics shown for selected athlete'),
    );
  }
}
