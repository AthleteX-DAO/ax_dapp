import 'package:flutter/material.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
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
        Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(top: 25, left: 25),
                      child: BackButton())),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Image(
                        width: 80,
                        height: 80,
                        image: AssetImage("assets/images/x.png"),
                      )))
            ],
          )
        ])
      ],
    ));
  }
}
