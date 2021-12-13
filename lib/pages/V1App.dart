import 'dart:ui';
import 'package:ae_dapp/pages/DesktopScout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ae_dapp/service/Dialog.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:ae_dapp/service/WarTimeSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart' as series;

class V1App extends StatefulWidget {
  @override
  _V1AppState createState() => _V1AppState();
}

class _V1AppState extends State<V1App> {
  // Feeling cute... may delete later
  Athlete tomBradey = Athlete(name: "Tom Bradey", team: "Tampa Bay Buckaneers", position: "Quarterback", passingYards: [2,3,5], passingTouchDowns: [1,10,3], reception: [4,6,8], receiveYards: [3,5,7], receiveTouch: [9,8,7], rushingYards: [6,5,4], war: [3.543, 1.094, 9.478, 10.231], time: [0,1,2,3]);
  Athlete nullAthlete = new Athlete(name: "", team: "", position: "", passingYards: [], passingTouchDowns: [], reception: [], receiveYards: [], receiveTouch: [], rushingYards: [], war: [], time: []);

  // state change variables
  int pageNumber = 0;
  bool allFarms = true;

  @override
  Widget build(BuildContext context) {
    Widget pageWidget = buildDesktop(context);
    return Scaffold(
      appBar: AppBar(
        title: topNavBar(context),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("../assets/images/blurredBackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: pageWidget
      )
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (pageNumber == 0)
          DesktopScout()
        else if (pageNumber == 1)
          desktopTrade(context)
        else if (pageNumber == 2)
          desktopFarm(context)
      ],
    );
  }

