import 'package:ax_dapp/pages/AthletePage.dart';
// import 'package:ax_dapp/pages/testPage.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/material.dart';

class DesktopScout extends StatefulWidget {
  const DesktopScout({
    Key? key,
  }) : super(key: key);

  @override
  _DesktopScoutState createState() => _DesktopScoutState();
}

class _DesktopScoutState extends State<DesktopScout> {
  bool athletePage = false;
  int sportState = 0;
  List<Athlete> nflList = [];
  Athlete curAthlete = Athlete(
      name: "",
      team: "",
      position: "",
      passingYards: [],
      passingTouchDowns: [],
      reception: [],
      receiveYards: [],
      receiveTouch: [],
      rushingYards: [],
      war: [],
      time: []);

  @override
  Widget build(BuildContext context) {
    double sportFilterTxSz = 18;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    if (athletePage) return AthletePage(athlete: curAthlete);

    return Container(
        // Do not delete any of the changes here yet
        height: _height * 0.85 + 41,
        //height: _height*0.85-41,
        width: _width * 0.85,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Container(height: 15),
              // APT Title & Sport Filter
              Container(
                width: 400,
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("APT List",
                          style: textStyle(Colors.white, 18, false, false)),
                      Text("|",
                          style: textStyle(Colors.white, 18, false, false)),
                      Container(
                          child: TextButton(
                        onPressed: () {
                          if (sportState != 0)
                            setState(() {
                              sportState = 0;
                            });
                        },
                        child: Text("ALL",
                            style: textSwapState(
                                sportState == 0,
                                textStyle(Colors.white, sportFilterTxSz, false,
                                    false),
                                textStyle(Colors.amber[400]!, sportFilterTxSz,
                                    false, true))),
                      )),
                      Container(
                          child: TextButton(
                        onPressed: () {
                          if (sportState != 1)
                            setState(() {
                              sportState = 1;
                            });
                        },
                        child: Text("NFL",
                            style: textSwapState(
                                sportState == 1,
                                textStyle(Colors.white, sportFilterTxSz, false,
                                    false),
                                textStyle(Colors.amber[400]!, sportFilterTxSz,
                                    false, true))),
                      )),
                      Container(
                          child: TextButton(
                        onPressed: () {
                          if (sportState != 2)
                            setState(() {
                              sportState = 2;
                            });
                        },
                        child: Text("NBA",
                            style: textSwapState(
                                sportState == 2,
                                textStyle(Colors.white, sportFilterTxSz, false,
                                    false),
                                textStyle(Colors.amber[400]!, sportFilterTxSz,
                                    false, true))),
                      )),
                      Container(
                          child: TextButton(
                        onPressed: () {
                          if (sportState != 3)
                            setState(() {
                              sportState = 3;
                            });
                        },
                        child: Text("MMA",
                            style: textSwapState(
                                sportState == 3,
                                textStyle(Colors.white, sportFilterTxSz, false,
                                    false),
                                textStyle(Colors.amber[400]!, sportFilterTxSz,
                                    false, true))),
                      )),
                    ]),
              ),
              //Container(height: _height*0.03),
              // List Headers
              buildListviewHeaders(),
              // ListView of Athletes
              buildListview()
            ]));
  }

  Widget buildListviewHeaders() {
    double _width = MediaQuery.of(context).size.width;

    bool view = true;
    bool team = true;
    bool bookVal = true;
    if (_width < 910) view = false;
    if (_width < 684) team = false;
    if (_width < 575) bookVal = false;

    double athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Container(width: 66),
      Container(
          width: athNameBx,
          child: Text("Athlete",
              style: textStyle(Colors.grey[400]!, 12, false, false))),
      if (team)
        Container(
            width: _width * 0.15,
            child: Text("Team",
                style: textStyle(Colors.grey[400]!, 12, false, false))),
      Container(
          child: Text("Market Price / Change",
              style: textStyle(Colors.grey[400]!, 12, false, false))),
      if (bookVal) ...[
        Container(width: 25),
        Container(
            child: Text("Book Value / Change",
                style: textStyle(Colors.grey[400]!, 12, false, false))),
      ]
    ]);
  }

  Widget buildListview() {
    double _height = MediaQuery.of(context).size.height;
    double hgt = _height * 0.8 - 120;

    if (nflList.length == 0) nflList = AthleteList.list;
    // all athletes
    if (sportState == 0)
      return Container(
          height: hgt,
          child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemCount: AthleteList.list.length,
              itemBuilder: (context, index) {
                return createListCards(AthleteList.list[index]);
              }));
    // NFL athletes only
    else if (sportState == 1)
      return Container(
          height: hgt,
          child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemCount: nflList.length,
              itemBuilder: (context, index) {
                return createListCards(nflList[index]);
              }));
    // other athletes
    else {
      String spt = "NBA";
      if (sportState == 3) spt = "MMA";
      return Container(
          height: hgt,
          child: Center(
              child: Text("No " + spt + " Athletes Currently",
                  style: textStyle(Colors.white, 32, true, false))));
    }
  }

  // Athlete Cards
  Widget createListCards(Athlete athlete) {
    double _width = MediaQuery.of(context).size.width;

    bool view = true;
    bool team = true;
    bool bookVal = true;
    if (_width < 910) view = false;
    if (_width < 689) team = false;
    if (_width < 575) bookVal = false;

    double athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return Container(
        height: 70,
        child: OutlinedButton(
            onPressed: () {
              setState(() {
                curAthlete = athlete;
                athletePage = true;
              });
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    // Icon
                    Container(
                        width: 50,
                        child: Icon(Icons.sports_football,
                            color: Colors.grey[700])),
                    // Athlete Name
                    Container(
                        width: athNameBx,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(athlete.name,
                                  style: textStyle(
                                      Colors.white, 18, false, false)),
                              Text(athlete.position,
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
                                Text(athlete.team,
                                    style: textStyle(
                                        Colors.white, 18, false, false)),
                                Text(athlete.team,
                                    style: textStyle(
                                        Colors.grey[700]!, 10, false, false))
                              ])),
                    // Market Price / Change
                    Container(
                        child: Row(children: <Widget>[
                      Text(
                          athlete.war[athlete.war.length - 1]
                                  .toStringAsFixed(4) +
                              ' AX',
                          style: textStyle(Colors.white, 16, false, false)),
                      Container(width: 10),
                      Text("+%4",
                          style: textStyle(Colors.green, 12, false, false))
                    ])),
                    if (bookVal) ...[
                      Container(width: 41),
                      // Book Price
                      Container(
                          child: Row(children: <Widget>[
                        Text(
                            athlete.war[athlete.war.length - 1]
                                    .toStringAsFixed(4) +
                                ' AX',
                            style: textStyle(Colors.white, 16, false, false)),
                        Container(width: 10),
                        Text("-%2",
                            style: textStyle(Colors.red, 12, false, false))
                      ])),
                    ]
                  ]),
                  Row(children: <Widget>[
                    // Buy
                    Container(
                        width: 100,
                        height: 30,
                        decoration: boxDecoration(
                            Colors.amber[400]!, 100, 0, Colors.amber[400]!),
                        child: TextButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buyDialog(context, athlete)),
                            child: Text("Buy",
                                style: textStyle(
                                    Colors.black, 16, false, false)))),
                    if (view) ...[
                      Container(width: 25),
                      // Mint
                      Container(
                          width: 100,
                          height: 30,
                          decoration: boxDecoration(
                              Colors.transparent, 100, 2, Colors.white),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  curAthlete = athlete;
                                  athletePage = true;
                                });
                              },
                              child: Container(
                                  width: 90,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("View",
                                          style: textStyle(
                                              Colors.white, 16, false, false)),
                                      Icon(Icons.arrow_right,
                                          size: 25, color: Colors.white)
                                    ],
                                  ))))
                    ]
                  ])
                ])));
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

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}
