import 'package:ae_dapp/service/AllAthletesList.dart';
import 'package:ae_dapp/service/RSSReader.dart';
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
            Text("EXPLORE",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: lgTxSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                )),
            Container(
                width: MediaQuery.of(context).size.width - 300,
                height: MediaQuery.of(context).size.height * .675,
                padding: EdgeInsets.only(top: 30),
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
                                  fontSize: headerTx,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ))),
                        Container(
                            padding: EdgeInsets.only(bottom: 5),
                            height: MediaQuery.of(context).size.height * .05,
                            width: 200,
                            child: Container(
                              child: TextField(),
                            )),
                        Container(
                            padding: EdgeInsets.only(bottom: 10),
                            height: MediaQuery.of(context).size.height * .5,
                            width: MediaQuery.of(context).size.width / 2 - 225,
                            child: AllAthletesList())
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Athlete Performance",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: headerTx,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ))),
                        Container(
                            padding: EdgeInsets.only(bottom: 20),
                            height: MediaQuery.of(context).size.height * .55,
                            width: MediaQuery.of(context).size.width / 2 - 200,
                            child: Container(
                              child: Text('Athete Uno'),
                            ))
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