  Widget desktopTrade(BuildContext context) {
    double wid = 550;

    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.15
        ),
        Container(
          height: 350,
          width: wid,
          decoration: boxDecoration(Colors.grey[800]!.withOpacity(0.6), 30, 0.5, Colors.grey[400]!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: wid-50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Swap",
                  style: textStyle(Colors.white, 16, false, false)
                )
              ),
              // To-dropdown
              Container(
                width: wid-50,
                height: 75,
                alignment: Alignment.center,
                decoration: boxDecoration(Colors.transparent, 20, 0.5, Colors.grey[400]!),
                child: Container(
                  width: wid-100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // to-dropdown
                      Container(
                        width: 125,
                        height: 40,
                        decoration: boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!),
                        //decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
                        child: TextButton(
                          onPressed: () => dialog(
                            context,
                            MediaQuery.of(context).size.height*.80,
                            350,
                            boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // column of elements
                                Container(
                                  height: MediaQuery.of(context).size.height*.75,
                                  width: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      // title row and close
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Select a token",
                                              style: textStyle(Colors.white, 14, true, false),
                                            ),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {Navigator.pop(context);},
                                                child: Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: Colors.white,
                                                )
                                              )
                                            )
                                          ],
                                        )
                                      ),
                                      Container(
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Token Name",
                                          style: textStyle(Colors.grey[400]!, 12, false, false)
                                        )
                                      ),
                                      Container(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey[400]
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height*.6,
                                        child: ListView(
                                          children: <Widget>[
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                          ]
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            )
                          ),
                          child: Container(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "AX",
                                  style: textStyle(Colors.white, 16, true, false)
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 25
                                )
                              ],
                            )
                          )
                        )
                      ),
                      Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 24,
                              width: 40,
                              decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "MAX",
                                  style: textStyle(Colors.grey[400]!, 8, false, false)
                                )
                              )
                            ),
                            Text(
                              "0.00",
                              style: textStyle(Colors.grey[400]!, 22, false, false)
                            )
                          ]
                        )
                      )
                    ],
                  )
                )
              ),
              // from-dropdown
              Container(
                width: wid-50,
                height: 75,
                alignment: Alignment.center,
                decoration: boxDecoration(Colors.transparent, 20, 0.5, Colors.grey[400]!),
                child: Container(
                  width: wid-100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // dropdown
                      Container(
                        width: 175,
                        height: 40,
                        decoration: boxDecoration(Colors.blue, 100, 0, Colors.blue),
                        child: TextButton(
                          onPressed: () => dialog(
                            context,
                            MediaQuery.of(context).size.height*.80,
                            350,
                            boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // column of elements
                                Container(
                                  height: MediaQuery.of(context).size.height*.75,
                                  width: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      // title row and close
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Select a token",
                                              style: textStyle(Colors.white, 14, true, false),
                                            ),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {Navigator.pop(context);},
                                                child: Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: Colors.white,
                                                )
                                              )
                                            )
                                          ],
                                        )
                                      ),
                                      Container(
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Token Name",
                                          style: textStyle(Colors.grey[400]!, 12, false, false)
                                        )
                                      ),
                                      Container(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey[400]
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height*.6,
                                        child: ListView(
                                          children: <Widget>[
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                          ]
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            )
                          ),
                          child: Container(
                            //width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Select a token",
                                  style: textStyle(Colors.white, 16, true, false)
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 25
                                )
                              ],
                            )
                          )
                        )
                      ),
                      Container(
                        child: Text(
                          "0.00",
                          style: textStyle(Colors.grey[400]!, 22, false, false)
                        )
                      )
                    ],
                  )
                )
              ),
              // Buttons
              Container(
                width: wid-50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Connect Wallet button
                    Container(
                      height: 50,
                      width: 200,
                      decoration: boxDecoration(Colors.transparent, 100, 4, Colors.amber[400]!),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Connect Wallet",
                          style: textStyle(Colors.amber[400]!, 16, true, false),
                        )
                      )
                    ),
                    // Swap button
                    Container(
                      height: 50,
                      width: 200,
                      decoration: boxDecoration(Colors.amber[400]!, 100, 4, Colors.amber[400]!),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Swap",
                          style: textStyle(Colors.black, 16, true, false),
                        )
                      )
                    ),
                  ],
                )
              )
            ],
          )
        ),
      ]
    );
  }

  Widget desktopFarm(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height*0.45+40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.15,
            alignment: Alignment.bottomLeft,
            child: Text(
              "Participating Farms",
              style: textStyle(Colors.white, 24, true, false)
            )
          ),
          Container(
            width: 200,
            height: 40,
            decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (allFarms)
                    Container(
                      width: 85,
                      decoration: boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "All Farms",
                          style: textStyle(Colors.white, 16, true, false)
                        )
                      )
                    ),
                  if (allFarms)
                    Container(
                      width: 90,
                      decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
                      child: TextButton(
                        onPressed: () {setState(() {allFarms = false;});},
                        child: Text(
                          "My Farms",
                          style: textStyle(Colors.white, 16, true, false)
                        )
                      )
                    ),
                  if (!allFarms)
                    Container(
                      width: 85,
                      decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
                      child: TextButton(
                        onPressed: () {setState(() {allFarms = true;});},
                        child: Text(
                          "All Farms",
                          style: textStyle(Colors.white, 16, true, false)
                        )
                      )
                    ),
                  if (!allFarms)
                    Container(
                      width: 90,
                      decoration: boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "My Farms",
                          style: textStyle(Colors.white, 16, true, false)
                        )
                      )
                    ),
                ],
              )
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.height/4,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  createFarmWidget("AX Farm"),
                  SizedBox(width: 50),
                  createFarmWidget("AX - Tom Brady APT"),
                  SizedBox(width: 50),
                  createFarmWidget("AX - Tom Brady APT"),
                ]
              ),
            )
          )
        ],
      )
    );
  }

  Widget topNavBar(BuildContext context) {
    double tabTxSz = 24;

    return Container(
      width: MediaQuery.of(context).size.width*.9,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Tabs
          Container(
            width: MediaQuery.of(context).size.width*.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('../assets/images/x.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      if (pageNumber != 0) setState(() {pageNumber = 0;});
                    },
                    child: Text(
                      "Scout",
                      style: textSwapState(
                        pageNumber == 0,
                        textStyle(Colors.white, tabTxSz, true, false),
                        textStyle(Colors.amber[400]!, tabTxSz, true, true)
                      )
                      
                    )
                  )
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      if (pageNumber != 1) setState(() {pageNumber = 1;});
                    },
                    child: Text(
                      "Trade",
                      style: textSwapState(
                        pageNumber == 1,
                        textStyle(Colors.white, tabTxSz, true, false),
                        textStyle(Colors.amber[400]!, tabTxSz, true, true)
                      )
                    )
                  )
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      if (pageNumber != 2) setState(() {pageNumber = 2;});
                    },
                    child: Text(
                      "Farm",
                      style: textSwapState(
                        pageNumber == 2,
                        textStyle(Colors.white, tabTxSz, true, false),
                        textStyle(Colors.amber[400]!, tabTxSz, true, true)
                      )
                    )
                  )
                )
              ]
            )
          ),
          // top Connect Wallet Button
          Container(
            height: 37.5,
            width: 200,
            decoration: boxDecoration(Colors.transparent, 100, 2, Colors.amber[400]!),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Connect Wallet",
                style: textStyle(Colors.amber[400]!, 16, true, false),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget createFarmWidget(String farmName) {
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Container(
      height: MediaQuery.of(context).size.height/4,
      width: 500,
      padding: EdgeInsets.symmetric(vertical: 22.5, horizontal: 50),
      decoration: boxDecoration(Color(0x80424242), 20, 1, Colors.grey[300]!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Farm Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                farmName,
                style: textStyle(Colors.white, 20, false, false)
              ),
              Container(
                width: 120,
                height: 35,
                decoration: boxDecoration(Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                child: TextButton(
                  onPressed: () => showDialog(context: context, builder: (BuildContext context) => depositDialog(context)),
                  child: Text(
                    "Deposit",
                    style: textStyle(Colors.black, 12, true, false)
                  )
                )
              ),
            ]
          ),
          // TVL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "TVL",
                style: txStyle,
              ),
              Text(
                "\$1,000,000",
                style: txStyle
              )
            ],
          ),
          // Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Swap Fee APY",
                style: txStyle
              ),
              Text(
                "20%",
                style: txStyle
              )
            ],
          ),
          // Rewards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "AX Rewards APY",
                style: txStyle
              ),
              Text(
                "10%",
                style: txStyle
              )
            ],
          ),
          // Total APY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total APY",
                style: txStyle
              ),
              Text(
                "30%",
                style: txStyle
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget createTokenDropdown(String ticker, String fullName) {
    return Container(
      height: 50,
      child: TextButton(
        onPressed: () {},
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
                width: 60,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 30,
                  height: 30,
                  color: Colors.black
                ),
              ),
              Container(
                height: 45,
                // ticker/name column "AX/AthleteX"
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 125,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ticker,
                        style: textStyle(Colors.white, 14, true, false),
                      )
                    ),
                    Container(
                      width: 125,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fullName,
                        style: textStyle(Colors.grey[100]!, 9, false, false),
                      )
                    ),
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }

  void dialog(BuildContext context, double _height, double _width, BoxDecoration _decoration, Widget _child) {
    Dialog fancyDialog = Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: _height,
        width: _width,
        decoration: _decoration,
        child: _child
      )
    );

    showDialog(context: context, builder: (BuildContext context) => fancyDialog);
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
  
  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition)
      return tru;
    return fls;
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