import 'dart:math';

import 'package:ae_dapp/service/colors.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
    const double smTxSize = 20;
    const double xsTxSize = 12;

    final ButtonStyle approveButton =
        ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontSize: smTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600),
          primary: Colors.grey[900],
          onPrimary: Colors.amber[600],
          fixedSize: Size(250, 75)
          );

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

            Column( children: [
              // Main Left Area
              Container(

                margin: EdgeInsets.fromLTRB(0, 175, 0, 0),
                alignment: Alignment.center,
                height:500,
                width: 400,
                color:Colors.grey[900],
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  // Main Left Area
                  children: [
                    Column(children: [
                      
                      // My Account
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 45, 0, 20),
                        child:
                          Text('My Account',
                            style: TextStyle(
                              fontSize: mdTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w600,
                              )
                            ),
                        ),

                      // Staked AX
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child:
                          Text('Staked AX: ',
                            style: TextStyle(
                              fontSize: smTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w400,
                              ),
                            ),
                        ),

                      // Available AX
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child:
                          Text('Available AX: ',
                            style: TextStyle(
                              fontSize: smTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w400,
                              ),
                            ),
                        ),

                      // Total AX
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child:
                          Text('Total AX: ',
                            style: TextStyle(
                              fontSize: smTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w400,
                              ),
                            ),
                        ),
                      
                      // My Rewards
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 45, 0, 20),
                        child:
                          Text('My Rewards',
                            style: TextStyle(
                              fontSize: mdTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w600,
                              )
                            ),
                        ),

                      // APY
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child:
                          Text('APY: ',
                            style: TextStyle(
                              fontSize: smTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w400,
                              ),
                            ),
                        ),

                      // Rewards Earned
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child:
                          Text('Rewards Earned: ',
                            style: TextStyle(
                              fontSize: smTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w400,
                              ),
                            ),
                        ),

                      // Unclaimed Rewards
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child:
                          Text('Unclaimed Rewards: ',
                            style: TextStyle(
                              fontSize: smTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w400,
                              ),
                            ),
                        ),


                    ],)
                  ],

                  )
              ),
            ],),

            Column(children: [

              //Main Right Area
              Container(
                margin: EdgeInsets.fromLTRB(0, 175, 0, 0),
                alignment: Alignment.center,
                height:500,
                width: 500,
                color:Colors.grey[800],
                
                // My Liquidity Area
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      child: Column(children: [
                        // My Liquidity
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 45, 0, 10),
                          child: Text('My Liquidity',
                            style: TextStyle(
                              fontSize: mdTxSize,
                              fontFamily: 'OpenSans',
                              fontWeight:FontWeight.w600,
                              ))
                        ),
                        
                        // adding note
                        Container(
                          child: Column(children: [
                              
                              // Add liquidity tag
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text('Add liquidity to stake AX',
                                  style: TextStyle(
                                    fontSize: xsTxSize,
                                    fontFamily: 'OpenSans',
                                    fontWeight:FontWeight.w200,
                                    ))
                              ),
                              
                              // remove note
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text('Remove liquidity to receive AX',
                                  style: TextStyle(
                                    fontSize: xsTxSize,
                                    fontFamily: 'OpenSans',
                                    fontWeight:FontWeight.w200,
                                    ))
                              ),

                              Container(
                                child: Row(children: [
                                  
                                  Column(children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(16.0),
                                          primary: Colors.white,
                                          textStyle: const TextStyle(fontSize: 20),
                                        ),
                                        onPressed: () {},
                                        child: const Text('Stake'),
                                      ),)
                                  ],),

                                  Column(children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(16.0),
                                          primary: Colors.white,
                                          textStyle: const TextStyle(fontSize: 20),
                                        ),
                                        onPressed: () {},
                                        child: const Text('Unstake'),
                                      ),)
                                  ],),

                                ],)
                              ),
                      
                              // text field box
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(350, 60)),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[900],
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: (Colors.amber[600])!,
                                          width: 3.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: (Colors.grey[900])!,
                                          width: 3.0,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(),
                                      hintText: 'Enter the amount of AX to stake'
                                    ),
                                  ),
                                ),
                              ),

                              // Approve button
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: SizedBox(
                                  child: ElevatedButton(
                                    child: const Text('APPROVE'),
                                    onPressed: () {},
                                    style: approveButton,
                                    ),
                                  height: 50,
                                  width: 350,
                                  )
                                )
               
                          ],)
                        ),

                      ],)
                    )

                ],)

              ),
            ],)
          
          ],)
        ),


      ],
    ));
  }
}
