import 'dart:math';

import 'package:flutter/material.dart';

class AXPage extends StatefulWidget {
  @override
  _AXState createState() => _AXState();
}

class _AXState extends State<AXPage> {
  // Actionable
  Future<void> buyAX() async {}
  Future<void> stakeAX() async {}
  Future<void> claimRewards() async {}
  Future<Widget> unstakeAX() async {
    return Text("Unclaimed Rewards: ");
  }

  // Viewable
  Future<int> totalBalance() async {
    return new Random().nextInt(800);
  }

  Future<String> availableBalance() async {
    return "0";
  }

  Future<int> stakedAX() async {
    return Random().nextInt(200);
  }

  Future<double> getAPY() async {
    return Random().nextDouble();
  }

  Future<double> rewardsEarned() async {
    return new Random().nextDouble();
  }

  Future<double> UnclaimedRewards() async {
    return new Random(300).nextDouble();
  }

  Widget build(BuildContext context) {
    double lgTxSize = 52;
    double smTxSize = 20;

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Image(
          image: AssetImage("assets/images/background.jpeg"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Column(children: <Widget>[
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
          Text("AX",
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: lgTxSize,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("My Account",
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: lgTxSize,
                                    fontWeight: FontWeight.w600))),
                        StreamBuilder(
                            stream: Stream.periodic(Duration(seconds: 7))
                                .asyncMap((event) => totalBalance()),
                            builder: (context, snapshot) => Text(
                                "AX Total Balance: ${snapshot.data.toString()}",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: smTxSize,
                                ))),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: StreamBuilder(
                                stream: Stream.periodic(Duration(seconds: 7))
                                    .asyncMap((event) => availableBalance()),
                                builder: (context, snapshot) => Text(
                                    "AX Available Balance: ${snapshot.data.toString()}",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: smTxSize,
                                    )))),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: StreamBuilder(
                              stream: Stream.periodic(Duration(seconds: 7))
                                  .asyncMap((event) => stakedAX()),
                              builder: (context, snapshot) =>
                                  Text("AX Staked: ${snapshot.data.toString()}",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: smTxSize,
                                      )),
                            )),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("My Rewards",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: lgTxSize,
                                  fontWeight: FontWeight.w600,
                                ))),
                        StreamBuilder(
                          stream: Stream.periodic(Duration(seconds: 7))
                              .asyncMap((event) => getAPY()),
                          builder: (context, snapshot) =>
                              Text("APY: ${snapshot.data.toString()}%",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: smTxSize,
                                  )),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: StreamBuilder(
                                stream: Stream.periodic(Duration(seconds: 7))
                                    .asyncMap((event) => rewardsEarned()),
                                builder: (context, snapshot) => Text(
                                    "Rewards Earned: ${snapshot.data.toString()}",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: smTxSize,
                                    )))),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: StreamBuilder(
                                stream: Stream.periodic(Duration(seconds: 7))
                                    .asyncMap((event) => UnclaimedRewards()),
                                builder: (context, snapshot) => Text(
                                    "Unclaimed Rewards: ${snapshot.data.toString()}",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: smTxSize,
                                    )))),
                      ],
                    )
                  ],
                ),
                // color: Colors.grey[900],
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width: 250, height: 55),
                                    child: ElevatedButton(
                                      child: Text("BUY AX",
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: smTxSize,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )),
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.amber[400]!),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.amber[400]!),
                                          ))),
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width: 250, height: 55),
                                    child: ElevatedButton(
                                      child: Text("STAKE AX",
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: smTxSize,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber[400],
                                          )),
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey[800]!),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.amber[400]!),
                                          ))),
                                    ))),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width: 250, height: 55),
                                    child: ElevatedButton(
                                      child: Text("CLAIM REWARDS",
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: smTxSize,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )),
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.amber[400]!),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.amber[400]!),
                                          ))),
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width: 250, height: 55),
                                    child: ElevatedButton(
                                      child: Text("UNSTAKE AX",
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: smTxSize,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber[400],
                                          )),
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey[800]!),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.amber[400]!),
                                          ))),
                                    ))),
                          ],
                        )
                      ]))),
        ])
      ],
    ));
  }
}
