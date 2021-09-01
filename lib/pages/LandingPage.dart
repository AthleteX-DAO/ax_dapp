import 'package:ae_dapp/pages/NavigationBar.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    double txt = 30;
    double buttonTxt = 20;

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        decoration: new BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(.9), BlendMode.darken),
            image: AssetImage("assets/images/background.jpeg"),
          ),
        ),
      ),
      // Image(
      //   image: AssetImage("assets/images/background.jpeg"),
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   fit: BoxFit.cover,
      // ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/AXMarkets.png"),
            width: 500,
            height: 200,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "TRADE ",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: txt,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.amber[400])),
                TextSpan(
                    text: "ATHLETE TOKENS",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: txt,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white)),
              ]))),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "BUILD ",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: txt,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.amber[400])),
                TextSpan(
                    text: "YOUR TEAM",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: txt,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white)),
              ]))),
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 60),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "EARN ",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: txt,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.amber[400])),
                TextSpan(
                    text: "REWARDS",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: txt,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white)),
              ]))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 250, height: 55),
                  child: ElevatedButton(
                    child: Text("CREATE AX WALLET",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: buttonTxt,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => NavigationBar()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber[400]!),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.amber[400]!),
                        ))),
                  )),
              ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 250, height: 55),
                  child: ElevatedButton(
                    child: Text("START TRADING",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: buttonTxt,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[400],
                        )),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => NavigationBar()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.amber[400]!),
                        ))),
                  )),
            ],
          )
        ],
      )
    ]));
  }
}
