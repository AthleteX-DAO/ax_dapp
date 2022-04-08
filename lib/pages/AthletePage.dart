import 'package:ax_dapp/pages/scout/DesktopScout.dart';
import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/service/Controller/Scout/LSPController.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/service/WarTimeSeries.dart';
import 'package:ax_dapp/util/AbbreviationMappingsHelper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart' as series;
import 'package:flutter/foundation.dart' as kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AthletePage extends StatefulWidget {
  final AthleteScoutModel athlete;
  const AthletePage({
    Key? key,
    required this.athlete,
  }) : super(key: key);

  @override
  _AthletePageState createState() => _AthletePageState(athlete);
}

class _AthletePageState extends State<AthletePage> {
  AthleteScoutModel athlete;
  int listView = 0;

  _AthletePageState(this.athlete);

  int _widgetIndex = 0;
  int _longAptIndex = 0;
  Color primaryWhiteColor = Color.fromRGBO(255, 255, 255, 1);
  Color primaryOrangeColor = Color.fromRGBO(254, 197, 0, 1);
  Color secondaryGreyColor = Color.fromRGBO(56, 56, 56, 1);
  Color greyTextColor = Color.fromRGBO(160, 160, 160, 1);
  Color secondaryOrangeColor = Color.fromRGBO(254, 197, 0, 0.2);
  Color indexUnselectedStackBackgroundColor = Colors.transparent;
  bool _isLongApt = true;
  bool _isDisplayingChart = true;





  @override
  void initState() {
    super.initState();
    final LSPController lspController = Get.find();
    lspController.updateAptAddress(athlete.id);
    print(athlete.id);
  }

  @override
  Widget build(BuildContext context) {
    if (listView == 1) return DesktopScout();

    return kIsWeb.kIsWeb ? buildWebViewContainer(context) : buildMobileView(context);
  }

  IndexedStack buildWebViewContainer(BuildContext context) {

    final longMarketPrice = "4.18 AX";
    final longMarketPricePercent = "-2%";
    final longBookValue = "${athlete.bookPrice.toStringAsFixed(2)} AX";
    final longBookValuePercent = "+4%";

    final shortMarketPrice = "2.18 AX";
    final shortMarketPricePercent = "-1%";
    final shortBookValue = "${athlete.bookPrice.toStringAsFixed(2)} AX";
    final shortBookValuePercent = "+2%";


    return IndexedStack(
        index: _longAptIndex,
        children: [
      buildWebView(
          context,
          longMarketPrice,
          shortMarketPrice,
          longMarketPricePercent,
          shortMarketPricePercent,
          longBookValue,
          shortBookValue,
          longBookValuePercent,
          shortBookValuePercent
      ),
      buildWebView(
          context,
          longMarketPrice,
          shortMarketPrice,
          longMarketPricePercent,
          shortMarketPricePercent,
          longBookValue,
          shortBookValue,
          longBookValuePercent,
          shortBookValuePercent
      )
    ]);
  }

  Container buildWebView(
      BuildContext context,
      String longMarketPrice,
      String shortMarketPrice,
      String longMarketPricePercent,
      String shortMarketPricePercent,
      String longBookValue,
      String shortBookValue,
      String longBookValuePercent,
      String shortBookValuePercent,
      ) {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;

    // normal mode (dual)
    if (_width > 1160 && _height > 660)
      return Container(
          width: _width,
          height: _height,
          child: Center(
              child: Container(
                  width: _width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[graphSide(
                        context,longMarketPrice,
                      shortMarketPrice,
                      longMarketPricePercent,
                      shortMarketPricePercent,
                      longBookValue,
                      shortBookValue,
                      longBookValuePercent,
                      shortBookValuePercent,), statsSide(
                        context,
                      longMarketPrice,
                      shortMarketPrice,
                      longMarketPricePercent,
                      shortMarketPricePercent,
                      longBookValue,
                      shortBookValue,
                      longBookValuePercent,
                      shortBookValuePercent,)],
                  ))));

