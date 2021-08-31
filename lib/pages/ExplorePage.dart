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
        body: Stack(children: <Widget>[
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
        Text("EXPLORE",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: lgTxSize,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            )),
        Container(
          width: MediaQuery.of(context).size.width - 200,
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
                      width: MediaQuery.of(context).size.width / 2 - 250,
                      child: AllAthletesList())
                ],
              ),
              Column(
                children: <Widget>[
                  //Main Right Area
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: (Colors.grey[800])!),
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      alignment: Alignment.center,
                      height: 475,
                      width: 600,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(children: [
                                    Text(
                                      'Chase Anderson',
                                      style: TextStyle(
                                          fontSize: 25, fontFamily: 'OpenSans'),
                                    ),
                                  ])),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Column(children: [
                                    Text(
                                      '+1.59\%',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'OpenSans',
                                          color: Colors.green),
                                    ),
                                  ])),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(children: [
                                    Text(
                                      '\$0.0148',
                                      style: TextStyle(
                                          fontSize: 25, fontFamily: 'OpenSans'),
                                    ),
                                  ])),
                            ])
                          ],
                        ),
                      ))
                ],
              )
            ],
          ),
        )
      ])
    ]));
  }
}









/*
Explore Page
My Team
Generate Key
*/