import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Singleton.dart';

class AXPage extends StatefulWidget {
  @override
  _AXState createState() => _AXState();
}

class _AXState extends State<AXPage> {

    double lgTxSize = 52;
    double smTxSize = 20;

    Singleton _s1 = Singleton();
    Singleton _s2 = Singleton();

  Widget build(BuildContext context) {
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
                padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                padding: EdgeInsets.symmetric(horizontal: 30),
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
                          coloredButtons("BUY AX"),
                          borderedButtons("STAKE AX"),
                        ],
                      ),
                      Column(
                        children: [
                          coloredButtons("CLAIM REWARDS"),
                          borderedButtons("UNSTAKE AX")
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

  Widget coloredButtons(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250, height: 55),
          child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: smTxSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )
          ),
          onPressed: () {

            /// TESTING SINGLETON
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  title: Text(_s1.mnemonic),
                  content: Text(_s2.mnemonic),
              )
            );
          },
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
    );
  }

  Widget borderedButtons(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250, height: 55),
          child: ElevatedButton(
          child: Text(
            text,
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
    );
  }
}