    // dual scroll mode
    if (_width > 1160 && _height < 660)
      return Container(
          height: _height * 0.95 - 57,
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                      child: Container(
                          width: _width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              graphSide(context,
                                longMarketPrice,
                                shortMarketPrice,
                                longMarketPricePercent,
                                shortMarketPricePercent,
                                longBookValue,
                                shortBookValue,
                                longBookValuePercent,
                                shortBookValuePercent,),
                              statsSide(context,
                                longMarketPrice,
                                shortMarketPrice,
                                longMarketPricePercent,
                                shortMarketPricePercent,
                                longBookValue,
                                shortBookValue,
                                longBookValuePercent,
                                shortBookValuePercent,)
                            ],
                          )))
                ],
              )));

    // stacked scroll
    return Container(
        height: _height * 0.95 - 57,
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 625,
                  child: graphSide(
                      context,
                    longMarketPrice,
                    shortMarketPrice,
                    longMarketPricePercent,
                    shortMarketPricePercent,
                    longBookValue,
                    shortBookValue,
                    longBookValuePercent,
                    shortBookValuePercent,),
                ),
                Container(height: 650, child: statsSide(
                    context,
                  longMarketPrice,
                  shortMarketPrice,
                  longMarketPricePercent,
                  shortMarketPricePercent,
                  longBookValue,
                  shortBookValue,
                  longBookValuePercent,
                  shortBookValuePercent,))
              ],
            )));
  }


  SafeArea buildMobileView(BuildContext context) {
    final longMarketPrice = "4.18 AX";
    final longMarketPricePercent = "-2%";
    final longBookValue = "${athlete.bookPrice.toStringAsFixed(2)} AX ";
    final longBookValuePercent = "+4%";

    final shortMarketPrice = "2.18 AX";
    final shortMarketPricePercent = "-1%";
    final shortBookValue = "${athlete.bookPrice.toStringAsFixed(2)} AX ";
    final shortBookValuePercent = "+2%";

    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    double _buttonHeight = MediaQuery
        .of(context)
        .size
        .height * 0.045;
    return SafeArea(
      child: IndexedStack(
        index: _longAptIndex,
        children: [
          buildPage(
              _width,
              _height,
              context,
              _buttonHeight,
              longMarketPrice,
              longMarketPricePercent,
              longBookValue,
              longBookValuePercent),
          buildPage(
              _width,
              _height,
              context,
              _buttonHeight,
              shortMarketPrice,
              shortMarketPricePercent,
              shortBookValue,
              shortBookValuePercent),
        ],),
    );
  }

  Container buildPage(double _width, double _height,
      BuildContext context, double _buttonHeight,
       String marketPrice, String marketPricePercent, String bookValue,
      String bookValuePercent) {
    return Container(
        width: _width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Divider(
                color: secondaryGreyColor,
                thickness: 0.5,
              ),
              Row(
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          setState(() {
                            listView = 1;
                          });
                        },
                        child: Icon(Icons.arrow_back,
                            size: 24, color: Colors.white)),
                    // APT Icon
                    Container(
                      margin: EdgeInsets.only(left: 0, top: .5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Text(athlete.name,
                                style:
                                textStyle(Colors.white, 20, false, false),
                              )
                          ),
                          Container(
                              child: Text("Seasonal APT",
                                style: textStyle(
                                    Color.fromRGBO(154, 154, 154, 1), 12, false,
                                    false),
                                textAlign: TextAlign.end,
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Icon(Icons.sports_baseball, size: 16,),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(1.5),
                      width: _width * .18,
                      height: _height * .04,
                      decoration: boxDecoration(
                          Colors.transparent, 10, 1, secondaryGreyColor),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: boxDecoration(_isLongApt
                                  ? secondaryGreyColor
                                  : indexUnselectedStackBackgroundColor, 8, 0,
                                  Colors.transparent),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(15, 8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _longAptIndex = 0;
                                    if (_longAptIndex == 0) {
                                      _isLongApt = true;
                                    }
                                    print(
                                        " The current index is $_longAptIndex  of 0 and it should show the Short");
                                  });
                                },
                                child: Text("Long",
                                  style: TextStyle(color: _isLongApt
                                      ? primaryWhiteColor
                                      : Color.fromRGBO(154, 154, 154, 1),
                                      fontSize: 10),),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: boxDecoration(
                                  _isLongApt
                                      ? indexUnselectedStackBackgroundColor
                                      : secondaryGreyColor,
                                  8,
                                  0,
                                  Colors.transparent),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(50, 30)
                                ),
                                onPressed: () {
                                  setState(() {
                                    _longAptIndex = 1;
                                    if (_longAptIndex == 1) {
                                      _isLongApt = false;
                                    }
                                    print(
                                        " The current index is $_longAptIndex  of 1 and it should show the short");
                                  });
                                },
                                child: Text("Short", style: TextStyle(
                                    color: _isLongApt ? Color.fromRGBO(
                                        154, 154, 154, 1) : primaryWhiteColor,
                                    fontSize: 10),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                        margin: EdgeInsets.only(right: 30),
                        width: _width * 0.22,
                        height: 20,
                        decoration: boxDecoration(
                            Color.fromRGBO(254, 197, 0, 0.2),
                            100,
                            0,
                            Color.fromRGBO(254, 197, 0, 0.2)),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30)
                            ),
                            onPressed: () {},
                            child: Center(
                              child: Text("+ Add to Wallet", style: TextStyle(
                                color: Color.fromRGBO(254, 197, 0, 1.0),
                                fontSize: 10,),),
                            ))),
                  ]
              ),
              // Graph
              IndexedStack(
                index: _widgetIndex,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(1.5),
                        width: _width * .875,
                        height: _height * .04,
                        decoration: boxDecoration(
                            Colors.transparent, 10, 1, secondaryGreyColor),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: boxDecoration(_isDisplayingChart
                                    ? secondaryGreyColor
                                    : indexUnselectedStackBackgroundColor, 8, 0,
                                    Colors.transparent),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(50, 30),
                                  ),
                                  onPressed: () {
                                    print(
                                        " The current index is $_widgetIndex of 0 and it should show the chart");
                                  },
                                  child: Text("Chart",
                                    style: TextStyle(color: _isDisplayingChart
                                        ? primaryWhiteColor
                                        : Color.fromRGBO(154, 154, 154, 1)),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: boxDecoration(
                                    _isDisplayingChart
                                        ? indexUnselectedStackBackgroundColor
                                        : secondaryGreyColor,
                                    8,
                                    0,
                                    Colors.transparent),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(50, 30)
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _widgetIndex = 1;
                                      if (_widgetIndex == 1) {
                                        _isDisplayingChart = false;
                                      }
                                      print(
                                          " The current index is $_widgetIndex  of 1 and it should show the stats");
                                    });
                                  },
                                  child: Text("Stats", style: TextStyle(
                                      color: _isDisplayingChart
                                          ? Color.fromRGBO(154, 154, 154, 1)
                                          : primaryWhiteColor),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          width: _width * .875,
                          height: _height * .4,
                          margin: EdgeInsets.only(top: 20),
                          decoration: boxDecoration(
                              Colors.transparent, 10, 1, secondaryGreyColor),
                          child: Stack(
                            children: <Widget>[

                              buildGraph(
                                  [athlete.bookPrice], [athlete.time], context),
                              // Price
                              Align(
                                  alignment: Alignment(-.85, -.8),
                                  child: Container(
                                      height: 45,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Book Value Chart",
                                              style: textStyle(Colors.white, 9,
                                                  false, false)),
                                          Container(
                                              width: 130,
                                              height: 25,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Text(bookValue,
                                                      style: textStyle(
                                                          Colors.white,
                                                          16,
                                                          true,
                                                          false)),
                                                  Container(
                                                      alignment:
                                                      Alignment.topLeft,
                                                      child: Text(
                                                          bookValuePercent,
                                                          style: textStyle(
                                                              Colors.green,
                                                              12,
                                                              false,
                                                              false)))
                                                ],
                                              ))
                                        ],
                                      ))),
                            ],
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(1.5),
                        width: _width * .875,
                        height: _height * .035,
                        decoration: boxDecoration(
                            Colors.transparent, 10, 1, secondaryGreyColor),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: boxDecoration(_isDisplayingChart
                                    ? secondaryGreyColor
                                    : indexUnselectedStackBackgroundColor, 8, 0,
                                    Colors.transparent),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(50, 30),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _widgetIndex = 0;
                                      if (_widgetIndex == 0) {
                                        _isDisplayingChart = true;
                                      }
                                      print(
                                          " The current index is $_widgetIndex of 0 and it should show the chart");
                                    });
                                  },
                                  child: Text("Chart",
                                    style: TextStyle(color: _isDisplayingChart
                                        ? primaryWhiteColor
                                        : Color.fromRGBO(154, 154, 154, 1)),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: boxDecoration(
                                    _isDisplayingChart
                                        ? indexUnselectedStackBackgroundColor
                                        : secondaryGreyColor,
                                    8,
                                    0,
                                    Colors.transparent),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(50, 30)
                                  ),
                                  onPressed: () {
                                    print(
                                        " The current index is $_widgetIndex  of 1 and it should show the stats");
                                  },
                                  child: Text("Stats", style: TextStyle(
                                      color: _isDisplayingChart
                                          ? Color.fromRGBO(154, 154, 154, 1)
                                          : primaryWhiteColor),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          width: _width * .875,
                          height: _height * .49,
                          alignment: Alignment.center,
                          child: Column(
                              children: <Widget>[
                                // Price Overview section
                                Container(
                                    height: 100,
                                    child: Column(
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceAround,
                                              children: <Widget>[
                                                Container(
                                                    width: _width * 0.4375,
                                                    child: Text(
                                                        "Price Overview",
                                                        style: textStyle(
                                                            Colors.white, 15,
                                                            false, false))),
                                                Container(
                                                    width: _width * 0.4375,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                "Current",
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false))),
                                                        Container(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Text(
                                                                "All-Time High",
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false)))
                                                      ],
                                                    ))
                                              ]),
                                          Divider(thickness: 1,
                                              color: greyTextColor),
                                          Container(height: 15,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      child: Text(
                                                          "Market Price",
                                                          style: textStyle(
                                                              greyTextColor, 12,
                                                              false, false))),
                                                  Container(
                                                      width: 200,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                            Row(children: <
                                                                Widget>[
                                                              Text(marketPrice,
                                                                  style: textStyle(
                                                                      Colors
                                                                          .white,
                                                                      12,
                                                                      false,
                                                                      false)),
                                                              Container(
                                                                //alignment: Alignment.topLeft,
                                                                  child: Text(
                                                                      marketPricePercent,
                                                                      style: textStyle(
                                                                          Colors
                                                                              .red,
                                                                          12,
                                                                          false,
                                                                          false))),
                                                            ]),
                                                            Text("4.24 AX",
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    12, false,
                                                                    false))
                                                          ]))
                                                ]),
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    width: _width * 0.175,
                                                    child: Text("Book Value",
                                                        style: textStyle(
                                                            greyTextColor, 12,
                                                            false, false))),
                                                Container(
                                                    width: 200,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: <Widget>[
                                                          Row(children: <
                                                              Widget>[
                                                            Text(bookValue,
                                                                style: textStyle(
                                                                    Colors
                                                                        .white,
                                                                    12,
                                                                    false,
                                                                    false)),
                                                            Container(
                                                                child: Text(
                                                                    bookValuePercent,
                                                                    style: textStyle(
                                                                        Colors
                                                                            .green,
                                                                        12,
                                                                        false,
                                                                        false))),
                                                          ]),
                                                          Text(bookValue,
                                                              style: textStyle(
                                                                  greyTextColor,
                                                                  12, false,
                                                                  false))
                                                        ]))
                                              ]),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    width: _width * 0.175,
                                                    child: Text("MP/BV Ratio",
                                                        style: textStyle(
                                                            greyTextColor, 12,
                                                            false, false))),
                                                Container(
                                                    width: 200,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: <Widget>[
                                                          Row(children: <
                                                              Widget>[
                                                            Text("80%",
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    12,
                                                                    false,
                                                                    false)),
                                                          ]),
                                                          Text("120%",
                                                              style: textStyle(
                                                                  greyTextColor,
                                                                  12, false,
                                                                  false))
                                                        ]))
                                              ]),
                                        ])),
                                // Detail Section
                                Container(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Details",
                                                  style:
                                                  textStyle(
                                                      Colors.white, 15, false,
                                                      false))),
                                          Divider(thickness: 1,
                                              color: greyTextColor),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Sport / League",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false)),
                                                Text("${athlete.sport.name}",//toDo add map for the different league
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false))
                                              ]),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Team",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false)),
                                                Text("${athlete.team}",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false))
                                              ]),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Position",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false)),
                                                Text(retrieveFullMLBAthletePosition(athlete.position),
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false))
                                              ]),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Season Start",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false)),
                                                Text("Sep 1, 2021",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false))
                                              ]),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Text("Season End",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false)),
                                                Text("Jan 10, 2022",
                                                    style: textStyle(
                                                        greyTextColor, 12,
                                                        false, false))
                                              ]),
                                        ])),
                                // Stats section
                                Container(
                                    height: 100,
                                    margin: EdgeInsets.only(top: 2),
                                    child: Column(
                                        children: <Widget>[
                                          Container(
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                          "Key Statistics",
                                                          style: textStyle(
                                                              Colors.white, 15,
                                                              false, false)),
                                                    ),
                                                    Container(
                                                        width: _width * 0.4375,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                    "AtBat",
                                                                    style: textStyle(
                                                                        greyTextColor,
                                                                        10,
                                                                        false,
                                                                        false)),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                    "HR",
                                                                    style: textStyle(
                                                                        greyTextColor,
                                                                        10,
                                                                        false,
                                                                        false)),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                    "wOBA",
                                                                    style: textStyle(
                                                                        greyTextColor,
                                                                        10,
                                                                        false,
                                                                        false)),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                    "SB",
                                                                    style: textStyle(
                                                                        greyTextColor,
                                                                        10,
                                                                        false,
                                                                        false)),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                    "Err",
                                                                    style: textStyle(
                                                                        greyTextColor,
                                                                        10,
                                                                        false,
                                                                        false)),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                    "InPl",
                                                                    style: textStyle(
                                                                        greyTextColor,
                                                                        10,
                                                                        false,
                                                                        false)),
                                                              ),
                                                            ])),
                                                  ])),
                                          Divider(thickness: 1,
                                              color: greyTextColor),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                      "Current season Stats",
                                                      style: textStyle(
                                                          greyTextColor, 12,
                                                          false, false)),
                                                ),
                                                Container(
                                                    width: _width * 0.4375,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                athlete.atBats.toString(),
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false)),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                athlete.homeRuns.toString(),
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false)),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                athlete.weightedOnBasePercentage.toStringAsFixed(3),
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false)),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                athlete.stolenBase.toString(),
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false)),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                athlete.errors.toString(),
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false)),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                athlete.inningsPlayed.toString(),
                                                                style: textStyle(
                                                                    greyTextColor,
                                                                    10,
                                                                    false,
                                                                    false)),
                                                          ),
                                                        ]))
                                              ]),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text("View All Stats",
                                                  style: textStyle(
                                                      primaryOrangeColor, 12,
                                                      false, true))),
                                        ])),
                              ])),
                    ],
                  )
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(top: .1),
                    width: _width * .875,
                    height: _height * .13,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    width: 160,
                                    height: _buttonHeight,
                                    decoration: boxDecoration(
                                        secondaryOrangeColor,
                                        100,
                                        0,
                                        secondaryOrangeColor),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(50, 30)
                                        ),
                                        onPressed: () =>
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                    buyDialog(context,
                                                        athlete)),
                                        child: Text("Buy",
                                            style: textStyle(primaryOrangeColor,
                                                20, false, false)))),
                                Container(
                                    width: 160,
                                    height: _buttonHeight,
                                    decoration: boxDecoration(
                                        secondaryOrangeColor,
                                        100,
                                        0,
                                        secondaryOrangeColor),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(50, 30)
                                        ),
                                        onPressed: () =>
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                    sellDialog(context,
                                                        athlete)),
                                        child: Text("Sell",
                                            style: textStyle(primaryOrangeColor,
                                                20, false, false))))
                              ]),
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    width: 160,
                                    height: _buttonHeight,
                                    decoration: boxDecoration(
                                        secondaryGreyColor,
                                        100,
                                        2,
                                        secondaryGreyColor),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(50, 30)
                                        ),
                                        onPressed: () =>
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                    mintDialog(context,
                                                        athlete)),
                                        child: Text("Mint",
                                            style: textStyle(primaryWhiteColor,
                                                20, false, false)))),
                                Container(
                                    width: 160,
                                    height: _buttonHeight,
                                    decoration: boxDecoration(
                                        secondaryGreyColor,
                                        100,
                                        2,
                                        secondaryGreyColor),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(50, 30)
                                        ),
                                        onPressed: () =>
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                    redeemDialog(context,
                                                        athlete)),
                                        child: Text("Redeem",
                                            style: textStyle(primaryWhiteColor,
                                                20, false, false))))
                              ]),
                        ])),
              )
            ]));
  }


  Widget graphSide(
      BuildContext context,
      String longMarketPrice,
      String shortMarketPrice,
      String longMarketPricePercent,
      String shortMarketPricePercent,
      String longBookValue,
      String shortBookValue,
      String longBookValuePercent,
      String shortBookValuePercent,) {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    double wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;
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
                              child: Icon(Icons.arrow_back,
                                  size: 50, color: Colors.white))),
                      // APT Icon
                      Container(
                        width: 30,
                      ),
                      // Player Name
                      Container(
                          child: Text(athlete.name,
                              style:
                              textStyle(Colors.white, 28, false, false))),
                      // '|' Symbol
                      Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text("|",
                              style: textStyle(
                                  Color.fromRGBO(100, 100, 100, 1), 24, false,
                                  false))),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Text("Seasonal APT",
                                  style: textStyle(
                                      Color.fromRGBO(154, 154, 154, 1), 24, false,
                                      false))),
                          Container(
                            padding: EdgeInsets.all(1.5),
                            width: _width * .10,
                            height: _height * .02,
                            decoration: boxDecoration(
                                Colors.transparent, 10, 1, secondaryGreyColor),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: boxDecoration(_isLongApt
                                        ? secondaryGreyColor
                                        : indexUnselectedStackBackgroundColor, 8, 0,
                                        Colors.transparent),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(15, 8),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _longAptIndex = 0;
                                          if (_longAptIndex == 0) {
                                            _isLongApt = true;
                                          }
                                          print(
                                              " The current index is $_longAptIndex  of 0 and it should show the Short");
                                        });
                                      },
                                      child: Text("Long",
                                        style: TextStyle(color: _isLongApt
                                            ? primaryWhiteColor
                                            : Color.fromRGBO(154, 154, 154, 1),
                                            fontSize: 10),),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: boxDecoration(
                                        _isLongApt
                                            ? indexUnselectedStackBackgroundColor
                                            : secondaryGreyColor,
                                        8,
                                        0,
                                        Colors.transparent),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(50, 30)
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _longAptIndex = 1;
                                          if (_longAptIndex == 1) {
                                            _isLongApt = false;
                                          }
                                          print(
                                              " The current index is $_longAptIndex  of 1 and it should show the short");
                                        });
                                      },
                                      child: Text("Short", style: TextStyle(
                                          color: _isLongApt ? Color.fromRGBO(
                                              154, 154, 154, 1) : primaryWhiteColor,
                                          fontSize: 10),),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ])),
            // graph
            Container(
                width: wid,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          width: wid * .875,
                          height: _height * .4,
                          decoration: boxDecoration(
                              Colors.transparent, 10, 1, greyTextColor),
                          child: Stack(
                            children: <Widget>[
                              // Graph
                              buildGraph(
                                  [athlete.bookPrice], [athlete.time], context),
                              // Price
                              Align(
                                  alignment: Alignment(-.85, -.8),
                                  child: Container(
                                      height: 45,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Book Value Chart",
                                              style: textStyle(Colors.white, 9,
                                                  false, false)),
                                          Container(
                                              width: 130,
                                              height: 25,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                      athlete.bookPrice
                                                          .toStringAsFixed(
                                                          4) +
                                                          " AX",
                                                      style: textStyle(
                                                          Colors.white,
                                                          14,
                                                          true,
                                                          false)),
                                                  Container(
                                                      alignment:
                                                      Alignment.topLeft,
                                                      child: Text((_longAptIndex==0)? longBookValuePercent : shortBookValuePercent,
                                                          style: textStyle(
                                                              Colors.green,
                                                              12,
                                                              false,
                                                              false)))
                                                ],
                                              ))
                                        ],
                                      ))),
                            ],
                          )),
                      Container(
                          width: wid * .875,
                          height: 150,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                          width: 175,
                                          height: 50,
                                          decoration: boxDecoration(
                                              primaryOrangeColor,
                                              100,
                                              0,
                                              primaryOrangeColor),
                                          child: TextButton(
                                              onPressed: () =>
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (
                                                          BuildContext context) =>
                                                          buyDialog(context,
                                                              athlete)),
                                              child: Text("Buy",
                                                  style: textStyle(Colors.black,
                                                      20, false, false)))),
                                      Container(
                                          width: 175,
                                          height: 50,
                                          decoration: boxDecoration(
                                              Colors.white,
                                              100,
                                              0,
                                              Colors.white),
                                          child: TextButton(
                                              onPressed: () =>
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (
                                                          BuildContext context) =>
                                                          sellDialog(context,
                                                              athlete)),
                                              child: Text("Sell",
                                                  style: textStyle(Colors.black,
                                                      20, false, false))))
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                          width: 175,
                                          height: 50,
                                          decoration: boxDecoration(
                                              Colors.transparent,
                                              100,
                                              2,
                                              Colors.white),
                                          child: TextButton(
                                              onPressed: () =>
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (
                                                          BuildContext context) =>
                                                          mintDialog(context,
                                                              athlete)),
                                              child: Text("Mint",
                                                  style: textStyle(Colors.white,
                                                      20, false, false)))),
                                      Container(
                                          width: 175,
                                          height: 50,
                                          decoration: boxDecoration(
                                              Colors.transparent,
                                              100,
                                              2,
                                              Colors.white),
                                          child: TextButton(
                                              onPressed: () =>
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (
                                                          BuildContext context) =>
                                                          redeemDialog(context,
                                                              athlete)),
                                              child: Text("Redeem",
                                                  style: textStyle(Colors.white,
                                                      20, false, false))))
                                    ]),
                              ]))
                    ])),
          ],
        ));
  }

  Widget statsSide(BuildContext context,
      String longMarketPrice,
      String shortMarketPrice,
      String longMarketPricePercent,
      String shortMarketPricePercent,
      String longBookValue,
      String shortBookValue,
      String longBookValuePercent,
      String shortBookValuePercent,) {

    final longMarketPrice = "4.18 AX";
    final longMarketPricePercent = "-2%";
    final longBookValue = "${athlete.bookPrice.toStringAsFixed(2)} AX ";
    final longBookValuePercent = "+4%";

    final shortMarketPrice = "2.18 AX";
    final shortMarketPricePercent = "-1%";
    final shortBookValue = "${athlete.bookPrice.toStringAsFixed(2)} AX";
    final shortBookValuePercent = "+2%";

    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

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
                                  width: wid * 0.4375,
                                  child: Text("Price Overview",
                                      style: textStyle(
                                          Colors.white, 24, false, false))),
                              Container(
                                  width: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text("Current",
                                              style: textStyle(
                                                  greyTextColor,
                                                  14,
                                                  false,
                                                  false))),
                                      Container(
                                          alignment: Alignment.bottomRight,
                                          child: Text("All-Time High",
                                              style: textStyle(
                                                  greyTextColor,
                                                  14,
                                                  false,
                                                  false)))
                                    ],
                                  ))
                            ]),
                        Divider(thickness: 1, color: greyTextColor),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  child: Text("Market Price",
                                      style: textStyle(greyTextColor, 20,
                                          false, false))),
                              Container(
                                  width: 200,
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Text((_longAptIndex==0)? longMarketPrice: shortMarketPrice,
                                              style: textStyle(Colors.white, 20,
                                                  false, false)),
                                          Container(
                                            //alignment: Alignment.topLeft,
                                              child: Text((_longAptIndex==0)? longMarketPricePercent : shortMarketPricePercent,
                                                  style: textStyle(Colors.red,
                                                      12, false, false))),
                                        ]),
                                        Text("4.24 AX",
                                            style: textStyle(greyTextColor,
                                                20, false, false))
                                      ]))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  width: _width * 0.175,
                                  child: Text("Book Value",
                                      style: textStyle(greyTextColor, 20,
                                          false, false))),
                              Container(
                                  width: 200,
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Text((_longAptIndex==0)? longBookValue : shortBookValue,
                                              style: textStyle(Colors.white, 14,
                                                  false, false)),
                                          Container(
                                              child: Text((_longAptIndex==0)? longBookValuePercent : shortBookValuePercent,
                                                  style: textStyle(Colors.green,
                                                      12, false, false))),
                                        ]),
                                        Text(shortBookValue,
                                            style: textStyle(greyTextColor,
                                                14, false, false))
                                      ]))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  width: _width * 0.175,
                                  child: Text("MP/BV Ratio",
                                      style: textStyle(greyTextColor, 20,
                                          false, false))),
                              Container(
                                  width: 200,
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Text("80%",
                                              style: textStyle(
                                                  greyTextColor,
                                                  16,
                                                  false,
                                                  false)),
                                        ]),
                                        Text("120%",
                                            style: textStyle(greyTextColor,
                                                16, false, false))
                                      ]))
                            ]),
                      ])),
              // Detail Section
              Container(
                  height: 250,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Details",
                                style:
                                textStyle(Colors.white, 24, false, false))),
                        Divider(thickness: 1, color: greyTextColor),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Sport / League",
                                  style: textStyle(
                                      greyTextColor, 20, false, false)),
                              Text("${athlete.sport.name}",//toDo add map for the different league
                                  style: textStyle(
                                      greyTextColor, 20, false, false))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Team",
                                  style: textStyle(
                                      greyTextColor, 20, false, false)),
                              Text("${athlete.team}",
                                  style: textStyle(
                                      greyTextColor, 20, false, false))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Position",
                                  style: textStyle(
                                      greyTextColor, 20, false, false)),
                              Text(retrieveFullMLBAthletePosition(athlete.position),
                                  style: textStyle(
                                      greyTextColor, 20, false, false))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Season Start",
                                  style: textStyle(
                                      greyTextColor, 20, false, false)),
                              Text("Mar 31, 2022",
                                  style: textStyle(
                                      greyTextColor, 20, false, false))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Season End",
                                  style: textStyle(
                                      greyTextColor, 20, false, false)),
                              Text("Nov 2, 2022",
                                  style: textStyle(
                                      greyTextColor, 20, false, false))
                            ]),
                      ])),
              // Stats section
              Container(
                  height: 150,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text("Key Statistics",
                                        style: textStyle(
                                            Colors.white, 24, false, false)),
                                  ),
                                  Container(
                                      width: 260,
                                      child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment
                                                  .bottomLeft,
                                              child: Text(
                                                  "AtBat",
                                                  style: textStyle(
                                                      greyTextColor,
                                                      10,
                                                      false,
                                                      false)),
                                            ),
                                            Container(
                                              alignment: Alignment
                                                  .bottomLeft,
                                              child: Text(
                                                  "HR",
                                                  style: textStyle(
                                                      greyTextColor,
                                                      10,
                                                      false,
                                                      false)),
                                            ),
                                            Container(
                                              alignment: Alignment
                                                  .bottomLeft,
                                              child: Text(
                                                  "wOBA",
                                                  style: textStyle(
                                                      greyTextColor,
                                                      10,
                                                      false,
                                                      false)),
                                            ),
                                            Container(
                                              alignment: Alignment
                                                  .bottomLeft,
                                              child: Text(
                                                  "SB",
                                                  style: textStyle(
                                                      greyTextColor,
                                                      10,
                                                      false,
                                                      false)),
                                            ),
                                            Container(
                                              alignment: Alignment
                                                  .bottomLeft,
                                              child: Text(
                                                  "Err",
                                                  style: textStyle(
                                                      greyTextColor,
                                                      10,
                                                      false,
                                                      false)),
                                            ),
                                            Container(
                                              alignment: Alignment
                                                  .bottomLeft,
                                              child: Text(
                                                  "InPl",
                                                  style: textStyle(
                                                      greyTextColor,
                                                      10,
                                                      false,
                                                      false)),
                                            ),
                                          ])),
                                ])),
                        Divider(thickness: 1, color: greyTextColor),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text("Current season Stats",
                                    style: textStyle(
                                        greyTextColor, 16, false, false)),
                              ),
                              Container(
                                  width: 260,
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment
                                              .bottomLeft,
                                          child: Text(
                                              athlete.atBats.toString(),
                                              style: textStyle(
                                                  greyTextColor,
                                                  10,
                                                  false,
                                                  false)),
                                        ),
                                        Container(
                                          alignment: Alignment
                                              .bottomLeft,
                                          child: Text(
                                              athlete.homeRuns.toString(),
                                              style: textStyle(
                                                  greyTextColor,
                                                  10,
                                                  false,
                                                  false)),
                                        ),
                                        Container(
                                          alignment: Alignment
                                              .bottomLeft,
                                          child: Text(
                                              athlete.weightedOnBasePercentage.toStringAsFixed(3),
                                              style: textStyle(
                                                  greyTextColor,
                                                  10,
                                                  false,
                                                  false)),
                                        ),
                                        Container(
                                          alignment: Alignment
                                              .bottomLeft,
                                          child: Text(
                                              athlete.stolenBase.toString(),
                                              style: textStyle(
                                                  greyTextColor,
                                                  10,
                                                  false,
                                                  false)),
                                        ),
                                        Container(
                                          alignment: Alignment
                                              .bottomLeft,
                                          child: Text(
                                              athlete.errors.toString(),
                                              style: textStyle(
                                                  greyTextColor,
                                                  10,
                                                  false,
                                                  false)),
                                        ),
                                        Container(
                                          alignment: Alignment
                                              .bottomLeft,
                                          child: Text(
                                              athlete.inningsPlayed.toString(),
                                              style: textStyle(
                                                  greyTextColor,
                                                  10,
                                                  false,
                                                  false)),
                                        ),
                                      ]))
                            ]),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text("View All Stats",
                                style: textStyle(
                                    primaryOrangeColor, 16, false, true))),
                      ])),
            ]));
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
    if (isBold)
      if (isUline)
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

  BoxDecoration boxDecoration(Color col, double rad, double borWid,
      Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}
