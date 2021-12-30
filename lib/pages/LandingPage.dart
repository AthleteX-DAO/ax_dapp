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
      
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
            height: 200,
            child: Image(
              image: AssetImage("../assets/images/AXMarkets.png"),
            )
          ),
          // Text
          Container(
            height: 175,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "TRADE", style: textStyle(Colors.amber[400]!, 32, true, false)),
                      TextSpan(text: " ATHLETES", style: textStyle(Colors.white, 32, true, false)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "BUILD", style: textStyle(Colors.amber[400]!, 32, true, false)),
                      TextSpan(text: " YOUR ROSTER", style: textStyle(Colors.white, 32, true, false)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "EARN", style: textStyle(Colors.amber[400]!, 32, true, false)),
                      TextSpan(text: " REWARDS", style: textStyle(Colors.white, 32, true, false)),
                    ],
                  ),
                ),
              ],
            )
          ),
          //Button load athletes
          Container(
            width: 275,
            height: 60,
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
                          style: textStyle(Colors.amber[400]!, 26, true, false),
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