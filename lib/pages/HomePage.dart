import 'dart:html';
import 'dart:js';

import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/pages/ScoutPage.dart';
import 'package:ae_dapp/pages/DexPage.dart';
import 'package:ae_dapp/pages/HelpPage.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:webfeed/domain/media/media.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  var swap = true;
  List<Athlete> athleteList = [];
  List<Athlete> nflList = [];
  List<Athlete> otherList = [];
  bool firstRun = true;
  double filterText = 20;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child:
                Image(image: AssetImage('../assets/images/x.png'), height: 40),
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
                onPressed: () {},
              ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
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
                          onPressed: () {},
                        )),
                  )
                ],
                backgroundColor: Colors.black,
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('../assets/images/axBackground.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            _mobileHeader(context),
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
                                                .8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(children: [
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .85,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .78,
                                                    color: Colors.red)
                                              ]),
                                            ]),
                                      )
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
                              AssetImage('../assets/images/axBackground.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            _mobileHeader(context),
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
                                                .8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 3,
                                          ),
                                        ),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .24,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .1,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.black,
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 3,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .1,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                .07,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  dexToggleActive,
                                                              onPressed: () {
                                                                swap = true;
                                                              },
                                                              child:
                                                                  Text('Swap'),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .1,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                .07,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  dexToggleInactive,
                                                              onPressed: () {
                                                                swap = false;
                                                              },
                                                              child:
                                                                  Text('Earn'),
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              )
                                            ]),
                                      )
                                    ]))
                          ])));
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
                              AssetImage('../assets/images/axBackground.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            _mobileHeader(context),
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
                                                .8,
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
                              AssetImage('../assets/images/axBackground.png'),
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
                                            width: 3,
                                          ),
                                        ),
                                          child: Stack(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment(-0.55, -0.96),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width*0.7,
                                                  child: Row(
                                                    children: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          setState((){
                                                            athleteList=nflList;
                                                            firstRun = false;
                                                          });
                                                        },
                                                        child: Text(
                                                          "NFL",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'OpenSans',
                                                            fontSize: filterText,                                            
                                                          ),
                                                        )
                                                      ),
                                                      TextButton(
                                                        onPressed: ()   {
                                                          setState((){
                                                            athleteList=[];
                                                            firstRun = false;
                                                          });

                                                        },
                                                        child: Text(
                                                          "NBA",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'OpenSans',
                                                            fontSize: filterText,                                            
                                                          ),
                                                        )
                                                      ),
                                                      TextButton(
                                                        onPressed: ()  {
                                                          setState((){
                                                            athleteList=[];
                                                            firstRun = false;
                                                          });
                                                        },
                                                        child: Text(
                                                          "MMA",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'OpenSans',
                                                            fontSize: filterText,                                            
                                                          ),
                                                        )
                                                      ),
                                                    ],
                                                  )
                                                )
                                              ),
                                              Align(
                                                alignment: Alignment(0, 0),
                                                child: FutureBuilder<dynamic>(
                                                  future: AthleteApi.getAthletesLocally(context),
                                                  builder:(context, snapshot) {
                                                    switch (snapshot.connectionState) {
                                                      case ConnectionState.waiting:
                                                        // return circle indicator for progress
                                                        return Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      default:
                                                        nflList = snapshot.data;
                                                        if (firstRun)
                                                          athleteList = nflList;
                                                        return Container(
                                                          height: MediaQuery.of(context).size.height * 0.65,
                                                          width: MediaQuery.of(context).size.width * 0.8,
                                                          child: ListView.builder(
                                                            physics: BouncingScrollPhysics(),
                                                            itemCount: athleteList.length,
                                                            itemBuilder: (context, index) {
                                                              final athlete = athleteList[index];
                                                              return Card(
                                                                color: Colors.grey[900],
                                                                shadowColor: Colors.grey[900],
                                                                child: ListTile(
                                                                  title: Text(athlete.name)
                                                                )
                                                              );
                                                            }
                                                          )
                                                        );
                                                    }
                                                  }
                                                )
                                              ),
                                              Align(
                                                alignment: Alignment(.97, 0.92),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 23,
                                                  height: 23,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                      color: Colors.amber[600]!,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () => scoutHintDialog(context),
                                                    child: Text(
                                                      '?',
                                                      style: TextStyle(
                                                        color: Colors.amber[600],
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  )
                                                )
                                              )
                                            ]
                                          ),
                                        ),
                                      ]
                                    )
                                  )
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
                              AssetImage('../assets/images/axBackground.png'),
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
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Main mobile border box
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .9,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .79,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 3,
                                                ),
                                              ),
                                            ),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      // Swap and earn button container
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .24,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .1,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.black,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 3,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              // Swap Button
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .1,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .07,
                                                                child:
                                                                    ElevatedButton(
                                                                  style:
                                                                      dexToggleActive,
                                                                  onPressed:
                                                                      () {
                                                                    swap = true;
                                                                  },
                                                                  child: Text(
                                                                      'Swap'),
                                                                ),
                                                              ),
                                                              // Earn button
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .1,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .07,
                                                                child:
                                                                    ElevatedButton(
                                                                  style:
                                                                      dexToggleInactive,
                                                                  onPressed:
                                                                      () {
                                                                    swap =
                                                                        false;
                                                                  },
                                                                  child: Text(
                                                                      'Earn'),
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                    ],
                                                  )
                                                ]),
                                          ]),
                                    ]))
                          ])));
            }
            // Help page
            else {
              return Text('empty');
            }
          }
        }));
  }


  void scoutHintDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Align(alignment: Alignment.bottomRight, child: Container(
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
            child: Text(
              "Welcome to the Scout page! This is where you can search Athlete Performance Tokens (APTs)" +
              " and speculate on their performance.\n\nYou can also execute long/short orders and mint/redeem" +
              " the APTs of your choice:\n\nLong: Loads a purchase for an APT on the Swap page.\n\nShort: " +
              "Loads a purchase for an Inverse APT (iAPT) on the Swap page.\n\nMint: Allows you to mint APT and" +
              " iAPT pairs.\n\nRedeem: Allows you to redeem APT and iAPT pairs for AX Coin.\n\nLearn more about" +
              " these functions here."
            )
          ),
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
      ),)
    );

    showDialog(context: context, builder: (BuildContext context) => fancyDialog);
  }
}
