import 'package:ax_dapp/pages/V1App.dart';
import 'package:ax_dapp/service/AthleteApi.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool next = false;

  @override
  Widget build(BuildContext context) {
    if (next)
      return V1App();
      
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double textSize = _height*0.05;
    if (_width < _height)
      textSize = _width*0.05;
      
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("../assets/images/axBackground.jpeg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //AX Markets Image
          Container(
            height: _height*0.2,
            child: Image(
              image: AssetImage("../assets/images/AXMarkets.png"),
            )
          ),
          // Text
          Container(
            height: _height*0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "TRADE", style: textStyle(Colors.amber[400]!, textSize, true, false)),
                      TextSpan(text: " ATHLETES", style: textStyle(Colors.white, textSize, true, false)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "BUILD", style: textStyle(Colors.amber[400]!, textSize, true, false)),
                      TextSpan(text: " YOUR ROSTER", style: textStyle(Colors.white, textSize, true, false)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "EARN", style: textStyle(Colors.amber[400]!, textSize, true, false)),
                      TextSpan(text: " REWARDS", style: textStyle(Colors.white, textSize, true, false)),
                    ],
                  ),
                ),
              ],
            )
          ),
          //Button load athletes
          Container(
            width: _width*0.35,
            height: _height*0.1,
            child: FutureBuilder<dynamic>(
              future: AthleteApi.getAthletesLocally(context),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                  AthleteList.list = snapshot.data;
                    return Container(
                      decoration: boxDecoration(Colors.transparent, 100, 4, Colors.amber[400]!),
                      child: TextButton(
                        onPressed: () {setState(() {next = true;});},
                        child: Text(
                          "Start Trading",
                          style: textStyle(Colors.amber[400]!, textSize, true, false),
                        )
                      )
                    );
                }
              }
            )
          ),
        ]
      )
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold)
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
        );
    else
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
        );
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
}