import 'package:ae_dapp/service/Dialog.dart';
import 'package:flutter/material.dart';

class NFLAthlete {
  final String name;
  final String team;
  final String position;
  final List passingYards;
  final List passingTouchDowns;
  final List reception;
  final List receiveYards;
  final List receiveTouch;
  final List rushingYards;
  final List war;
  final List time;

  const NFLAthlete({
    required this.name,
    required this.team,
    required this.position,
    required this.passingYards,
    required this.passingTouchDowns,
    required this.reception,
    required this.receiveYards,
    required this.receiveTouch,
    required this.rushingYards,
    required this.war,
    required this.time,
  });

  static NFLAthlete fromJson(json) =>
      NFLAthlete(
        name: json['name'],
        team: json['team'],
        position: json['position'],
        passingYards: json['passingYards'],
        passingTouchDowns: json['passingTouchdowns'],
        reception: json['reception'],
        receiveYards: json['receiveYards'],
        receiveTouch: json['receiveTouch'],
        rushingYards: json['rushingYards'],
        time: json['time'],
        war: json['price']
      );

  Widget buildPlayerPage(BuildContext context, int cardState) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Title
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width*0.95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Back button
                Container(
                  width: 70,
                  child: TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: Colors.white
                    )
                  )
                ),
                // APT Icon
                Container(
                  width: 30,
                ),
                // Player Name
                Container(
                  child: Text(
                    name,
                    style: textStyle(Colors.white, 28, false, false)
                  )
                ),
                // '|' Symbol
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "|",
                    style: textStyle(Colors.grey[600]!, 24, false, false)
                  )
                ),
                Container(
                  child: Text(
                    "Seasonal APT",
                    style: textStyle(Colors.grey[600]!, 24, false, false)
                  )
                ),
              ]
            )
          ),
          // Non-title
          Container(
            height: 600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Graph-Side
                Container(
                  width: MediaQuery.of(context).size.width*.4,
                  height: MediaQuery.of(context).size.height*.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // Graph goes here
                      Container(
                        width: MediaQuery.of(context).size.width*.350,
                        height: MediaQuery.of(context).size.height*.4,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.grey[400]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // child: buildGraph(athlete.war, athlete.time, context)
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*.35,
                        height: MediaQuery.of(context).size.width*.10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: 175,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.amber[400],
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextButton(
                                    onPressed: () => showDialog(context: context, builder: (BuildContext context) => Dialog()),
                                    child: Text(
                                      "Buy",
                                      style: textStyle(Colors.black, 20, false, false)
                                    )
                                  )
                                ),
                                Container(
                                  width: 175,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextButton(
                                    onPressed: () => showDialog(context: context, builder: (BuildContext context) => Dialog()),
                                    child: Text(
                                      "Sell",
                                      style: textStyle(Colors.black, 20, false, false)
                                    )
                                  )
                                )
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: 175,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextButton(
                                    onPressed: () => showDialog(context: context, builder: (BuildContext context) => Dialog()),
                                    child: Text(
                                      "Mint",
                                      style: textStyle(Colors.white, 20, false, false)
                                    )
                                  )
                                ),
                                Container(
                                  width: 175,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextButton(
                                    onPressed: () => showDialog(context: context, builder: (BuildContext context) => redeemDialog(context, this)),
                                    child: Text(
                                      "Redeem",
                                      style: textStyle(Colors.white, 20, false, false)
                                    )
                                  )
                                )
                              ]
                            ),
                          ]
                        )
                      )
                    ]
                  )
                ),
                // Stats-Side
                Container(
                  width: MediaQuery.of(context).size.width*.4,
                  height: MediaQuery.of(context).size.height*.75,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Price Overview section
                      Container(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width*0.175,
                                  child: Text(
                                    "Price Overview",
                                    style: textStyle(Colors.white, 24, false, false)
                                  )
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.1,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Current",
                                    style: textStyle(Colors.grey[400]!, 14, false, false)
                                  )
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  width: MediaQuery.of(context).size.width*0.075,
                                  child: Text(
                                    "All-Time High",
                                    style: textStyle(Colors.grey[400]!, 14, false, false)
                                  )
                                )
                              ]
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey[400]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width*0.175,
                                  child: Text(
                                    "Market Price",
                                    style: textStyle(Colors.grey[400]!, 20, false, false)
                                  )
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "4.18 AX ",
                                        style: textStyle(Colors.white, 20, false, false)
                                      ),
                                      Container(
                                        //alignment: Alignment.topLeft,
                                        child: Text(
                                          "-2%",
                                          style: textStyle(Colors.red, 12, false, false)
                                        )
                                      ),
                                    ]
                                  )
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: MediaQuery.of(context).size.width*0.075,
                                  child: Text(
                                    "4.20",
                                    style: textStyle(Colors.grey[400]!, 20, false, false)
                                  )
                                )
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width*0.175,
                                  child: Text(
                                    "Book Value",
                                    style: textStyle(Colors.grey[400]!, 20, false, false)
                                  )
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "4.24 AX ",
                                        style: textStyle(Colors.white, 20, false, false)
                                      ),
                                      Container(
                                        //alignment: Alignment.topLeft,
                                        child: Text(
                                          "+4%",
                                          style: textStyle(Colors.green, 12, false, false)
                                        )
                                      ),
                                    ]
                                  )
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: MediaQuery.of(context).size.width*0.075,
                                  child: Text(
                                    "4.24",
                                    style: textStyle(Colors.grey[400]!, 20, false, false)
                                  )
                                )
                              ]
                            ),
                          ]
                        )
                      ),
                      // Detail Section
                      Container(
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Details",
                                style: textStyle(Colors.white, 24, false, false)
                              )
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey[400]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Sport / League",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                ),
                                Text(
                                  "American Football / NFL",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                )
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Team",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                ),
                                Text(
                                  "Tampa Bay Buckaneers",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                )
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Position",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                ),
                                Text(
                                  "Quarterback",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                )
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Season Start",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                ),
                                Text(
                                  "Sep 1, 2021",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                )
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Season End",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                ),
                                Text(
                                  "Jan 10, 2022",
                                  style: textStyle(Colors.grey[400]!, 20, false, false)
                                )
                              ]
                            ),
                          ]
                        )
                      ),
                      // Stats section
                      Container(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 275,
                                    child: Text(
                                      "Key Statistics",
                                      style: textStyle(Colors.white, 24, false, false)
                                    ),
                                  ),
                                  Container(
                                    width: 75,
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "TD",
                                      style: textStyle(Colors.grey[400]!, 14, false, false)
                                    ),
                                  ),
                                  Container(
                                    width: 75,
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Cmp",
                                      style: textStyle(Colors.grey[400]!, 14, false, false)
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Cmp %",
                                      style: textStyle(Colors.grey[400]!, 14, false, false)
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "YDS",
                                      style: textStyle(Colors.grey[400]!, 14, false, false)
                                    ),
                                  ),
                                ]
                              )
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey[400]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 275,
                                  child: Text(
                                    "Current Stats",
                                    style: textStyle(Colors.grey[400]!, 16, false, false)
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "12",
                                    style: textStyle(Colors.grey[400]!, 16, false, false)
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "24",
                                    style: textStyle(Colors.grey[400]!, 16, false, false)
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "80%",
                                    style: textStyle(Colors.grey[400]!, 16, false, false)
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "2,000",
                                    style: textStyle(Colors.grey[400]!, 16, false, false)
                                  ),
                                ),
                              ]
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "View All Stats",
                                style: textStyle(Colors.amber[400]!, 16, false, true)
                              )
                            )
                          ]
                        )
                      ),
                    ]
                  )
                )
              ]
            ),
          )
        ]
      )
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold)
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
        );
    else
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
        );
  }

  BoxDecoration boxDecoration(Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(
        color: borCol,
        width: borWid
      )
    );
  }
}
