import 'dart:html';

import 'package:flutter/material.dart';

class AXPage extends StatefulWidget {
  @override
  _AXState createState() => _AXState();
}

class _AXState extends State<AXPage> {

  Widget build(BuildContext context) {

    double lgTxSize = 52;
    double smTxSize = 20;
    // Column
      // Row
        // AX
        // X
      // Container
        // Row
          // Column
            // My Account
            // ...
          // Column
            // My Awards
            // ...
      // Container
        // Row
          // Column
            // Buy AX
            // Stake AX
          // Column
            // Claim Rewards
            // Unstake AX

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/background.jpeg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Image(
                    width: 80,
                    height: 80,
                    image: AssetImage("assets/images/x.png"),
                  ),
                )
              ),
              Text(
                "AX",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: lgTxSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "My Account",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: lgTxSize,
                                fontWeight: FontWeight.w600
                              )
                            )
                          ),
                          Text(
                            "AX Total Balance: ",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: smTxSize,
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "AX Available Balance: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: smTxSize,
                              )
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "AX Staked: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: smTxSize,
                              )
                            )
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "My Rewards",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: lgTxSize,
                                fontWeight: FontWeight.w600,
                              )
                            )
                          ),
                          Text(
                            "APY: ",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: smTxSize,
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Rewards Earned: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: smTxSize,
                              )
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Unclaimed Rewards: ",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: smTxSize,
                              )
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                  // color: Colors.grey[900],
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(width: 250, height: 55),
                                child: ElevatedButton(
                                child: Text(
                                  "BUY AX",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: smTxSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )
                                ),
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[400]!),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.amber[400]!),
                                    )
                                  )
                                ),
                              )
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(width: 250, height: 55),
                                child: ElevatedButton(
                                child: Text(
                                  "STAKE AX",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: smTxSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber[400],
                                  )
                                ),
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.amber[400]!),
                                    )
                                  )
                                ),
                              )
                            )
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(width: 250, height: 55),
                                child: ElevatedButton(
                                child: Text(
                                  "CLAIM REWARDS",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: smTxSize,
                                    color: Colors.white,
                                  )
                                ),
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[400]!),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.amber[400]!),
                                    )
                                  )
                                ),
                              )
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(width: 250, height: 55),
                                child: ElevatedButton(
                                child: Text(
                                  "UNSTAKE AX",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: smTxSize,
                                    color: Colors.amber[400],
                                  )
                                ),
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.amber[400]!),
                                    )
                                  )
                                ),
                              )
                            )
                          ),
                        ],
                      )
                    ]
                  )
                )
              ),
            ]
          )

        ],
      )
    );
  }
}