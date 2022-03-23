import 'package:ax_dapp/pages/AthletePage.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/foundation.dart';
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
  String allSportsTitle = "All Sports";
  String longTitle = "Long";

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
  int _widgetIndex = 0;
  int _marketVsBookPriceIndex = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sportFilterTxSz = 14;
    double sportFilterIconSz = 14;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    if (athletePage) return AthletePage(athlete: curAthlete);

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
          margin: EdgeInsets.only(top: 20),
          // Do not delete any of the changes here yet
          height: _height * 0.85 + 41,
          //height: _height*0.85-41,
          width: _width * 0.99,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                //Container(height: 15),
                // APT Title & Sport Filter
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  width: _width * 1,
                  height: 40,
                  child: kIsWeb
                      ? buildFilterMenuWeb(sportFilterTxSz, _width)
                      : buildFilterMenu(sportFilterTxSz, sportFilterIconSz),
                ),
                //Container(height: _height*0.03),
                // List Headers
                buildListviewHeaders(),
                // ListView of Athletes
                buildListview()
              ])),
    );
  }

  Row buildFilterMenuWeb(double sportFilterTxSz, double _width) {
    return Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("APT List", style: textStyle(Colors.white, 18, false, false)),
          Text("|", style: textStyle(Colors.white, 18, false, false)),
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
                    textStyle(Colors.white, sportFilterTxSz, false, false),
                    textStyle(
                        Colors.amber[400]!, sportFilterTxSz, false, true))),
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
                    textStyle(Colors.white, sportFilterTxSz, false, false),
                    textStyle(
                        Colors.amber[400]!, sportFilterTxSz, false, true))),
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
                    textStyle(Colors.white, sportFilterTxSz, false, false),
                    textStyle(
                        Colors.amber[400]!, sportFilterTxSz, false, true))),
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
                    textStyle(Colors.white, sportFilterTxSz, false, false),
                    textStyle(
                        Colors.amber[400]!, sportFilterTxSz, false, true))),
          )),
          Spacer(),
          Container(
            child: createSearchBar(),
          ),
        ]);
  }

  IndexedStack buildFilterMenu(
      double sportFilterTxSz, double sportFilterIconSz) {
    return IndexedStack(
      index: _widgetIndex,
      children: [
        Container(
          height: 20,
          child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("APT List",
                    style: textStyle(Colors.white, 18, false, false)),
                Text("|", style: textStyle(Colors.white, 18, false, false)),
                SizedBox(
                  child: PopupMenuButton(
                    child: Row(
                      children: [
                        Text(
                          allSportsTitle,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.grey,
                        )
                      ],
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("All Sports",
                                  style: textSwapState(
                                      sportState == 0,
                                      textStyle(Colors.white, sportFilterTxSz,
                                          false, false),
                                      textStyle(Colors.amber[400]!,
                                          sportFilterTxSz, false, true))),
                            ],
                          ),
                        ),
                        onTap: () {
                          myController.clear();
                          if (sportState != 0)
                            setState(() {
                              allListFilter = allList;
                              sportState = 0;
                            });
                          allSportsTitle = "All Sports";
                        },
                      ),
                      PopupMenuItem(
                        height: 5,
                        value: 1,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.sports_football,
                                    size: sportFilterIconSz,
                                  )),
                              Text("NFL",
                                  style: textSwapState(
                                      sportState == 1,
                                      textStyle(Colors.white, sportFilterTxSz,
                                          false, false),
                                      textStyle(Colors.amber[400]!,
                                          sportFilterTxSz, false, true))),
                            ],
                          ),
                        ),
                        onTap: () {
                          myController.clear();
                          if (sportState != 1)
                            setState(() {
                              nflListFilter = nflList;
                              sportState = 1;
                              allSportsTitle = "NFL";
                            });
                        },
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.sports_basketball,
                                    size: sportFilterIconSz,
                                  )),
                              Text("NBA",
                                  style: textSwapState(
                                      sportState == 2,
                                      textStyle(Colors.white, sportFilterTxSz,
                                          false, false),
                                      textStyle(Colors.amber[400]!,
                                          sportFilterTxSz, false, true))),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (sportState != 2)
                            setState(() {
                              sportState = 2;
                              allSportsTitle = "NBA";
                            });
                        },
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.sports_kabaddi,
                                    size: sportFilterIconSz,
                                  )),
                              Text("MMA",
                                  style: textSwapState(
                                      sportState == 3,
                                      textStyle(Colors.white, sportFilterTxSz,
                                          false, false),
                                      textStyle(Colors.amber[400]!,
                                          sportFilterTxSz, false, true))),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (sportState != 3)
                            setState(() {
                              sportState = 3;
                            });
                          allSportsTitle = "MMA";
                        },
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.sports_soccer,
                                    size: sportFilterIconSz,
                                  )),
                              Text("Soccer",
                                  style: textSwapState(
                                      sportState == 4,
                                      textStyle(Colors.white, sportFilterTxSz,
                                          false, false),
                                      textStyle(Colors.amber[400]!,
                                          sportFilterTxSz, false, true))),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (sportState != 4)
                            setState(() {
                              sportState = 4;
                            });
                          allSportsTitle = "Soccer";
                        },
                      ),
                    ],
                    offset: Offset(0, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                PopupMenuButton(
                  child: Row(
                    children: [
                      Text(
                        longTitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Long"),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          longTitle = "Long";
                        });
                      },
                    ),
                    PopupMenuItem(
                      height: 5,
                      value: 1,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Short"),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          longTitle = "Short";
                        });
                      },
                    ),
                  ],
                  offset: Offset(0, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                Spacer(),
                Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _widgetIndex = 1;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey,
                        )),
                  ),
                ),
              ]),
        ),
        Container(
            height: 40,
            child: Row(
              children: [
                Container(
                  child: Expanded(
                    child: Row(
                      children: [
                        createSearchBar(),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      _widgetIndex = 0;
                    });
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Color.fromRGBO(254, 197, 0, 1), fontSize: 17),
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget buildListviewHeaders() {
    double _width = MediaQuery.of(context).size.width;

    bool team = true;
    if (_width < 684) team = false;

    double athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(width: 66),
          Container(
              width: athNameBx,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Athlete",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              )),
          if (team)
            Container(
                width: _width * 0.15,
                child: Text("Team",
                    style: textStyle(Colors.grey[400]!, 12, false, false))),
          IndexedStack(
            index: _marketVsBookPriceIndex,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _marketVsBookPriceIndex = 1;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Market Price",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                          textAlign: TextAlign.justify,
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 2),
                        child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.autorenew,
                              size: 10,
                              color: Colors.grey,
                            )))
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _marketVsBookPriceIndex = 0;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Book Value",
                        style: textStyle(Colors.grey[400]!, 10, false, false)),
                    Container(
                        margin: EdgeInsets.only(left: 2),
                        child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.autorenew,
                              size: 10,
                              color: Colors.grey,
                            )))
                  ],
                ),
              ),
            ],
          ),
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
      if (sportState == 4) spt = "Soccer";
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
    if (_width < 910) view = false;
    if (_width < 689) team = false;
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
                    IndexedStack(
                      index: _marketVsBookPriceIndex,
                      children: [
                        Container(
                            child: Row(children: <Widget>[
                          Text(athlete.war.toStringAsFixed(4) + ' AX',
                              style: textStyle(Colors.white, 16, false, false)),
                          Container(width: 10),
                          Text("+4%",
                              style: textStyle(Colors.green, 12, false, false))
                        ])),
                        Container(
                            child: Row(children: <Widget>[
                          Text(athlete.war.toStringAsFixed(4) + ' AX',
                              style: textStyle(Colors.white, 16, false, false)),
                          Container(width: 10),
                          Text("-2%",
                              style: textStyle(Colors.red, 12, false, false))
                        ])),
                      ],
                    ),
                  ]),
                  Row(children: <Widget>[
                    // Buy
                    Container(
                        width: _width * 0.20,
                        height: 36,
                        decoration: boxDecoration(
                            Color.fromRGBO(254, 197, 0, 0.2),
                            100,
                            0,
                            Color.fromRGBO(254, 197, 0, 0.2)),
                        child: TextButton(
                            onPressed: (){
                              if (kIsWeb){
                                 showDialog(
                                    context: context,
                                    builder: (BuildContext context) => buyDialog(context, athlete));
                              }else {
                                setState(() {
                                  curAthlete = athlete;
                                  athletePage = true;
                                });
                              }
                            },
                            child: Center(
                              child: buyText(),
                            ))),
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
                                  width: 60,
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

  Widget buyText() {
    Widget textWidget;
    if (kIsWeb) {
      textWidget = Text("Buy",
          style: textStyle(Color.fromRGBO(254, 197, 0, 1.0), 12, false, false));
    } else {
      textWidget = Text("View",
          style: textStyle(Color.fromRGBO(255, 198, 0, 1), 10, false, false));
    }
    return textWidget;
  }

  Widget createSearchBar() {
    double widthSize = MediaQuery.of(context).size.width;
    return Container(
      width: searchWidth(widthSize),
      height: 160,
      decoration: boxDecoration(Color.fromRGBO(118, 118, 128, 0.24), 20, 1,
          Color.fromRGBO(118, 118, 128, 0.24)),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(width: 6),
          Container(
            child: Icon(
              Icons.search,
              color: Color.fromRGBO(235, 235, 245, 0.6),
              size: 20,
            ),
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
                  hintStyle:
                      TextStyle(color: Color.fromRGBO(235, 235, 245, 0.6)),
                ),
              ),
            ),
          ),
          Container(
            child: Icon(
              Icons.mic,
              color: Color.fromRGBO(235, 235, 245, 0.6),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  double searchWidth(double widthSize) {
    double _width;
    if (kIsWeb) {
      _width = widthSize * 0.26;
    } else {
      _width = widthSize * 0.66;
    }
    return _width;
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
