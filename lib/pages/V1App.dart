import 'package:ax_dapp/pages/DesktopFarm.dart';
import 'package:ax_dapp/pages/DesktopPool.dart';
import 'package:ax_dapp/pages/DesktopScout.dart';
import 'package:ax_dapp/pages/DesktopTrade.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class V1App extends StatefulWidget {
  @override
  _V1AppState createState() => _V1AppState();
}

class _V1AppState extends State<V1App> {
  // Feeling cute... may delete later
  Athlete tomBradey = Athlete(
      name: "Tom Bradey",
      team: "Tampa Bay Buckaneers",
      position: "Quarterback",
      passingYards: [2, 3, 5],
      passingTouchDowns: [1, 10, 3],
      reception: [4, 6, 8],
      receiveYards: [3, 5, 7],
      receiveTouch: [9, 8, 7],
      rushingYards: [6, 5, 4],
      war: [3.543, 1.094, 9.478, 10.231],
      time: [0, 1, 2, 3]);
  Athlete nullAthlete = new Athlete(
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

  // state change variables
  int pageNumber = 0;
  bool walletConnected =
      false; //flag to check if user has connected their wallet
  bool allFarms = true;
  List<Athlete> athleteList = [];
  Controller controller =
      Get.put(Controller()); // Rather Controller controller = Controller();
  SwapController swapController = Get.put(SwapController());
  AXT axt = AXT("AthleteX", "AX");
  Token matic = Token("Polygon", "MATIC");

  @override
  Widget build(BuildContext context) {
    Widget pageWidget = buildDesktop(context);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: topNavBar(context),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("../assets/images/blurredBackground.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: pageWidget));
    // Do not delete this yet. The original code before the changes
    /*return Scaffold(
      appBar: AppBar(
        title: topNavBar(context),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../assets/images/blurredBackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: pageWidget
      )
    );*/
  }

  Widget buildDesktop(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (pageNumber == 0)
          DesktopScout()
        else if (pageNumber == 1)
          DesktopTrade()
        else if (pageNumber == 2)
          DesktopPool()
        else if (pageNumber == 3)
          DesktopFarm()
      ],
    );
  }

  Widget topNavBar(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double tabTxSz = _width * 0.0185;
    if (tabTxSz < 19) tabTxSz = 19;
    double tabBxSz = _width * 0.3;
    if (tabBxSz < 270) tabBxSz = 270;

    return Container(
      width: _width * .95,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Tabs
          Container(
              width: tabBxSz,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 72,
                      height: 50,
                      child: IconButton(
                        icon: Image.asset("../assets/images/x.png"),
                        iconSize: 40,
                        onPressed: () {
                          String urlString = "https://www.athletex.io/";
                          launch(urlString);
                        },
                      ),
                    ),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 0)
                                setState(() {
                                  pageNumber = 0;
                                });
                            },
                            child: Text("Scout",
                                style: textSwapState(
                                    pageNumber == 0,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 1)
                                setState(() {
                                  pageNumber = 1;
                                });
                            },
                            child: Text("Trade",
                                style: textSwapState(
                                    pageNumber == 1,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 2)
                                setState(() {
                                  pageNumber = 2;
                                });
                            },
                            child: Text("Pool",
                                style: textSwapState(
                                    pageNumber == 2,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 3)
                                setState(() {
                                  pageNumber = 3;
                                });
                            },
                            child: Text("Farm",
                                style: textSwapState(
                                    pageNumber == 3,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                  ])),
          if (!controller.walletConnected) ...[
            // top Connect Wallet Button
            buildConnectWalletButton(),
          ] else ...[
            //top right corner wallet information
            buildAccountBox()
          ]
        ],
      ),
    );
  }

  Widget buildConnectWalletButton() {
    return Container(
        height: 37.5,
        width: 180,
        decoration:
            boxDecoration(Colors.transparent, 100, 2, Colors.amber[400]!),
        child: TextButton(
            onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => walletDialog(context))
                .then((value) => setState(() {})),
            child: Text(
              "Connect Wallet",
              style: textStyle(Colors.amber[400]!, 16, true, false),
            )));
  }

  Widget buildAccountBox() {
    double _width = MediaQuery.of(context).size.width;
    double wid = 500;
    bool network = true;
    bool matic = true;

    if (_width < 835) {
      matic = false;
      wid = 350;
    }
    if (_width < 665) {
      network = false;
      wid = 210;
    }

    String accNum = controller.publicAddress.value.toString();
    String retStr = accNum;
    if (accNum.length > 15)
      retStr = accNum.substring(0, 7) +
          "..." +
          accNum.substring(accNum.length - 5, accNum.length);

    return Container(
        height: 30,
        width: wid,
        decoration: boxDecoration(Colors.black, 10, 2, Colors.grey[400]!),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (network)
              TextButton(
                onPressed: () {
                  String urlString = "https://mumbai.polygonscan.com/";
                  launch(urlString);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Icon(
                      Icons.link,
                      color: Colors.grey,
                    ),
                    Text(
                      "Matic/Polygon",
                      style: textStyle(Colors.grey[400]!, 11, false, false),
                    )
                  ],
                ),
              ),
            if (matic)
              TextButton(
                onPressed: () {
                  controller.getCurrentGas();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Icon(
                      Icons.local_gas_station,
                      color: Colors.grey,
                    ),
                    Obx(() => Text(
                          "${controller.gasString} gwei",
                          style: textStyle(Colors.grey[400]!, 11, false, false),
                        ))
                  ],
                ),
              ),
            TextButton(
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => yourAXDialog(context))
                  .then((value) => (setState(() {}))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("../assets/images/X_white.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    "${axt.balance} AX",
                    style: textStyle(Colors.grey[400]!, 11, false, false),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => accountDialog(context))
                  .then((value) => setState(() {})),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.grey,
                  ),
                  Text(
                    retStr,
                    style: textStyle(Colors.grey[400]!, 11, false, false),
                  )
                ],
              ),
            )
          ],
        ));
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
}
