import 'package:ax_dapp/pages/DesktopScout.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/service/WarTimeSeries.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart' as series;

class AthletePage extends StatefulWidget {
  final Athlete athlete;
  const AthletePage({
    Key? key,
    required this.athlete,
  }) : super(key: key);

  @override
  _AthletePageState createState() => _AthletePageState(athlete);
}

class _AthletePageState extends State<AthletePage> {
  Athlete athlete;
  int listView = 0;
  _AthletePageState(this.athlete);

  @override
  Widget build(BuildContext context) {
    if (listView == 1) return DesktopScout();

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    // normal mode (dual) 
    if (_width > 1160 && _height > 660)
      return Container(
        width: _width,
        height: _height,
        child: Center(
          child: Container(
            width: _width*0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                graphSide(context),
                statsSide(context)
              ],
            )
          )
        )
      );

    // dual scroll mode
    if (_width > 1160 && _height < 660)
      return Container(
        height: _height*0.95-57,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: _width*0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      graphSide(context),
                      statsSide(context)
                    ],
                  )
                )
              )
            ],
          )
        )
      );

    // stacked scroll
    return Container(
      height: _height*0.95-57,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 625,
              child: graphSide(context),
            ),
            Container(
              height: 650,
              child: statsSide(context)
            )
          ],
        )
      )
    );
  }

  Widget graphSide(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double wid = _width*0.4;
    if (_width < 1160)
      wid = _width*0.95;

    return Container(
      height: 650,
      child: Column(
        children: <Widget>[
          // title
          Container(
            width: wid,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Back button
                Container(
                  width: 70,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        listView = 1;
                      });
                    },
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
                    athlete.name,
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
          // graph
          Container(
            width: wid,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: wid*.875,
                  height: _height * .4,
                  decoration: boxDecoration(Colors.transparent, 10, 1, Colors.grey[400]!),
                  child: Stack(
                    children: <Widget>[
                      // Graph
                      buildGraph(athlete.war, athlete.time, context),
                      // Price
                      Align(
                        alignment: Alignment(-.85, -.8),
                        child: Container(
                          height: 45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Book Value Chart",
                                style: textStyle(Colors.white, 9, false, false)
                              ),
                              Container(
                                width: 130,
                                height: 25,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      athlete.war[athlete.war.length -1].toStringAsFixed(4)+" AX",
                                      style: textStyle(Colors.white, 20, true, false)
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "+4%",
                                        style: textStyle(Colors.green, 12, false, false)
                                      )
                                    )
                                  ],
                                )
                              )
                            ],
                          )
                        )
                      ),
                    ],
                  )
                ),
                Container(
                  width: wid*.875,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: 175,
                            height: 50,
                            decoration: boxDecoration(Colors.amber[400]!, 100, 0, Colors.amber[400]!),
                            child: TextButton(
                              onPressed: () => showDialog(context: context, builder: (BuildContext context) => buyDialog(context, athlete)),
                              child: Text(
                                "Buy",
                                style: textStyle(Colors.black, 20, false, false)
                              )
                            )
                          ),
                          Container(
                            width: 175,
                            height: 50,
                            decoration: boxDecoration(Colors.white, 100, 0, Colors.white),
                            child: TextButton(
                              onPressed: () => showDialog(context: context, builder: (BuildContext context) => sellDialog(context, athlete)),
                              child: Text(
                                "Sell",
                                style: textStyle(Colors.black,20, false, false)
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
                            decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
                            child: TextButton(
                              onPressed: () => showDialog(context: context, builder: (BuildContext context) => mintDialog(context, athlete)),
                              child: Text(
                                "Mint",
                                style: textStyle(Colors.white, 20, false, false)
                              )
                            )
                          ),
                          Container(
                            width: 175,
                            height: 50,
                            decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
                            child: TextButton(
                              onPressed: () => showDialog(context: context, builder: (BuildContext context) => redeemDialog(context, athlete)),
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
        ],
      )
    );
  }

  Widget statsSide(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double wid = _width*0.4;
    if (_width < 1160)
      wid = _width*0.95;

    // Stats-Side
    return Container(
      width: wid,
      height: 550,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Price Overview section
          Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: wid*0.4375,
                      child: Text(
                        "Price Overview",
                        style: textStyle(Colors.white, 24, false, false)
                      )
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Current",
                              style: textStyle(Colors.grey[400]!, 14, false, false)
                            )
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "All-Time High",
                              style: textStyle(Colors.grey[400]!, 14, false, false)
                            )
                          )
                        ],
                      )
                    )
                  ]
                ),
                Divider(thickness: 1, color: Colors.grey[400]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Market Price",
                        style: textStyle(Colors.grey[400]!, 20, false, false)
                      )
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
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
                          ),
                          Text(
                            "4.20 AX",
                            style: textStyle(Colors.grey[400]!, 20, false, false)
                          )
                        ]
                      )
                    )
                  ]
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: _width * 0.175,
                      child: Text(
                        "Book Value",
                        style: textStyle(Colors.grey[400]!, 20, false, false)
                      )
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "4.24 AX ",
                                style: textStyle(Colors.white, 20, false, false)
                              ),
                              Container(
                                child: Text(
                                  "+4%",
                                  style: textStyle(Colors.green, 12, false, false)
                                )
                              ),
                            ]
                          ),
                          Text(
                            "4.24 AX",
                            style: textStyle(Colors.grey[400]!, 20, false, false)
                          )
                        ]
                      )
                    )
                  ]
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: _width * 0.175,
                      child: Text(
                        "MP/BV Ratio",
                        style: textStyle(Colors.grey[400]!, 20, false, false)
                      )
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "80%",
                                style: textStyle(Colors.grey[400]!, 20, false, false)
                              ),
                            ]
                          ),
                          Text(
                            "120%",
                            style: textStyle(Colors.grey[400]!, 20, false, false)
                          )
                        ]
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
                Divider(thickness: 1, color: Colors.grey[400]),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Key Statistics",
                          style: textStyle(Colors.white, 24, false, false)
                        ),
                      ),
                      Container(
                        width: 260,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "TD",
                                style: textStyle(Colors.grey[400]!, 14, false, false)
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Cmp",
                                style: textStyle(Colors.grey[400]!, 14, false, false)
                              ),
                            ),
                            Container(
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
                    ]
                  )
                ),
                Divider(thickness: 1, color: Colors.grey[400]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Current Stats",
                        style: textStyle(Colors.grey[400]!, 16, false, false)
                      ),
                    ),
                    Container(
                      width: 260,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "12",
                              style: textStyle(Colors.grey[400]!, 16, false, false)
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "24",
                              style: textStyle(Colors.grey[400]!, 16, false,false)
                            ),
                          ),
                          Container(
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
                      )
                    )
                  ]
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "View All Stats",
                    style: textStyle(Colors.amber[400]!, 16, false, true)
                  )
                ),
              ]
            )
          ),
        ]
      )
    );
  }

  Widget buildGraph(List war, List time, BuildContext context) {
    // local variables
    List<series.Series<dynamic, DateTime>> athleteData;
    DateTime curTime = DateTime(-1);
    DateTime lastHour = DateTime(-1);
    DateTime maxTime = DateTime(-1);
    List<WarTimeSeries> data = [];

    for (int i = 0; i < war.length; i++) {
      curTime = DateTime.parse(time[i]);
      // only new points
      if (lastHour.year == -1 ||
          (lastHour.isBefore(curTime) && curTime.hour != lastHour.hour)) {
        lastHour = curTime;
        // sets maximum if latest time
        if (maxTime == DateTime(-1) || maxTime.isBefore(curTime))
          maxTime = curTime;

        data.add(WarTimeSeries(curTime, war[i]));
      }
    }

    athleteData = [
      new charts.Series<WarTimeSeries, DateTime>(
        id: 'War',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (WarTimeSeries wts, _) => wts.time,
        measureFn: (WarTimeSeries wts, _) => wts.war,
        data: data,
      )
    ];

    return Container(
      child: charts.TimeSeriesChart(
        athleteData,
      ),
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold) if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}
