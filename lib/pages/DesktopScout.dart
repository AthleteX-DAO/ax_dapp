import 'package:ax_dapp/pages/AthletePage.dart';
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
  final myController = TextEditingController();
  bool athletePage = false;
  int sportState = 0;
  List<Athlete> nflList = [];
  List<Athlete> nflListFilter = [];
  // This will hold all the athletes
  List<Athlete> allList = [];
  List<Athlete> allListFilter = [];
  Athlete curAthlete = Athlete(
      name: "",
      id: 0,
      team: "",
      position: "",
      passingYards: 0,
      passingTouchDowns: 0,
      reception: 0,
      receiveYards: 0,
      receiveTouch: 0,
      rushingYards: 0,
      war: 0,
      time: "");

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sportFilterTxSz = 18;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    if (athletePage) return AthletePage(athlete: curAthlete);

    return Container(
        height: _height * 0.85 + 41,
        width: _width * 0.85,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // APT Title & Sport Filter
              Container(
                width: _width * 0.85,
                height: 50,
                child: Row(
                    children: [
                      Text("APT List",
                          style: textStyle(Colors.white, 18, false, false)),
                      Text("|",
                          style: textStyle(Colors.white, 18, false, false)),
                      Container(
                          child: TextButton(
                        onPressed: () {
                          myController.clear();
                          if (sportState != 0)
                            setState(() {
                              allListFilter = allList;
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
                          myController.clear();
                          if (sportState != 1)
                            setState(() {
                              nflListFilter = nflList;
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
                      Container(
                        child: Expanded(
                          child: Container(),
                        ),
                      ),
                      Container(
                        child: createSearchBar(),
                      ),
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

    bool team = true;
    bool bookVal = true;
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

    if (nflList.length == 0) {
      nflList = AthleteList.list;
      nflListFilter = nflList;
    }

    if (allList.length == 0) {
      // Filter all the athletes. For now we only have NFL athletes
      allList = nflList;
      allListFilter = allList;
    }

    // all athletes
    if (sportState == 0)
      return Container(
          height: hgt,
          child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              /*itemCount: AthleteList.list.length,
              itemBuilder: (context, index) {
                return createListCards(AthleteList.list[index]);
              }));*/
              // Build with all the all the athletes
              itemCount: allListFilter.length,
              itemBuilder: (context, index) {
                return createListCards(allListFilter[index]);
              }));
    // NFL athletes only
    else if (sportState == 1)
      return Container(
          height: hgt,
          child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemCount: nflListFilter.length,
              itemBuilder: (context, index) {
                return createListCards(nflListFilter[index]);
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

    String fn(String a) {
      if (a == "QB") {
        return "Quarterback";
      } else if (a == "WR") {
        return "Widereciever";
      } else if (a == "DT") {
        return "Defencetackle";
      } else if (a == "RB") {
        return "Runningback";
      } else if (a == "TE") {
        return "Tightend";
      } else if (a == "CB") {
        return "Cornerback";
      }
      return "B";
    }

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
                              Text(fn(athlete.position),
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
                      Text(athlete.war.toStringAsFixed(4) + ' AX',
                          style: textStyle(Colors.white, 16, false, false)),
                      Container(width: 10),
                      Text("+4%",
                          style: textStyle(Colors.green, 12, false, false))
                    ])),
                    if (bookVal) ...[
                      Container(width: 41),
                      // Book Price
                      Container(
                          child: Row(children: <Widget>[
                        Text(athlete.war.toStringAsFixed(4) + ' AX',
                            style: textStyle(Colors.white, 16, false, false)),
                        Container(width: 10),
                        Text("-2%",
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

  Widget createSearchBar() {
    return Container(
      width: 250,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(width: 8),
          Container(
            child: Icon(Icons.search, color: Colors.white),
          ),
          Container(width: 35),
          Expanded(
            child: Container(
              child: TextFormField(
                controller: myController,
                onChanged: (value) {
                  setState(() {
                    // Filter all athletes
                    if (sportState == 0) {
                      allListFilter = allList
                          .where((athlete) => athlete.name
                              .toUpperCase()
                              .contains(value.toUpperCase()))
                          .toList();
                    }
                    // Filter NFL athletes
                    else {
                      nflListFilter = nflList
                          .where((athlete) => athlete.name
                              .toUpperCase()
                              .contains(value.toUpperCase()))
                          .toList();
                    }
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8.5),
                  hintText: "Search an athlete",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
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
