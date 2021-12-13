import 'dart:html';

import 'package:ae_dapp/service/Coin.dart';
import 'package:ae_dapp/service/CoinApi.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:ae_dapp/service/WarTimeSeries.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart' as series;
import 'package:ae_dapp/service/StakingController.dart';
import 'package:web3dart/browser.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int _selectedIndex = 0;
int swap = 0;
int stakingAmount = 0;
List<Athlete> athleteList = [];
List<Athlete> nflList = [];
List<Athlete> otherList = [];
List<Container> lpCardList = [];
List<Athlete> curAthletes = [];
List<String> athNames = [];
bool firstRun = true;
double filterText = 20;
var earnRange = [0, 3];
bool haveAthletes = false;
String _value1 = "ETH";
String _value2 = "USDC";
String sportActive = 'None';
bool swapActive = true;
bool stakeActive = false;
bool earnActive = false;
late Coin coin1;
late Coin coin2;
// Web3 Credentials
StakingController _controller = StakingController();

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int swap = 0;
  List<Athlete> athleteList = [];
  List<Athlete> nflList = [];
  List<Athlete> otherList = [];
  List<Container> lpCardList = [];
  List<Athlete> curAthletes = [];
  List<String> athNames = [];
  bool firstRun = true;
  double filterText = 20;
  var earnRange = [0, 3];
  bool haveAthletes = false;
  String _value1 = "ETH";
  String _value2 = "USDC";
  String sportActive = 'None';
  bool swapActive = true;
  bool stakeActive = false;
  bool earnActive = false;
  late Coin coin1;
  late Coin coin2;

  Athlete lastFirstEarn = Athlete(
      name: '',
      team: '',
      position: '',
      passingYards: [],
      passingTouchDowns: [],
      reception: [],
      receiveYards: [],
      receiveTouch: [],
      rushingYards: [],
      war: [],
      time: []);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSwapItemTapped(int index) {
    setState(() {
      swap = index;
    });
  }
    Future<void> checkMetamask() async {
    final eth = window.ethereum;
    if (eth != null) {
      print("Connecting to Web3!");
      
      // Immediately
      final client = Web3Client.custom(eth.asRpcService());
      final credentials = await eth.requestAccount();
      _controller.updateClient(client);
      _controller.updateCredentials(credentials);
      return;
    }
  }

  // Mobile navigation header
  Widget _mobileHeader(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .075,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // Upper-left Icon
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
            child:
                Image(image: AssetImage('../assets/images/x.png'), height: 30),
          ),
          // Upper-right connect wallet button
          Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: ElevatedButton(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text('Connect Wallet', style: connectWalletMobile),
                ),
                style: connectWallet,
                onPressed: () async {},
              ))
        ]));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CoinApi coinList = new CoinApi();
    return Scaffold(
        // NAVIGATION BAR //
        // if desktop, top app bar //
        appBar: (MediaQuery.of(context).size.width <= 768)
            ? null
            : AppBar(
                toolbarHeight: 70,
                leading: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Container(
                    child: Image(
                      image: AssetImage('../assets/images/x.png'),
                      width: 200,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: TextButton(
                      child: Text('SCOUT', style: toolbarButton),
                      onPressed: () {
                        _selectedIndex = 0;
                        _onItemTapped(_selectedIndex);
                      },
                    ),
                  ),
                  // DEX nav button
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: TextButton(
                      child: Text('DEX', style: toolbarButton),
                      onPressed: () {
                        _selectedIndex = 1;
                        _onItemTapped(_selectedIndex);
                      },
                    ),
                  ),
                  // FAQ nav button
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: TextButton(
                      child: Text('FAQ', style: toolbarButton),
                      onPressed: () {
                        _selectedIndex = 2;
                        _onItemTapped(_selectedIndex);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: SizedBox(
                        height: 10,
                        width: 200,
                        child: ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text('Connect Wallet',
                                style: connectWalletDesktop),
                          ),
                          style: connectWalletDesktopButton,
                          onPressed: () async {
                            checkMetamask();
                          },
                        )),
                  )
                ],
                backgroundColor: Colors.black.withOpacity(0),
              ),
        // if mobile, bottom app bar //
        bottomNavigationBar: (MediaQuery.of(context).size.width < 768)
            ? BottomNavigationBar(
                selectedFontSize: 15,
                selectedIconTheme:
                    IconThemeData(color: Colors.amberAccent, size: 30),
                selectedItemColor: Colors.amberAccent,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                backgroundColor: Colors.black,
                elevation: 0,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'SCOUT',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.swap_calls),
                    label: 'DEX',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.help),
                    label: 'FAQ',
                  ),
                ],
                currentIndex: _selectedIndex, //New
                onTap: _onItemTapped,
              )
            : null,
        // main body
        body: LayoutBuilder(builder: (context, constraints) {
          // Return mobile pages here
          if (constraints.maxWidth < 768) {
            // Scout page
            if (_selectedIndex == 0) {
              return Scaffold(
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image:
                      //         AssetImage('../assets/images/axBackground.jpeg'),
                      //     fit: BoxFit.fill,
                      //   ),
                      // ),
                      color: Colors.black.withOpacity(.7),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            _mobileHeader(context),
                            // Main mobile area
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * .83,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(children: [
                                      // Sport Filter button list
                                      Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .08,
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          athleteList = nflList;
                                                          firstRun = false;
                                                          sportActive = 'NFL';
                                                        });
                                                      },
                                                      child: Text(
                                                        "NFL",
                                                        style: TextStyle(
                                                          color: sportActive ==
                                                                  'NFL'
                                                              ? Colors
                                                                  .amber[600]
                                                              : Colors
                                                                  .grey[400],
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: filterText,
                                                          fontWeight:
                                                              sportActive ==
                                                                      'NFL'
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .w200,
                                                        ),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          athleteList = [];
                                                          firstRun = false;
                                                          sportActive = 'NBA';
                                                        });
                                                      },
                                                      child: Text(
                                                        "NBA",
                                                        style: TextStyle(
                                                          color: sportActive ==
                                                                  'NBA'
                                                              ? Colors
                                                                  .amber[600]
                                                              : Colors
                                                                  .grey[400],
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: filterText,
                                                          fontWeight:
                                                              sportActive ==
                                                                      'NBA'
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .w200,
                                                        ),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          athleteList = [];
                                                          firstRun = false;
                                                          sportActive = 'MMA';
                                                        });
                                                      },
                                                      child: Text(
                                                        "MMA",
                                                        style: TextStyle(
                                                          color: sportActive ==
                                                                  'MMA'
                                                              ? Colors
                                                                  .amber[600]
                                                              : Colors
                                                                  .grey[400],
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: filterText,
                                                          fontWeight:
                                                              sportActive ==
                                                                      'MMA'
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .w200,
                                                        ),
                                                      )),
                                                ],
                                              ))
                                        ],
                                      ),

                                      //Athlete Card View List
                                      Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .75,
                                              color: Colors.transparent,
                                              child: FutureBuilder<dynamic>(
                                                  future: AthleteApi
                                                      .getAthletesLocally(
                                                          context),
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                          .waiting:
                                                        // return circle indicator for progress
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      default:
                                                        nflList = snapshot.data;
                                                        if (firstRun)
                                                          athleteList = nflList;
                                                        return Container(
                                                            height: MediaQuery
                                                                        .of(
                                                                            context)
                                                                    .size
                                                                    .height *
                                                                0.5,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            child: ListView
                                                                .builder(
                                                                    physics:
                                                                        BouncingScrollPhysics(),
                                                                    itemCount:
                                                                        athleteList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final athlete =
                                                                          athleteList[
                                                                              index];
                                                                      return Card(
                                                                          color: Colors
                                                                              .transparent,
                                                                          shadowColor: Colors
                                                                              .black,
                                                                          child:
                                                                              ListTile(
                                                                            contentPadding: EdgeInsets.fromLTRB(
                                                                                20,
                                                                                10,
                                                                                20,
                                                                                10),
                                                                            title:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Row(children: [
                                                                                      Icon(
                                                                                        Icons.sports_football,
                                                                                        color: Colors.white,
                                                                                        size: 25.0,
                                                                                        semanticLabel: 'Text to announce in accessibility modes',
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                                                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                          Text(athlete.name, style: TextStyle(fontSize: 20)),
                                                                                          Text(athlete.position, style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8)), textAlign: TextAlign.left)
                                                                                        ]),
                                                                                      ),
                                                                                    ])),
                                                                                Align(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                                                                      Text('\$' + athlete.war[athlete.war.length - 1].toStringAsFixed(4), style: TextStyle(fontSize: 20)),
                                                                                      Text('+1.39%', style: TextStyle(fontSize: 15, color: Colors.green.withOpacity(0.8)), textAlign: TextAlign.right)
                                                                                    ])),
                                                                              ],
                                                                            ),
                                                                            onTap: () =>
                                                                                athleteDialogMobile(context, athlete),
                                                                          ));
                                                                    }));
                                                    }
                                                  }))
                                        ],
                                      )
                                    ])
                                  ],
                                ))
                          ])));
            }
            // Dex page
            else if (_selectedIndex == 1) {
              return Scaffold(
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black.withOpacity(.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: [
                            _mobileHeader(context),
                          ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        .82,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        color: Colors.transparent,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .55,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .06,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    // swap button
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          swapActive = true;
                                                          stakeActive = false;
                                                          earnActive = false;
                                                          _onSwapItemTapped(0);
                                                        },
                                                        child: Text('Swap'),
                                                        style: swapActive ==
                                                                true
                                                            ? dexToggleActive
                                                            : dexToggleInactiveMobile),
                                                    // stake button
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          swapActive = false;
                                                          stakeActive = true;
                                                          earnActive = false;
                                                          _onSwapItemTapped(1);
                                                        },
                                                        child: Text('Stake'),
                                                        style: stakeActive ==
                                                                true
                                                            ? dexToggleActive
                                                            : dexToggleInactiveMobile),
                                                    // earn button
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          swapActive = false;
                                                          stakeActive = false;
                                                          earnActive = true;
                                                          _onSwapItemTapped(2);
                                                        },
                                                        child: Text('Earn'),
                                                        style: earnActive ==
                                                                true
                                                            ? dexToggleActive
                                                            : dexToggleInactiveMobile),
                                                  ],
                                                )),
                                            // mobile swap ui
                                            if (swapActive)
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 50, 0, 0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .84,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .45,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // top token select
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                              .grey[
                                                                          900],
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: (Colors
                                                                            .grey[800])!,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20))),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .8,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .15,
                                                            )
                                                          ],
                                                        ),
                                                        // bottom token select
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 5, 0, 0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors.grey[
                                                                            900],
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              (Colors.grey[800])!,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(20))),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .8,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .15,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        // connect wallet button
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 20, 0, 0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .8,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .07,
                                                                color: Colors
                                                                    .transparent,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary: Colors.grey[
                                                                              900],
                                                                          shape:
                                                                              new RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                new BorderRadius.circular(20.0),
                                                                          ),
                                                                          side:
                                                                              BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                (Colors.grey[800])!,
                                                                          )),
                                                                  child: Text(
                                                                    "Connect Wallet",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontFamily:
                                                                          'OpenSans',
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),

                                            // mobile stake ui
                                            if (stakeActive)
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .8,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .4,
                                                color: Colors.red,
                                              ),
                                            // mobile earn ui
                                            if (earnActive)
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .8,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .5,
                                                color: Colors.blue,
                                              ),
                                          ],
                                        ))),
                              ]),
                        ],
                      )));
            }
            // Help page
            else {
              return Scaffold(
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('../assets/images/axBackground.jpeg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            // _mobileHeader(context),
                            // Main mobile area
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * .84,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Main mobile border box
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 3,
                                          ),
                                        ),
                                      )
                                    ]))
                          ])));
            }
          }
          // Return desktop pages here
          else {
            // desktop: Scout page
            if (_selectedIndex == 0) {
              return Scaffold(
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('../assets/images/axBackground.jpeg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main mobile area
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * .90,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Main mobile border box
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .79,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: Stack(children: <Widget>[
                                          Align(
                                              alignment:
                                                  Alignment(-0.55, -0.96),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Row(
                                                    children: <Widget>[
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              athleteList =
                                                                  nflList;
                                                              firstRun = false;
                                                            });
                                                          },
                                                          child: Text(
                                                            "NFL",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize:
                                                                  filterText,
                                                            ),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              athleteList = [];
                                                              firstRun = false;
                                                            });
                                                          },
                                                          child: Text(
                                                            "NBA",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize:
                                                                  filterText,
                                                            ),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              athleteList = [];
                                                              firstRun = false;
                                                            });
                                                          },
                                                          child: Text(
                                                            "MMA",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize:
                                                                  filterText,
                                                            ),
                                                          )),
                                                    ],
                                                  ))),
                                          Align(
                                              alignment: Alignment(0, 0),
                                              child: FutureBuilder<dynamic>(
                                                  future: AthleteApi
                                                      .getAthletesLocally(
                                                          context),
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                          .waiting:
                                                        // return circle indicator for progress
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      default:
                                                        nflList = snapshot.data;
                                                        if (firstRun)
                                                          athleteList = nflList;
                                                        return Container(
                                                            height: MediaQuery
                                                                        .of(
                                                                            context)
                                                                    .size
                                                                    .height *
                                                                0.65,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            child: ListView
                                                                .builder(
                                                                    physics:
                                                                        BouncingScrollPhysics(),
                                                                    itemCount:
                                                                        athleteList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final athlete =
                                                                          athleteList[
                                                                              index];
                                                                      return Card(
                                                                          color: Colors
                                                                              .transparent,
                                                                          shadowColor: Colors
                                                                              .black,
                                                                          child:
                                                                              ListTile(
                                                                            contentPadding: EdgeInsets.fromLTRB(
                                                                                0,
                                                                                10,
                                                                                0,
                                                                                10),
                                                                            title:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Row(children: [
                                                                                      Icon(
                                                                                        Icons.sports_football,
                                                                                        color: Colors.white,
                                                                                        size: 25.0,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                                                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                          Text(athlete.name, style: TextStyle(fontSize: 20)),
                                                                                          Text(athlete.position, style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8)), textAlign: TextAlign.left)
                                                                                        ]),
                                                                                      ),
                                                                                    ])),
                                                                                Align(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                                                                      Text('\$' + athlete.war[athlete.war.length - 1].toStringAsFixed(4), style: TextStyle(fontSize: 20)),
                                                                                      Text('+1.39%', style: TextStyle(fontSize: 15, color: Colors.green.withOpacity(0.8)), textAlign: TextAlign.right)
                                                                                    ])),
                                                                              ],
                                                                            ),
                                                                            onTap: () =>
                                                                                athleteDialog(context, athlete),
                                                                          ));
                                                                    }));
                                                    }
                                                  })),
                                          Align(
                                              alignment: Alignment(.97, 0.92),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: 23,
                                                  height: 23,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                      color: Colors.amber[600]!,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                      onPressed: () =>
                                                          scoutHintDialog(
                                                              context),
                                                      child: Text(
                                                        '?',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.amber[600],
                                                          fontSize: 12,
                                                        ),
                                                      ))))
                                        ]),
                                      ),
                                    ]))
                          ])));
            }
            // Dex page
            else if (_selectedIndex == 1) {
              return Scaffold(
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('../assets/images/axBackground.jpeg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .90,
                        child: Stack(alignment: Alignment.center, children: [
                          // Main mobile border box
                          Container(
                            width: MediaQuery.of(context).size.width * .9,
                            height: MediaQuery.of(context).size.height * .79,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.grey,
                                width: 3,
                              ),
                            ),
                          ),
                          // Swap / Earn / Stake Button Widget
                          Align(
                              alignment: Alignment(0, -0.98),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 3,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      // Swap Button
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .08,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .055,
                                        child: ElevatedButton(
                                          style: dexToggleActive,
                                          onPressed: () {
                                            swap = 0;
                                            _onSwapItemTapped(swap);
                                          },
                                          child: Text('Swap'),
                                        ),
                                      ),
                                      // Earn button
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .08,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .055,
                                        child: ElevatedButton(
                                          style: dexToggleActive,
                                          onPressed: () {
                                            swap = 1;
                                            _onSwapItemTapped(swap);
                                          },
                                          child: Text('Earn'),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .08,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .055,
                                        child: ElevatedButton(
                                          style: dexToggleActive,
                                          onPressed: () {
                                            swap = 2;
                                            _onSwapItemTapped(swap);
                                          },
                                          child: Text('Stake'),
                                        ),
                                      ),
                                    ],
                                  ))),
                          // DexSwap Widget
                          if (swap == 0)
                            // FutureBuilder<List<Coin>>(
                            //     future: coinList.getCoins(context),
                            //     builder: (context, snapshot) {
                            //       switch (snapshot.connectionState) {
                            //         case ConnectionState.waiting:
                            // return Stack(children: <Widget>[
                            Stack(children: <Widget>[
                              // Top token box
                              Align(
                                alignment: Alignment(0, -0.4),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.125,
                                    child: Center(
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    color: Colors.green),
                                                Text("0.0"),
                                              ],
                                            ))),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                              ),
                              // Bottom token box
                              Align(
                                alignment: Alignment(0, -0.05),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.125,
                                    child: Center(
                                        child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08,
                                              color: Colors.orange),
                                          Text("0.0"),
                                        ],
                                      ),
                                    )),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                              ),
                              // switch arrow
                              Align(
                                  alignment: Alignment(0, -0.225),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.032,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.032,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.arrow_downward_outlined,
                                            color: Colors.grey[500],
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.022,
                                          )))),
                              // buttons
                              Align(
                                  alignment: Alignment(0, 0.4),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          // Connect Wallet Button
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.amber[600]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                "Connect Wallet",
                                                style: TextStyle(
                                                  color: Colors.amber[600],
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Confirm Swap button
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            decoration: BoxDecoration(
                                              color: Colors.amber[600],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.amber[600]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () => {},
                                              child: Text(
                                                "Confirm Swap",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))
                            ]),
                          // End of Swap

                          // DexEarn Widget
                          if (swap == 1)
                            // Earn Page
                            Container(
                                //width: MediaQuery.of(context).size.width *0.8,
                                //height: MediaQuery.of(context).size.height *0.85,
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.175),
                                // Earn Elements
                                child: Column(children: <Widget>[
                                  // Earn Title
                                  Text("Participating Farms",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans',
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600)),
                                  // Sport Filter
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.075,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            // Highlight NFL Filter
                                            if (athleteList == nflList)
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      athleteList = nflList;
                                                    });
                                                  },
                                                  child: Text(
                                                    "NFL",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.amber[600],
                                                        fontFamily: 'OpenSans',
                                                        fontSize: filterText,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ))
                                            else
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      athleteList = nflList;
                                                    });
                                                  },
                                                  child: Text(
                                                    "NFL",
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontFamily: 'OpenSans',
                                                        fontSize: filterText,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                            // NBA filter button
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    athleteList = [];
                                                  });
                                                },
                                                child: Text(
                                                  "NBA",
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontFamily: 'OpenSans',
                                                      fontSize: filterText,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            // MMA Filter button
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    athleteList = [];
                                                  });
                                                },
                                                child: Text(
                                                  "MMA",
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontFamily: 'OpenSans',
                                                      fontSize: filterText,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                          ])),
                                  // Side scroll
                                  if (athleteList.isNotEmpty)
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.875,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.45,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              // Scroll Left
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.045,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .3,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        earnRange[0] -=
                                                            earnRange[1];
                                                        if (earnRange[0] < 0)
                                                          earnRange[0] = 0;

                                                        curAthletes = [];
                                                        for (int i = 0;
                                                            i < earnRange[1];
                                                            i++)
                                                          curAthletes.add(
                                                              athleteList[
                                                                  earnRange[0] +
                                                                      i]);

                                                        setState(() {
                                                          lastFirstEarn =
                                                              curAthletes[0];
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .transparent),
                                                      ),
                                                      child: Icon(
                                                        Icons.arrow_back_ios,
                                                        color: Colors.white,
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.075,
                                                      ))),
                                              // Horizontal List
                                              if (curAthletes.isEmpty)
                                                FutureBuilder<dynamic>(
                                                    future: AthleteApi
                                                        .getAthletesLocally(
                                                            context),
                                                    builder:
                                                        (context, snapshot) {
                                                      switch (snapshot
                                                          .connectionState) {
                                                        case ConnectionState
                                                            .waiting:
                                                          // return circle indicator for progress
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        default:
                                                          nflList =
                                                              snapshot.data;
                                                          athleteList = nflList;
                                                          for (int i = 0;
                                                              i <
                                                                      earnRange[
                                                                          1] &&
                                                                  i <
                                                                      athleteList
                                                                          .length;
                                                              i++)
                                                            curAthletes.add(
                                                                athleteList[i]);

                                                          if (curAthletes
                                                              .isNotEmpty)
                                                            lastFirstEarn =
                                                                curAthletes[0];

                                                          return LPEarnListView(
                                                              context);
                                                      }
                                                    })
                                              //Once < or > is pressed
                                              // ignore: unnecessary_null_comparison
                                              else if (lastFirstEarn ==
                                                  curAthletes[0])
                                                LPEarnListView(context),
                                              // Scroll Right
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.055555,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .3,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        earnRange[0] +=
                                                            earnRange[1];
                                                        if (earnRange[0] >
                                                            athleteList.length -
                                                                earnRange[1])
                                                          earnRange[0] =
                                                              athleteList
                                                                      .length -
                                                                  earnRange[1];

                                                        curAthletes = [];
                                                        for (int i = 0;
                                                            i < earnRange[1];
                                                            i++)
                                                          curAthletes.add(
                                                              athleteList[
                                                                  earnRange[0] +
                                                                      i]);

                                                        setState(() {
                                                          lastFirstEarn =
                                                              curAthletes[0];
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .transparent),
                                                      ),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.white,
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.075,
                                                      ))),
                                            ]))
                                ])),
                          // End of Earn
                          // DexStake Widget
                          if (swap == 2)
                            Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Scrollbar(
                                  controller: ScrollController(),
                                  isAlwaysShown: true,
                                  interactive: true,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        createFarmWidget("AX Farm"),
                                        SizedBox(width: 50),
                                        createFarmWidget("AX - Tom Brady APT"),
                                        SizedBox(width: 50),
                                        createFarmWidget("AX - Tom Brady APT"),
                                      ]),
                                ))

                          //)
                          // End of Earn
                        ]),
                      )));
            }

            // Help page
            else {
              //return Text('empty');
              return Center(
                child: Container(
                  //mainAxisAlignment:MainAxisAlignment.Center,
                  //alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height * .79,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.grey,
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Frequently Asked Questions",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                        ),
                      ),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              child: Column(children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .15,
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                focusColor: Colors.grey,
                                //Color:Colors.grey,
                                //value: _chosenValue,
                                //elevation: 5,
                                items: <String>[
                                  ''
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(color: Colors.white),
                                iconEnabledColor: Colors.grey,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .15,
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                focusColor: Colors.grey,
                                //Color:Colors.grey,
                                //value: _chosenValue,
                                //elevation: 5,
                                items: <String>[
                                  ''
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(color: Colors.white),
                                iconEnabledColor: Colors.grey,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .15,
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                focusColor: Colors.grey,
                                //Color:Colors.grey,
                                //value: _chosenValue,
                                //elevation: 5,
                                items: <String>[
                                  ''
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(color: Colors.white),
                                iconEnabledColor: Colors.grey,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .15,
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButton<String>(
                                focusColor: Colors.grey,
                                //Color:Colors.grey,
                                //value: _chosenValue,
                                //elevation: 5,
                                items: <String>[
                                  ''
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(color: Colors.white),
                                iconEnabledColor: Colors.grey,
                              ),
                            ),
                          ])),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .3,
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButton<String>(
                                    focusColor: Colors.grey,
                                    //Color:Colors.grey,
                                    //value: _chosenValue,
                                    //elevation: 5,
                                    items: <String>['']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      );
                                    }).toList(),
                                    style: TextStyle(color: Colors.white),
                                    iconEnabledColor: Colors.grey,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .3,
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButton<String>(
                                    focusColor: Colors.grey,
                                    //Color:Colors.grey,
                                    //value: _chosenValue,
                                    //elevation: 5,
                                    items: <String>['']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      );
                                    }).toList(),
                                    style: TextStyle(color: Colors.white),
                                    iconEnabledColor: Colors.grey,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .3,
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButton<String>(
                                    focusColor: Colors.grey,
                                    //Color:Colors.grey,
                                    //value: _chosenValue,
                                    //elevation: 5,
                                    items: <String>['']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      );
                                    }).toList(),
                                    style: TextStyle(color: Colors.white),
                                    iconEnabledColor: Colors.grey,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .3,
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButton<String>(
                                    focusColor: Colors.grey,
                                    //Color:Colors.grey,
                                    //value: _chosenValue,
                                    //elevation: 5,
                                    items: <String>['']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      );
                                    }).toList(),
                                    style: TextStyle(color: Colors.white),
                                    iconEnabledColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              );
            }
          }
        }));
  }

  Widget createFarmWidget(String farmName) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width / 3,
      padding: EdgeInsets.symmetric(vertical: 22.5, horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0x80424242),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Farm Title
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  farmName,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                  ),
                ),
                Container(
                    width: 120,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.amber[600],
                    ),
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Deposit",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ))),
              ]),
          // TVL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "TVL",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              ),
              Text(
                "\$1,000,000",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              )
            ],
          ),
          // Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Swap Fee APY",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              ),
              Text(
                "20%",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              )
            ],
          ),
          // Rewards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "AX Rewards APY",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              ),
              Text(
                "10%",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              )
            ],
          ),
          // Total APY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total APY",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              ),
              Text(
                "30%",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                ),
              )
            ],
          ),
        ],
      ),
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
      width: MediaQuery.of(context).size.width * 0.55,
      height: MediaQuery.of(context).size.height * 0.40,
      child: charts.TimeSeriesChart(
        athleteData,
        // Sets up a currency formatter for the measure axis.
        // primaryMeasureAxis: new charts.NumericAxisSpec(
        //   tickProviderSpec:
        //   new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
        // ),
        // domainAxis: charts.NumericAxisSpec(
        //   tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
        //   tickFormatterSpec: customChartTickFormatter,
        // ),
      ),
    );
  }

