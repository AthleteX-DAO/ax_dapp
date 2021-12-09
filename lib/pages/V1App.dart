import 'package:flutter/material.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:flutter/rendering.dart';

class V1App extends StatefulWidget {
  @override
  _V1AppState createState() => _V1AppState();
}

class _V1AppState extends State<V1App> {
  int pageNumber = 0;
	int cardState = 0;
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
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                    )
                  ),
                  Text(
                    "|",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "ALL",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "NFL",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "NBA",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        )
                      ),
                    )
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "MMA",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
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
                  width: 175,
                  child: Text(
                    "Athlete",
                    style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400]
                    )
                  )
                ),
                Container(
                  width: 125,
                  child: Text(
                    "Team",
                    style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400]
                    )
                  )
                ),
                Container(
                  width: 150,
                  child: Text(
                    "Market Price / Change",
                    style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400]
                    )
                  )
                ),
                Container(
                  width: 150,
                  child: Text(
                    "Book Value / Change",
                    style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400]
                    )
                  )
                ),
              ]
            ),
            // ListView of Athletes
            Container(
              height: 385,
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
                  style: textStyle(Colors.white, 16, false)
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
                                              style: textStyle(Colors.white, 14, true),
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
                                          style: textStyle(Colors.grey[400]!, 12, false)
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
                            width: 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "AX",
                                  style: textStyle(Colors.white, 16, true)
                                ),
                                Text(
                                  "v",
                                  style: textStyle(Colors.white, 16, true)
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
                              height: 18,
                              width: 35,
                              decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "MAX",
                                  style: textStyle(Colors.grey[400]!, 7, false)
                                )
                              )
                            ),
                            Text(
                              "0.00",
                              style: textStyle(Colors.grey[400]!, 22, false)
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
                          style: textStyle(Colors.grey[400]!, 22, false)
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
                          style: textStyle(Colors.amber[400]!, 16, true),
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
                          style: textStyle(Colors.black, 16, true),
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
        height: MediaQuery.of(context).size.height/4,
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
            ]
          ),
        )
      )
    );
  }

  Widget topNavBar(BuildContext context) {
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
                      setState(() {
                        pageNumber = 0;
                      });
                    },
                    child: Text(
                      "Scout",
                      style: textStyle(Colors.white, 22, true),
                    )
                  )
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        pageNumber = 1;
                      });
                    },
                    child: Text(
                      "Trade",
                      style: textStyle(Colors.white, 22, true),
                    )
                  )
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        pageNumber = 2;
                      });
                    },
                    child: Text(
                      "Farm",
                      style: textStyle(Colors.white, 22, true),
                    )
                  )
                ),
              ]
            )
          ),
          // top Connect Wallet Button
          Container()
        ],
      ),
    );
  }

  Widget createFarmWidget(String farmName) {
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
									style: TextStyle(
										fontSize: 28,
										color: Colors.white
									)
								)
							),
							// '|' Symbol
							Container(
								width: 50,
								alignment: Alignment.center,
								child: Text(
									"|",
									style: TextStyle(
										fontSize: 24,
										color: Colors.grey[500]
									)
								)
							),
							Container(
								child: Text(
									"Seasonal APT",
									style: TextStyle(
										fontSize: 24,
										color: Colors.grey[500]
									)
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
																		style: TextStyle(
																			fontSize: 20,
																			color: Colors.black
																		)
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
																		style: TextStyle(
																			fontSize: 20,
																			color: Colors.black
																		)
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
																		style: TextStyle(
																			fontSize: 20,
																			color: Colors.white
																		)
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
                                    MediaQuery.of(context).size.height*0.45,
                                    MediaQuery.of(context).size.width*(2/7),
                                    boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                                    Column (
                                      
                                    ),
                                  ),
																	child: Text(
																		"Redeem",
																		style: TextStyle(
																			fontSize: 20,
																			color: Colors.white
																		)
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
																	style: TextStyle(
																		fontSize: 24,
																		color: Colors.white
																	)
																)
															),
															Container(
																width: MediaQuery.of(context).size.width*0.1,
																alignment: Alignment.bottomLeft,
																child: Text(
																	"Current",
																	style: TextStyle(
																		fontSize: 14,
																		color: Colors.grey[400]
																	)
																)
															),
															Container(
																alignment: Alignment.bottomRight,
																width: MediaQuery.of(context).size.width*0.075,
																child: Text(
																	"All-Time High",
																	style: TextStyle(
																		fontSize: 14,
																		color: Colors.grey[400]
																	)
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
																	style: TextStyle(
																		color: Colors.grey[400],
																		fontSize: 20
																	)
																)
															),
															Container(
																width: MediaQuery.of(context).size.width*0.1,
																child: Row(
																	mainAxisAlignment: MainAxisAlignment.start,
																	children: <Widget>[
																		Text(
																			"4.18 AX ",
																			style: TextStyle(
																				fontSize: 20,
																				color: Colors.white,
																			)
																		),
																		Container(
																			//alignment: Alignment.topLeft,
																			child: Text(
																				"-2%",
																				style: TextStyle(
																					fontSize: 12,
																					color: Colors.red,
																				)
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
																	style: TextStyle(
																		fontSize: 20,
																		color: Colors.grey[400],
																	)
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
																	style: TextStyle(
																		color: Colors.grey[400],
																		fontSize: 20
																	)
																)
															),
															Container(
																width: MediaQuery.of(context).size.width*0.1,
																child: Row(
																	mainAxisAlignment: MainAxisAlignment.start,
																	children: <Widget>[
																		Text(
																			"4.24 AX ",
																			style: TextStyle(
																				fontSize: 20,
																				color: Colors.white,
																			)
																		),
																		Container(
																			//alignment: Alignment.topLeft,
																			child: Text(
																				"+4%",
																				style: TextStyle(
																					fontSize: 12,
																					color: Colors.red,
																				)
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
																	style: TextStyle(
																		fontSize: 20,
																		color: Colors.grey[400],
																	)
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
															style: TextStyle(
																fontSize: 24,
																color: Colors.white
															)
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
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															),
															Text(
																"American Football / NFL",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															)
														]
													),
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: <Widget>[
															Text(
																"Team",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															),
															Text(
																"Tampa Bay Buckaneers",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															)
														]
													),
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: <Widget>[
															Text(
																"Position",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															),
															Text(
																"Quarterback",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															)
														]
													),
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: <Widget>[
															Text(
																"Season Start",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															),
															Text(
																"Sep 1, 2021",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															)
														]
													),
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: <Widget>[
															Text(
																"Season End",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
															),
															Text(
																"Jan 10, 2022",
																style: TextStyle(
																	color: Colors.grey[400],
																	fontSize: 20
																)
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
																		style: TextStyle(
																			fontSize: 24,
																			color: Colors.white
																		)
																	),
																),
																Container(
																	width: 75,
																	alignment: Alignment.bottomLeft,
																	child: Text(
																		"TD",
																		style: TextStyle(
																			fontSize: 14,
																			color: Colors.grey[400]
																		)
																	),
																),
																Container(
																	width: 75,
																	alignment: Alignment.bottomLeft,
																	child: Text(
																		"Cmp",
																		style: TextStyle(
																			fontSize: 14,
																			color: Colors.grey[400]
																		)
																	),
																),
																Container(
																	width: 100,
																	alignment: Alignment.bottomLeft,
																	child: Text(
																		"Cmp %",
																		style: TextStyle(
																			fontSize: 14,
																			color: Colors.grey[400]
																		)
																	),
																),
																Container(
																	alignment: Alignment.bottomLeft,
																	child: Text(
																		"YDS",
																		style: TextStyle(
																			fontSize: 14,
																			color: Colors.grey[400]
																		)
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
																	style: TextStyle(
																		fontSize: 16,
																		color: Colors.grey[400]
																	)
																),
															),
															Container(
																width: 75,
																alignment: Alignment.bottomLeft,
																child: Text(
																	"12",
																	style: TextStyle(
																		fontSize: 16,
																		color: Colors.grey[400]
																	)
																),
															),
															Container(
																width: 75,
																alignment: Alignment.bottomLeft,
																child: Text(
																	"24",
																	style: TextStyle(
																		fontSize: 16,
																		color: Colors.grey[400]
																	)
																),
															),
															Container(
																width: 100,
																alignment: Alignment.bottomLeft,
																child: Text(
																	"80%",
																	style: TextStyle(
																		fontSize: 16,
																		color: Colors.grey[400]
																	)
																),
															),
															Container(
																alignment: Alignment.bottomLeft,
																child: Text(
																	"2,000",
																	style: TextStyle(
																		fontSize: 16,
																		color: Colors.grey[400]
																	)
																),
															),
														]
													),
													Container(
														alignment: Alignment.centerLeft,
														child: Text(
															"View All Stats",
															style: TextStyle(
																color: Colors.amber[400],
																fontSize: 16,
																decoration: TextDecoration.underline,
															)
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
                        style: textStyle(Colors.white, 14, true),
                      )
                    ),
                    Container(
                      width: 125,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fullName,
                        style: textStyle(Colors.grey[100]!, 9, false),
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
				  width: 175,
				  child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
					  Text(
						athName,
						style: TextStyle(
						  fontSize: 18,
						  color: Colors.white
						)
					  ),
					  Text(
						"Quarterback",
						style: TextStyle(
						  fontSize: 10,
						  color: Colors.grey[700]
						)
					  )
					]
				  )
				),
				// Team
				Container(
				  width: 125,
				  child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
					  Text(
						"Tampa Bay",
						style: TextStyle(
						  fontSize: 18,
						  color: Colors.grey[700]
						)
					  ),
					  Text(
						"Buckaneers",
						style: TextStyle(
						  fontSize: 10,
						  color: Colors.grey[700]
						)
					  )
					]
				  )
				),
				// Market Price
				Container(
				  width: 150,
				  child: Row(
					children: <Widget>[
					  Text(
						"\$0.0422",
						style: TextStyle(
						  fontSize: 16,
						  color: Colors.white
						)
					  ),
					  Text(
						"+%4",
						style: TextStyle(
						  fontSize: 12,
						  color: Colors.green
						)
					  )
					]
				  )
				),
				// Book Price
				Container(
				  width: 150,
				  child: Row(
					children: <Widget>[
					  Text(
						"\$0.0412",
						style: TextStyle(
						  fontSize: 16,
						  color: Colors.white
						)
					  ),
					  Text(
						"-%2",
						style: TextStyle(
						  fontSize: 12,
						  color: Colors.red
						)
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black
                      )
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      )
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

  TextStyle textStyle(Color color, double size, bool isBold) {
    if (isBold)
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }
}