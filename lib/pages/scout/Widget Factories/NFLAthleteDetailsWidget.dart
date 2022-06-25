import 'package:ax_dapp/pages/scout/Widget%20Factories/AthleteDetailsWidget.dart';
import 'package:ax_dapp/pages/scout/models/SportsModel/NFLAthleteScoutModel.dart';
import 'package:ax_dapp/util/AbbreviationMappingsHelper.dart';
import 'package:ax_dapp/util/AthletePageFormatHelper.dart';
import 'package:ax_dapp/util/Colors.dart';
import 'package:flutter/material.dart';

class NFLAthleteDetailsWidget implements AthleteDetailsWidget {
  final NFLAthleteScoutModel _athlete;
  NFLAthleteDetailsWidget(this._athlete);

  @override
  Widget athletePageDetails() {
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
                        "${retrieveNFLTeamCityName(_athlete.team)} ${retrieveNFLTeamNickName(_athlete.team)}",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Position",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text(retrieveFullNFLAthletePosition(_athlete.position),
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Season Start",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("Sep 8, 2022",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Season End",
                        style: textStyle(greyTextColor, 20, false, false)),
                    Text("Jan 8, 2023",
                        style: textStyle(greyTextColor, 20, false, false))
                  ]),
            ]));
  }

  @override
  Widget athletePageKeyStatistics() {
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
                    width: 300,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Yds",
                                style:
                                    textStyle(greyTextColor, 13, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Tds",
                                style:
                                    textStyle(greyTextColor, 13, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("Rec",
                                style:
                                    textStyle(greyTextColor, 13, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("RYd",
                                style:
                                    textStyle(greyTextColor, 13, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("RTch",
                                style:
                                    textStyle(greyTextColor, 13, false, false)),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("RuYd",
                                style:
                                    textStyle(greyTextColor, 13, false, false)),
                          ),
                        ])),
              ])),
          Divider(thickness: 1, color: greyTextColor),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
              Widget>[
            Container(
              child: Text("Current Season Stats",
                  style: textStyle(greyTextColor, 20, false, false)),
            ),
            Container(
                width: 300,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.passingYards.toString(),
                            style: textStyle(greyTextColor, 13, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.passingTouchDowns.toString(),
                            style: textStyle(greyTextColor, 13, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.reception.toString(),
                            style: textStyle(greyTextColor, 13, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.receiveYards.toString(),
                            style: textStyle(greyTextColor, 13, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.receiveTouch.toString(),
                            style: textStyle(greyTextColor, 13, false, false)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(_athlete.rushingYards.toString(),
                            style: textStyle(greyTextColor, 13, false, false)),
                      ),
                    ]))
          ]),
        ]));
  }
  @override
  Widget athleteDetailsCardsForWeb(team, _width, athNameBx){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Icon
          Container(
              width: 50,
              child: Icon(Icons.sports_football,
              color: Colors.grey[700])),
          Container(
          width: athNameBx,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_athlete.name,
                    style: textStyle(
                        Colors.white, 18, false, false)),
                Text(
                    retrieveFullNFLAthletePosition(_athlete.position),
                    style: textStyle(
                        Colors.grey[700]!, 10, false, false))
              ])),
          if(team)
            Container(
              width: _width * 0.12,
              child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(retrieveNFLTeamCityName(_athlete.team),
                        style: textStyle(
                            Colors.white, 18, false, false)),
                    Text(retrieveNFLTeamNickName(_athlete.team),
                        style: textStyle(
                            Colors.grey[700]!, 10, false, false))
                  ])),
        ],
      ),
    );
  }

  @override
  Widget athleteDetailsCardsForMobile(team, _width, athNameBx){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Icon
          Container(
              width: 50,
              child: Icon(Icons.sports_baseball,
                  color: Colors.grey[700])),
          // Athlete Name
          Container(
              width: athNameBx,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_athlete.name,
                        style: textStyle(
                            Colors.white, 18, false, false)),
                    Text(
                        "Test",
                        style: textStyle(
                            Colors.grey[700]!, 10, false, false))
                  ])),
          // Team
          if (team)
            Container(
                width: _width * 0.15,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("TeamName",
                          style: textStyle(
                              Colors.white, 18, false, false)),
                      Text("TeamNickName",
                          style: textStyle(
                              Colors.grey[700]!, 10, false, false))
                              ])),
        ],
      ),
    );
  }
}