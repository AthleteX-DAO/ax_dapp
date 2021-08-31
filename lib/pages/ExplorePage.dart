import 'package:ae_dapp/service/AllAthletesList.dart';
import 'package:ae_dapp/service/AthleteProfile.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  double lgTxSize = 52;
  double headerTx = 30;

  @override
  Widget build(BuildContext context) {
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
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text("EXPLORE",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: lgTxSize,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  )),
            ),
            Container(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height * .675,
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[900],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Athlete Tokens",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ))),
                        Container(
                            padding: EdgeInsets.only(bottom: 0),
                            height: MediaQuery.of(context).size.height * .55,
                            width: MediaQuery.of(context).size.width / 2 - 300,
                            child: AllAthletesList())
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: 600,
                              height: 75,
                              child: Container(
                                  color: Colors.grey,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Text(
                                        'Chase Anderson',
                                        style: TextStyle(fontSize: 30),
                                      )))),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                                width: 600,
                                height: 275,
                                child: Container(
                                    color: Colors.white, child: Row()))),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   width: 300,
                                //   height: 75,
                                //   child: Container(),
                                // ),
                                SizedBox(
                                    width: 600,
                                    height: 75,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              color: Colors.grey[900],
                                              child: ElevatedButton(
                                                style: longButton,
                                                child: Text('LONG'),
                                                onPressed: () {},
                                              )),
                                          Container(
                                              color: Colors.grey[900],
                                              child: ElevatedButton(
                                                style: shortButton,
                                                child: Text('SHORT'),
                                                onPressed: () {},
                                              ))
                                        ]))
                              ]),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   width: 300,
                                //   height: 75,
                                //   child: Container(),
                                // ),
                                SizedBox(
                                    width: 600,
                                    height: 75,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              color: Colors.grey[900],
                                              child: ElevatedButton(
                                                style: mintButton,
                                                child: Text('MINT'),
                                                onPressed: () {},
                                              )),
                                          Container(
                                              color: Colors.grey[900],
                                              child: ElevatedButton(
                                                style: redeemButton,
                                                child: Text('REDEEM'),
                                                onPressed: () {},
                                              ))
                                        ]))
                              ]),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        )
      ],
    ));
  }
}

/*
Explore Page
My Team
Generate Key
*/
