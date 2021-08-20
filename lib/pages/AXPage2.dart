import 'dart:math';
import 'dart:html' as html;


// flutter format .

import 'package:ae_dapp/service/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ae_dapp/style/Style.dart';

_launchURL() async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    
    title: Text('Connect to a wallet',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.grey[400],
    fontFamily: 'OpenSans',
    )
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text('Install Metamask'),
                  ),
              ),
            onPressed: () {},
            style: walletButton,
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text('WalletConnect'),
                  ),
              ),
            onPressed: () {},
            style: walletButton,
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text('Coinbase Wallet'),
                  ),
              ),
            onPressed: () {},
            style: walletButton,
          ),
        ),


      ],
    ),
    
  );
}

class AXPage2 extends StatefulWidget {
  @override
  _AX2State createState() => _AX2State();
}

class _AX2State extends State<AXPage2> {
  TextEditingController stakeController = new TextEditingController();

  bool _swapNutrients = false;
  @override
  void initState() {
    super.initState();
  }

  Widget getMacroChart() {
    return Center(
      child: Text('macro chart here'),
    );
  }

  Widget getMicroChart() {
    return Center(
      child: Text('micro chart here'),
    );
  }

  // Actionable
  Future<void> buyAX() async {}
  Future<void> stakeAX() async {}
  Future<void> claimRewards() async {}
  Future<Widget> unstakeAX() async {
    return Text("Unclaimed Rewards: ");
  }

  var currentTotal = 0;
  var numNewAX = 0;

  // Viewable
  Future<int> totalBalance() async {
    currentTotal = new Random().nextInt(800);
    return currentTotal;
  }

  Future<int> totalBalanceStake(int numNewAX) async {
    return currentTotal + numNewAX;
  }

  Future<String> availableBalance() async {
    return "0";
  }

  Future<int> stakedAX() async {
    return Random().nextInt(200);
  }

  Future<int> getAPY() async {
    return Random().nextInt(200);
  }

  Future<int> rewardsEarned() async {
    return new Random().nextInt(200);
  }

  Future<int> UnclaimedRewards() async {
    return new Random(300).nextInt(200);
  }

  Widget build(BuildContext context) {
    const double lgTxSize = 52;
    const double mdTxSize = 35;
    const double smTxSize = 15;
    const double xsTxSize = 12;

    final ButtonStyle approveButton = ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontSize: smTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600),
        primary: Colors.grey[900],
        onPrimary: Colors.amber[600],
        fixedSize: Size(250, 75));

    final ButtonStyle claimButton = ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontSize: smTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600),
        primary: Colors.grey[800],
        onPrimary: Colors.amber[600],
        fixedSize: Size(250, 75));

    final ButtonStyle connectButton = ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontSize: xsTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w200),
        primary: Colors.blue[400],
        onPrimary: Colors.white,
        fixedSize: Size(250, 75));

    return Scaffold(
        body: Stack(
      children: <Widget>[
        // background image
        Image(
          image: AssetImage("assets/images/background.jpeg"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),

        // upper right logo
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image(
                width: 80,
                height: 80,
                image: AssetImage("assets/images/x.png"),
              ),
            )),

        // header
        Container(
            margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("AX",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: lgTxSize,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      )),
                ])),

        // main user area
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // my account info

            Column(
              children: [
                // Main Left Area
                Container(
                    margin: EdgeInsets.fromLTRB(0, 175, 0, 0),
                    alignment: Alignment.center,
                    height: 500,
                    width: 400,
                    color: Colors.grey[900],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      // Main Left Area
                      children: [
                        Column(
                          children: [
                            // My Account
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 45, 0, 20),
                              child: Text(
                                'My Account',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                  )
                                ),
                            ),

                            // Staked AX
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Staked AX: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Available AX
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Available AX: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Total AX
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Total AX: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // My Rewards
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: Text('My Rewards',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),

                            // APY
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'APY: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Rewards Earned
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Rewards Earned: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Unclaimed Rewards
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                'Unclaimed Rewards: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: SizedBox(
                                child: ElevatedButton(
                                  child: Text('CLAIM REWARDS'),
                                  onPressed: () {},
                                  style: claimButton,
                                ),
                                height: 50,
                                width: 250,
                              )),
                            
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: SizedBox(
                                child: ElevatedButton(
                                  child: Text('BUY AX'),
                                  onPressed: _launchURL,
                                  style: claimButton,
                                ),
                                height: 50,
                                width: 250,
                              )),
                          ],
                        )
                      ],
                    )),
              ],
            ),

            Column(
              children: [
                //Main Right Area
                Container(
                    margin: EdgeInsets.fromLTRB(0, 175, 0, 0),
                    alignment: Alignment.center,
                    height: 500,
                    width: 500,
                    color: Colors.grey[800],

                    // My Liquidity Area
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          
                          child: Column(
                          children: [
                            // My Liquidity
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 45, 0, 10),
                                child: Text('My Liquidity',
                                    style: TextStyle(
                                      fontSize: mdTxSize,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w600,
                                    ))),

                            // adding note
                            Container(
                                child: Column(
                              children: [
                                // Add liquidity tag
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text('Add liquidity to stake AX',
                                        style: TextStyle(
                                          fontSize: xsTxSize,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w200,
                                        ))),

                                // remove note
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                                    child:
                                        Text('Remove liquidity to receive AX',
                                            style: TextStyle(
                                              fontSize: xsTxSize,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w200,
                                            ))),

                                Container(
                                  child: Row(
                                  children: [
                                    Column(children: [
                                      ToggleSwitch(
                                        minWidth: 75.0,
                                        minHeight: 30.0,
                                        fontSize: xsTxSize,
                                        activeBgColor: [(Colors.grey[800])!],
                                        activeFgColor: Colors.amber[600],
                                        inactiveBgColor: Colors.grey[800],
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex: 0,
                                        totalSwitches: 2,
                                        labels: ['STAKE', 'UNSTAKE'],
                                        onToggle: (index) {
                                        },
                                      ),
                                    ],),

                                  Column(children: [
                                      ToggleSwitch(
                                        borderColor: [(Colors.grey[800])!],
                                        minWidth: 50.0,
                                        minHeight: 30.0,
                                        fontSize: xsTxSize,
                                        activeBgColor: [(Colors.grey[800])!],
                                        activeFgColor: Colors.amber[600],
                                        inactiveBgColor: Colors.grey[800],
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex: 0,
                                        totalSwitches: 4,
                                        labels: ['25%', '50%', '75%', 'MAX'],
                                        onToggle: (index) {
                                        },
                                      ),
                                    ],),

                                    
                                  ],
                                )),

                                // text field box
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: ConstrainedBox(
                                    constraints:BoxConstraints.tight(Size(350, 60)),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[900],
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: (Colors.amber[600])!,
                                              width: 3.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: (Colors.grey[900])!,
                                              width: 3.0,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(),
                                          hintText:
                                              'Enter the amount of AX to stake'),
                                    ),
                                  ),
                                ),

                                // Approve button
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        child: const Text('APPROVE'),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => _buildPopupDialog(context),
                                          );},
                                        style: approveButton,
                                      ),
                                      height: 50,
                                      width: 350,
                                    )),
                                
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        child: const Text('Connect to a wallet'),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => _buildPopupDialog(context),
                                          );
                                        },
                                        style: connectButton,
                                      ),
                                      height: 50,
                                      width: 350,
                                    ))
                              ],
                            )),
                          ],
                        ))
                      ],
                    )),
              ],
            )
          ],
        )),
      ],
    ));
  }
}
