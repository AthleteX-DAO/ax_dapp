import 'dart:ui';
import 'package:ae_dapp/service/WarTimeSeries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart' as series;

class V1App extends StatefulWidget {
  @override
  _V1AppState createState() => _V1AppState();
}

class _V1AppState extends State<V1App> {
  int pageNumber = 0;
	int cardState = 0;
  int sportState = 0;
	String cardName = "";


  @override
  Widget build(BuildContext context) {
    Widget pageWidget = buildDesktop(context);
    return pageWidget;
  }

  Widget buildDesktop(BuildContext context) {
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
                AssetImage('../assets/images/axBackground.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (pageNumber == 0)
              desktopScout(context)
            else if (pageNumber == 1)
              desktopTrade(context)
            else if (pageNumber == 2)
              desktopFarm(context)
          ],
        )
      )
    );
  }

  Widget desktopScout(BuildContext context) {
    double sportFilterTxSz = 18;

    if (cardState != 1)
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.9,
          width: MediaQuery.of(context).size.width*0.85,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // APT Title & Sport Filter
            Container(
              width: MediaQuery.of(context).size.width*0.4,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "APT List",
                    style: textStyle(Colors.white, 18, false, false)
                  ),
                  Text(
                    "|",
                    style: textStyle(Colors.white, 18, false, false)
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        if (sportState != 0) setState(() {sportState = 0;});
                      },
                      child: Text(
                        "ALL",
                        style: textSwapState(
                          sportState == 0,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {if (sportState != 1) setState(() {sportState = 1;});},
                      child: Text(
                        "NFL",
                        style: textSwapState(
                          sportState == 1,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {if (sportState != 2) setState(() {sportState = 2;});},
                      child: Text(
                        "NBA",
                        style: textSwapState(
                          sportState == 2,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {if (sportState != 3) setState(() {sportState = 3;});},
                      child: Text(
                        "MMA",
                        style: textSwapState(
                          sportState == 3,
                          textStyle(Colors.white, sportFilterTxSz, false, false),
                          textStyle(Colors.amber[400]!, sportFilterTxSz, false, true)
                        )
                      ), 
                    )
                  ),        
                ]
              ),
            ),
            // List Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 66
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Text(
                    "Athlete",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Text(
                    "Team",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Text(
                    "Market Price / Change",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Text(
                    "Book Value / Change",
                    style: textStyle(Colors.grey[400]!, 12, false, false)
                  )
                ),
              ]
            ),
            // ListView of Athletes
            Container(
              height: MediaQuery.of(context).size.height*0.6,
              child: ListView(
                  children: <Widget>[
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Joe Mann"),
                    createAthleteCards("Leaf Thomas"),
                    createAthleteCards("Bob Dylan"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                    createAthleteCards("Tom Brady"),
                  ]
                )
              )
            ]
          )
        )
      );
    else 
      return athleteCardView(cardName);
  }

  Widget desktopTrade(BuildContext context) {
    double wid = 550;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // spacing bar to get swap to middle of screen
        Container(
          height: 125,
        ),
        Container(
          height: 350,
          width: wid,
          decoration: BoxDecoration(
            color: Colors.grey[800]!.withOpacity(0.6),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 0.5
            )
          ),
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
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5
                  )
                ),
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
                        child: TextButton(
                          onPressed: () => dialog(
                            context,
                            MediaQuery.of(context).size.height*.80,
                            MediaQuery.of(context).size.width/3,
                            boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // column of elements
                                Container(
                                  height: MediaQuery.of(context).size.height*.75,
                                  width: MediaQuery.of(context).size.width*.3,
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
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5
                  )
                ),
                child: Container(
                  width: wid-100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // dropdown
                      Container(
                        width: 125,
                        height: 40,
                        decoration: boxDecoration(Colors.blue, 100, 0, Colors.blue),
                        
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
        )
      ],
    );
  }

  Widget desktopFarm(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width*0.8,
        height: MediaQuery.of(context).size.height*0.3+100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Participating Farms",
                style: textStyle(Colors.white, 20, true, false)
              )
            ),
            Container(
              width: 200,
              height: 40,
              decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
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
            width: MediaQuery.of(context).size.width*.4,
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
          Container()
        ],
      ),
    );
  }

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition)
      return tru;
    return fls;
  }

  Widget createFarmWidget(String farmName) {
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Container(
      height: MediaQuery.of(context).size.height/4,
      width: MediaQuery.of(context).size.width/3,
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
                style: textStyle(Colors.white, 20, false, false)
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

  Widget athleteCardView(String athlete) {
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
									onPressed: () {
										setState(() {
											cardState = 0;
											cardName = "";
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
									athlete,
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
																	onPressed: () => dialog(
                                    context,
                                    MediaQuery.of(context).size.height*0.6,
                                    MediaQuery.of(context).size.width*(2/7),
                                    boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                                    Column (
                                      
                                    ),
                                  ),
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
																	onPressed: () => dialog(
                                    context,
                                    MediaQuery.of(context).size.height*0.6,
                                    MediaQuery.of(context).size.width*(2/7),
                                    boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                                    Column (
                                      
                                    ),
                                  ),
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
																	onPressed: () => dialog(
                                    context,
                                    MediaQuery.of(context).size.height*0.45,
                                    MediaQuery.of(context).size.width*(2/7),
                                    boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                                    Column (
                                      
                                    ),
                                  ),
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
																	onPressed: () => dialog(
                                    context, 
                                    MediaQuery.of(context).size.height*0.55, 
                                    MediaQuery.of(context).size.width*.25, 
                                    boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                                    Container(
                                      //color: Colors.blue,
                                      padding: const EdgeInsets.all(20.0),
                                      margin: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // Redeem athlete APT and Close button
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Redeem "+athlete+" APT",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white
                                                    ),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Sushiswap Text
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "You can redeem APT's at their Book Value for AX.", style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                                                        TextSpan(text: "You can access other funds with AX on the Matic network through", style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                                                        TextSpan(text: " SushiSwap", style: TextStyle(color: Colors.amber[400], fontSize: 15)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Input AX Text (no user input)
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Input AX:",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          // Input AX (user input)
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: 400,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(14.0),
                                              border: Border.all(
                                                color: Colors.grey[400]!,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    athlete+" APT",
                                                    style: textStyle(Colors.white, 15, false, false),
                                                  ),
                                                ),
                                                
                                                Container(
                                                  height: 18,
                                                  width: 35,
                                                  decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "Max",
                                                      style: textStyle(Colors.grey[400]!, 9, false, false),
                                                    ),
                                                  ),
                                                ),
                                                // Textfield
                                                SizedBox(
                                                  width: 70,
                                                  child: TextField(
                                                    style: textStyle(Colors.grey[400]!, 22, false, false),                                                                      
                                                    decoration: InputDecoration(
                                                      hintText: '0.00',
                                                      hintStyle: textStyle(Colors.grey[400]!, 22, false, false),
                                                      contentPadding: const EdgeInsets.all(9),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Horizontal Divider
                                          Container(
                                            child: Divider(
                                              thickness: 0.35,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "You recieve:",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "120 AX",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Confirm Button
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                //padding: EdgeInsets.all(20.0),
                                                width: 175,
                                                height:50,
                                                decoration: BoxDecoration(
                                                  color: Colors.amber[400],
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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

  Widget buildGraph(List war, List time, BuildContext context) {
    // local variables
    List<series.Series<dynamic, DateTime>> athleteData ;
    DateTime curTime = DateTime(-1);
    DateTime lastHour = DateTime(-1);
    DateTime maxTime = DateTime(-1);
    List<WarTimeSeries> data = [];

    for(int i = 0; i < war.length; i++) {
      curTime = DateTime.parse(time[i]);
      // only new points
        if (lastHour.year == -1 || (lastHour.isBefore(curTime) && curTime.hour != lastHour.hour)) {
          lastHour = curTime;
          // sets maximum if latest time
          if (maxTime == DateTime(-1)  || maxTime.isBefore(curTime))
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

  // Athlete Cards
  Widget createAthleteCards(String athName) {
    return Container(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            cardState = 1;
            cardName = athName;
          });
			  },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Icon
                Container(
                  width: 50,
                  child: Icon(
                    Icons.sports_football,
                    color: Colors.grey[700]
                  )
                ),
                // Athlete Name
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                      athName,
                        style: textStyle(Colors.white, 18, false, false)
                      ),
                      Text(
                        "Quarterback",
                        style: textStyle(Colors.grey[700]!, 10, false, false)
                      )
                    ]
                  )
                ),
                // Team
                Container(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tampa Bay",
                        style: textStyle(Colors.white, 18, false, false)
                      ),
                      Text(
                      "Buckaneers",
                      style: textStyle(Colors.grey[700]!, 10, false, false)
                      )
                    ]
                  )
                ),
                // Market Price
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Row(
                  children: <Widget>[
                    Text(
                    "\$0.0422",
                    style: textStyle(Colors.white, 16, false, false)
                    ),
                    Text(
                    "+%4",
                    style: textStyle(Colors.green, 12, false, false)
                    )
                  ]
                  )
                ),
                // Book Price
                Container(
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "\$0.0412",
                        style: textStyle(Colors.white, 16, false, false)
                      ),
                      Text(
                        "-%2",
                        style: textStyle(Colors.green, 12, false, false)
                      )
                    ]
                  )
                ),
              ]
            ),
            Row(
              children: <Widget>[
                // Buy
            Container(
              width: 100,
              height: 30,
                  decoration: BoxDecoration(
                    color: Colors.amber[400],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Buy",
                      style: textStyle(Colors.black, 16, false, false)
                    )
                  )
                ),
                Container(
                  width: 25
                ),
                // Mint
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Mint",
                      style: textStyle(Colors.white, 16, false, false)
                    )
                  )
                )
              ]
            )
          ]
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
}