/*
  Widget buildGraph(List war, List time, BuildContext context) {
    List<FlSpot> athleteData = [];
    bool hour = true;
    DateTime maxTime = DateTime(-1);
    List<charts.Series<WarTimeSeries, int>> lineSeriesData = [];

    if (hour) {
      DateTime lastHour = DateTime(-1);
      for (int i = 0; i < war.length - 1; i++) {
        
        DateTime dateTime = DateTime.parse(time[i]);

        // only new points
        if (lastHour.year == -1 || (lastHour.isBefore(dateTime) && dateTime.hour != lastHour.hour)) {
          lastHour = dateTime;
          if (maxTime == DateTime(-1)  || maxTime.isBefore(dateTime))
            maxTime = dateTime;

// possible solution: https://stackoverflow.com/questions/54049781/how-to-pass-string-parameter-in-line-chart-x-axis-flutter
          // athleteData.add(
          //   WarTimeSeries(dateTime, war[i])
          // );
//try back to working chart and chainging domainaxis
          athleteData.add(
            FlSpot(
              dateTime.millisecondsSinceEpoch.toDouble(), 
              war[i].toDouble())
          );
        }
        
      }
    }

    // lineSeriesData.add(
    //   charts.Series(
    //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffffb300)),
    //     id: 'War Stats',
    //     data: athleteData,
    //     domainFn: (WarTimeSeries wts, _) => wts.time.millisecondsSinceEpoch,
    //     measureFn: (WarTimeSeries wts, _) => wts.war,
    //   )
    // );
    
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      height: MediaQuery.of(context).size.height * 0.40,
    //   child: charts.LineChart(
    //     lineSeriesData,
    //     defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true),
    //     animate: true,
    //     animationDuration: Duration(seconds: 3),
    //     // Sets up a currency formatter for the measure axis.
    //     primaryMeasureAxis: new charts.NumericAxisSpec(
    //       tickProviderSpec:
    //       new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
    //     ),
    //     domainAxis: charts.NumericAxisSpec(
    //       tickProviderSpec:
    //       charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
    //       tickFormatterSpec: customChartTickFormatter,
    //     ),
    //   ),
    // );
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
          ),
          backgroundColor: Colors.grey[800],
          minX: 0,
          maxX: maxTime.millisecondsSinceEpoch.toDouble(),
          minY: 0,
          maxY: 1,
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          lineBarsData: [
            LineChartBarData(
              colors: [(Colors.amber[600])!],
              spots: athleteData,
              isCurved: false,
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      )
    );
  }
*/
  // Athlete Popup
  void athleteDialog(BuildContext context, Athlete athlete) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(children: <Widget>[
          // Background
          Align(
            alignment: Alignment(0, 0.6),
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .79,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
              ),
            ),
          ),
          // Name | Token Type
          Align(
              alignment: Alignment(-0.775, -0.55),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Name
                        Text(athlete.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            )),
                        // |
                        Text('|',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'OpenSans',
                              fontSize: 26,
                            )),
                        // Token Type
                        Text("Seasonal APT",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'OpenSans',
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            )),
                      ]))),
          // Coming Soon / soon to be graph
          Align(
              alignment: Alignment(-0.675, 0.05),
              child: Container(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .45,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.0),
                    // border: Border.all(
                    //   color: Colors.grey,
                    //   width: 2,
                    // ),
                  ),
                  child: buildGraph(athlete.war, athlete.time, context)
                  // child: Center(
                  //     child: Text("Player Stats\nCOMING SOON",
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           color: Colors.amber[600],
                  //           fontFamily: 'OpenSans',
                  //           fontSize: 30,
                  //           fontWeight: FontWeight.w600,
                  //         )))
                  )),
          // War Price
          Align(
              alignment: Alignment(-0.8, -0.36),
              child:
                  Text(athlete.war[athlete.war.length - 1].toStringAsFixed(4),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ))),
          // Overview Text
          Align(
              alignment: Alignment(0.385, -0.54),
              child: Text("Overview",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ))),
          // Overview Divider
          Align(
              alignment: Alignment(0.8, -0.45),
              child: Container(
                  width: MediaQuery.of(context).size.width * .275,
                  height: 1,
                  color: Colors.grey)),
          // Overview block
          Align(
              alignment: Alignment(0.8, -0.25),
              child: Container(
                  width: MediaQuery.of(context).size.width * .275,
                  height: MediaQuery.of(context).size.height * .25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Sport row
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Sport",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text("American Football",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                          ]),
                      // league row
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("League",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text("NFL",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                          ]),
                      // position row
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Position",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text(athlete.position,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                          ]),
                      // season start row
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Season Start",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text("September 15, 2021",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                          ]),
                      // Season end row
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Season End",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text("January 15, 2022",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                          ]),
                    ],
                  ))),
          // Scout buy button, mint button column
          Align(
              alignment: Alignment(0.8, 0.4),
              child: Container(
                  width: MediaQuery.of(context).size.width * .275,
                  height: MediaQuery.of(context).size.height * .16,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Buy Long APT Button
                            Container(
                                width: MediaQuery.of(context).size.width * .125,
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text("Buy",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )),
                                )),
                            // Mint button
                            Container(
                                width: MediaQuery.of(context).size.width * .125,
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                        color: Colors.amber[600]!, width: 2)),
                                child: TextButton(
                                  onPressed: () => mintDialog(context, athlete),
                                  child: Text("Mint",
                                      style: TextStyle(
                                        color: Colors.amber[600],
                                        fontFamily: 'OpenSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ))
                          ],
                        ),
                        // scout short button, redeem button column
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // buy short apt button
                            Container(
                                width: MediaQuery.of(context).size.width * .125,
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text("Sell",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        )))),
                            // scout redeem button
                            Container(
                                width: MediaQuery.of(context).size.width * .125,
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                        color: Colors.amber[600]!, width: 2)),
                                child: TextButton(
                                  onPressed: () =>
                                      redeemDialog(context, athlete),
                                  child: Text("Redeem",
                                      style: TextStyle(
                                        color: Colors.amber[600],
                                        fontFamily: 'OpenSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ))
                          ],
                        )
                      ]))),
          // Bottom Stats
          Align(
            alignment: Alignment(0, 0.83),
            child: Container(
                width: MediaQuery.of(context).size.width * .8,
                height: MediaQuery.of(context).size.height * .125,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Athlete Statistics",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text("Value",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Passing Touchdowns",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(
                              athlete.passingTouchDowns[
                                  athlete.passingTouchDowns.length - 1],
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Passing Yards",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(
                              athlete.passingYards[
                                  athlete.passingYards.length - 1],
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Reception",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(athlete.reception[athlete.reception.length - 1],
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Receive Yards",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(
                              athlete.receiveYards[
                                  athlete.receiveYards.length - 1],
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Receive Touchdowns",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(
                              athlete.receiveTouch[
                                  athlete.receiveTouch.length - 1],
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ])),
          ), // Bottom stat Divider
          Align(
              alignment: Alignment(0, 0.715),
              child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  height: 1,
                  color: Colors.grey)),
          // Back Button
          Align(
              alignment: Alignment(-0.93, -0.66),
              child: Container(
                  width: 80,
                  height: 50,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back,
                          color: Colors.grey[400], size: 50)))),
        ]));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  void athleteDialogMobile(BuildContext context, athlete) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 100),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: SingleChildScrollView(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.8),
            child: Column(
              children: <Widget>[
                Row(children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .08,
                    color: Colors.transparent,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                ]),
                // athlete name
                Row(children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .03,
                      color: Colors.transparent,
                      child: Row(children: <Widget>[
                        // Name
                        Text(athlete.name,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            )),
                        // |
                        Text(' | ',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            )),
                        // Token Type
                        Text("Seasonal APT",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            )),
                      ]))
                ]),
                // athlete war value
                Row(children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            '\$' + athlete.war[3].toStringAsFixed(8),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ))
                ]),
                // Percent increase
                Row(children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            '+\$0.0000234',
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '(1.12%)',
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ))
                ]),
                //athlete graph
                Row(children: [
                  Stack(children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .4,
                        color: Colors.transparent,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12.0),
                              // border: Border.all(
                              //   color: Colors.grey,
                              //   width: 2,
                              // ),
                            ),
                            child:
                                buildGraph(athlete.war, athlete.time, context)
                            // child: Center(
                            //     child: Text("Player Stats\nCOMING SOON",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //           color: Colors.amber[600],
                            //           fontFamily: 'OpenSans',
                            //           fontSize: 30,
                            //           fontWeight: FontWeight.w600,
                            //         )))
                            )),
                  ])
                ]),
                // athlete purchase buttons
                Row(
                  children: [
                    Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .2,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  // Buy Long APT Button
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .40,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text("Buy",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'OpenSans',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      )),
                                  // Mint button
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .40,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                              color: Colors.amber[600]!,
                                              width: 2)),
                                      child: TextButton(
                                        onPressed: () =>
                                            mintDialog(context, athlete),
                                        child: Text("Mint",
                                            style: TextStyle(
                                              color: Colors.amber[600],
                                              fontFamily: 'OpenSans',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ))
                                ],
                              ),
                              // scout short button, redeem button column
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  // buy short apt button
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .40,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Text("Sell",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )))),
                                  // scout redeem button
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .40,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                              color: Colors.amber[600]!,
                                              width: 2)),
                                      child: TextButton(
                                        onPressed: () =>
                                            redeemDialog(context, athlete),
                                        child: Text("Redeem",
                                            style: TextStyle(
                                              color: Colors.amber[600],
                                              fontFamily: 'OpenSans',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ))
                                ],
                              )
                            ]))
                  ],
                ),
                // OVERVIEW
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .06,
                          child: Row(
                            children: [
                              Text(
                                'Overview',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                    ]),
                //divider
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: 1,
                          color: Colors.grey)
                    ]),
              ],
            ),
          )),
        );
      },
    );
  }

  // Scout Mint popup
  void mintDialog(BuildContext context, Athlete athlete) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Align(
          alignment: Alignment(0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 3,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Stack(children: <Widget>[
              // Mint Title
              Align(
                  alignment: Alignment(0, -0.9),
                  child: Text("MINT",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ))),
              // Athlete Name
              Align(
                  alignment: Alignment(0, -0.65),
                  child: Text(athlete.name + " APT",
                      style: TextStyle(
                        color: Colors.amber[600],
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ))),
              // AX Amount text box
              Align(
                  alignment: Alignment(0, -0.30),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.0),
                          border:
                              Border.all(color: Colors.grey[600]!, width: 2)),
                      child: Center(
                          child: TextFormField(
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Input AX Amount"),
                      )))),
              // text
              Align(
                  alignment: Alignment(0, 0.05),
                  child: Text("You will receive:",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, 0.25),
                  child: Text("20 Long " + athlete.name + " APTs",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ))),
              // short tokens text
              Align(
                  alignment: Alignment(0, 0.45),
                  child: Text("20 Short " + athlete.name + " APTs",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, 0.85),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            mintConfirmDialog(context, athlete);
                          },
                          child: Text("Confirm",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ))))),
              // Top 'X'
              Align(
                // These values are based on trial & error method
                alignment: Alignment(0.92, -0.95),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  void stakeDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 3,
            ),
          ),
          //child:Align(
          //alignment: Alignment(0,-0.5),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Staking Position text
                    /** 
                                    InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 35,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              **/
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.075,
                        child: Text(
                          "STAKE",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.0),
                            border:
                                Border.all(color: Colors.grey[600]!, width: 2)),
                        child: Center(
                            child: TextFormField(
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Input AX Amount"),
                        ))),
                    // Staking body container
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.3,
                        // column size container
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                //APY text
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Current Staked Balance:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                      Text("100 AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                //text2

                                //text3

                                //text4
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("+",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                      Text("150 AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),

                                //text5
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Funds Added",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 16,
                                          )),
                                      Text("(Amount) AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("New Staked Balance",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                      Text("(Sum) AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                    // staking row container
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      //width/height
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //Textbuttons
                          /** 
                                          TextButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          "Stake AX",
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        )
                                                        ),
                                              **/
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.amber[600],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber[600]!,
                                width: 2,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //mintConfirmDialog(context, athlete);
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]))),
    );

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  void unstakeDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 3,
            ),
          ),
          //child:Align(
          alignment: Alignment(0, -0.5),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Staking Position text
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.075,
                        child: Text(
                          "UNSTAKE",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.0),
                            border:
                                Border.all(color: Colors.grey[600]!, width: 2)),
                        child: Center(
                            child: TextFormField(
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Input AX Amount"),
                        ))),
                    // Staking body container
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.3,
                        // column size container
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                //APY text
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Current Staked Balance:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                      Text("100 AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                //text2

                                //text3

                                //text4
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("-",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                      Text("150 AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                //text5
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Funds removed",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 16,
                                          )),
                                      Text("(Amount) AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("New Staked Balance",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                      Text("(Difference) AX",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                    // staking row container
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      //width/height
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //Textbuttons
                          /** 
                                          TextButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          "Stake AX",
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        )
                                                        ),
                                              **/
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.amber[600],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber[600]!,
                                width: 2,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //mintConfirmDialog(context, athlete);
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]))),
    );

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  // Scout Mint Confirm Popup
  void mintConfirmDialog(BuildContext context, Athlete athlete) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Align(
          alignment: Alignment(0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 3,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Stack(children: <Widget>[
              // Mint approved text
              Align(
                  alignment: Alignment(0, -0.7),
                  child: Text("Mint Approved!",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ))),
              // text
              Align(
                  alignment: Alignment(0, -0.375),
                  child: Text("You will have receive:",
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, -0.05),
                  child: Text("20 Long " + athlete.name + " APTs",
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontFamily: 'OpenSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ))),
              // short tokens text
              Align(
                  alignment: Alignment(0, 0.2),
                  child: Text("20 Short " + athlete.name + " APTs",
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontFamily: 'OpenSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, 0.7),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Back to Scout",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ))))),
              // Top 'X'
              Align(
                // These values are based on trial & error method
                alignment: Alignment(0.92, -0.95),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  // Scout Redeem Popup
  void redeemDialog(BuildContext context, Athlete athlete) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Align(
          alignment: Alignment(0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 3,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Stack(children: <Widget>[
              // Mint Title
              Align(
                  alignment: Alignment(0, -0.9),
                  child: Text("REDEEM",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ))),
              // Athlete Name
              Align(
                  alignment: Alignment(0, -0.7),
                  child: Text(athlete.name + " APT",
                      style: TextStyle(
                        color: Colors.amber[600],
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ))),
              // APT Amount text box
              Align(
                  alignment: Alignment(0, -0.4),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.0),
                          border:
                              Border.all(color: Colors.grey[600]!, width: 2)),
                      child: Center(
                          child: TextFormField(
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Input APT Amount"),
                      )))),
              // iAPT Amount text box
              Align(
                  alignment: Alignment(0, 0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.0),
                          border:
                              Border.all(color: Colors.grey[600]!, width: 2)),
                      child: Center(
                          child: TextFormField(
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Input iAPT Amount"),
                      )))),
              // text
              Align(
                  alignment: Alignment(0, 0.3),
                  child: Text("You will receive:",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, 0.5),
                  child: Text("20 AX",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, 0.85),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            redeemConfirmDialog(context, athlete);
                          },
                          child: Text("Confirm",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ))))),
              // Top 'X'
              Align(
                // These values are based on trial & error method
                alignment: Alignment(0.92, -0.95),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  // Scout Redeem Confirm Popup
  void redeemConfirmDialog(BuildContext context, Athlete athlete) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Align(
          alignment: Alignment(0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 3,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Stack(children: <Widget>[
              // Mint approved text
              Align(
                  alignment: Alignment(0, -0.7),
                  child: Text("Redemption Approved!",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ))),
              // text
              Align(
                  alignment: Alignment(0, -0.325),
                  child: Text("You have received:",
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, 0.0),
                  child: Text("20 AX",
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontFamily: 'OpenSans',
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ))),
              // long tokens text
              Align(
                  alignment: Alignment(0, 0.7),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Back to Scout",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ))))),
              // Top 'X'
              Align(
                // These values are based on trial & error method
                alignment: Alignment(0.92, -0.95),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  // Scout Hint Popup
  void scoutHintDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 2,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Stack(children: <Widget>[
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Text("Welcome to the Scout page! This is where you can search Athlete Performance Tokens (APTs)" +
                      " and speculate on their performance.\n\nYou can also execute long/short orders and mint/redeem" +
                      " the APTs of your choice:\n\nLong: Loads a purchase for an APT on the Swap page.\n\nShort: " +
                      "Loads a purchase for an Inverse APT (iAPT) on the Swap page.\n\nMint: Allows you to mint APT and" +
                      " iAPT pairs.\n\nRedeem: Allows you to redeem APT and iAPT pairs for AX Coin.\n\nLearn more about" +
                      " these functions here.")),
              Align(
                // These values are based on trial & error method
                alignment: Alignment(0.92, -0.95),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  // Earn ListView
  Widget LPEarnListView(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.768,
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: earnRange[1],
            itemBuilder: (BuildContext context, int index) {
              // spacing
              return Container(
                width: MediaQuery.of(context).size.width * 0.256,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                    // Earn LP Container
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.236,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Stack(children: [
                          // Circle icons
                          Align(
                              alignment: Alignment(0, -0.7),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  // circle Icons
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      // AX icon
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.022,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.022,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.black),
                                      ),
                                      // APT icon
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.022,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.022,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.amber[600]),
                                      ),
                                    ],
                                  ))),
                          // Athlete APT Name
                          Align(
                              alignment: Alignment(0.0, -0.3),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  child: Text(
                                    "AX - " + curAthletes[index].name + " APT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ))),
                          // Small Text
                          Align(
                              alignment: Alignment(0, 0.275),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // Total APY
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Total APY",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                Text("20 %",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))
                                              ],
                                            )),
                                        // TVL
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("TVL",
                                                    style: TextStyle(
                                                      color: Colors.grey[200],
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                    )),
                                                Text("\$1,000,000",
                                                    style: TextStyle(
                                                      color: Colors.grey[200],
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                    ))
                                              ],
                                            )),
                                        // LP APY
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("LP APY",
                                                    style: TextStyle(
                                                      color: Colors.grey[200],
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                    )),
                                                Text("5 %",
                                                    style: TextStyle(
                                                      color: Colors.grey[200],
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                    ))
                                              ],
                                            )),
                                      ]))),
                          // Deposit Button
                          Align(
                              alignment: Alignment(0, 0.825),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.amber[600]),
                                  child: TextButton(
                                      onPressed: () => lpPopupDialog(
                                          context, curAthletes[index]),
                                      child: Text(
                                        "Deposit",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans',
                                          fontSize: 20,
                                        ),
                                      ))))
                        ]))),
              );
            }));
  }

  // LP Farm Popup
  void lpPopupDialog(BuildContext context, Athlete athlete) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(children: <Widget>[
          // Background
          Align(
            alignment: Alignment(0, 0.2),
            child: Container(
              width: MediaQuery.of(context).size.width * .4,
              height: MediaQuery.of(context).size.height * .85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
              ),
            ),
          ),
          // Athlete Title
          Align(
              alignment: Alignment(0, -0.75),
              child: Container(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Text(
                    "AX - " + athlete.name + " APT Farm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ))),
          // * Note text
          Align(
              alignment: Alignment(0, -0.60),
              child: Container(
                  child: Text(
                      "* Add liquidity to supply LP tokens to your account.\nDeposit LP tokens to earn \$AX rewards.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 8,
                          fontStyle: FontStyle.italic)))),
          // Earn, deposit: Top token box
          Align(
              alignment: Alignment(0, -0.4),
              child: Container(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.height * .1,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .1,
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .03,
                                height: MediaQuery.of(context).size.width * .03,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text("\$AX",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans',
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600)))
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text("0.00",
                                style: TextStyle(
                                    color: Colors.grey[350],
                                    fontFamily: 'OpenSans',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600)))
                      ]))),
          // Earn, deposit: Bottom token box
          Align(
              alignment: Alignment(0, -0.05),
              child: Container(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.height * .1,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .25,
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .03,
                                height: MediaQuery.of(context).size.width * .03,
                                decoration: BoxDecoration(
                                    color: Colors.amber[600],
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(athlete.name + " APT",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'OpenSans',
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600)))
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text("0.00",
                                style: TextStyle(
                                    color: Colors.grey[350],
                                    fontFamily: 'OpenSans',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600)))
                      ]))),
          // Add liquidity button
          Align(
              alignment: Alignment(0, 0.27),
              child: Container(
                  width: MediaQuery.of(context).size.width * .2,
                  height: MediaQuery.of(context).size.height * .075,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.amber[600]!,
                      width: 2,
                    ),
                  ),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Add Liquidity",
                        style: TextStyle(
                          color: Colors.amber[600],
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )))),
          // LP Tokens Text
          Align(
            alignment: Alignment(0, 0.46),
            child: Text(
              "LP Tokens: " + "10",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          // Deposit Liquidity button
          Align(
              alignment: Alignment(0, 0.7),
              child: Container(
                  width: MediaQuery.of(context).size.width * .2,
                  height: MediaQuery.of(context).size.height * .075,
                  decoration: BoxDecoration(
                    color: Colors.amber[600],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.amber[600]!,
                      width: 2,
                    ),
                  ),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Deposit Liquidity",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )))),
          // 'X' Button
          Align(
              alignment: Alignment(0.37, -0.82),
              child: Container(
                  width: 80,
                  height: 50,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close,
                          color: Colors.grey[400], size: 50)))),
        ]));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }
}
