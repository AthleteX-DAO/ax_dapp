import 'package:ax_dapp/pages/V1App.dart';
import 'package:ax_dapp/util/AthletePageFormatHelper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool next = false;
  bool isWeb = true;

  @override
  Widget build(BuildContext context) {
    if (next) return V1App();

    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double textSize = _height * 0.05;
    double tradingTextSize = textSize * 0.7;
    if (_width < _height) textSize = _width * 0.05;
    if (!isWeb) tradingTextSize = textSize * 1.25;

    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/axBackground.jpeg"),
          fit: BoxFit.fill,
        ),
      ),
      child: isWeb
          ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
              Widget>[
              //AX Markets Image
              athletexLogo(_height),
              desktopLandingPage(context, textSize),
              //Button load athletes
              Container(
                width: _width * 0.20,
                height: _height * 0.1,
                margin: EdgeInsets.only(bottom: 130.0),
                child: startTradingButton(tradingTextSize)
              ),
            ])
          :
          //Mobile landing page
          Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
              //AX Markets Image
              athletexLogo(_height),
              andoridLandingPage(context, textSize),
              //Button load athletes
              Container(
                width: _width * 0.6,
                height: _height * 0.07,
                child: startTradingButton(tradingTextSize)
              ),
            ]),
    );
  }

  Container athletexLogo(double _height) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      height: _height * 0.2,
      child: Image(
        image: AssetImage("assets/images/AthleteX_Logo_Vector.png"),
      ));
  }

  Widget desktopLandingPage(BuildContext context, textSize) {
    return Container(
        height: 225,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "TRADE",
                      style: TextStyle(
                        color: Colors.amber[400]!,
                        fontFamily: 'BebasNeuePro',
                        fontSize: textSize,
                      )),
                  TextSpan(
                      text: " ATHLETES",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BebasNeuePro',
                        fontSize: textSize,
                      ))
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "BUILD",
                      style: TextStyle(
                        color: Colors.amber[400]!,
                        fontFamily: 'BebasNeuePro',
                        fontSize: textSize,
                      )),
                  TextSpan(
                      text: " YOUR ROSTER",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BebasNeuePro',
                        fontSize: textSize,
                      )),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "EARN",
                      style: TextStyle(
                        color: Colors.amber[400]!,
                        fontFamily: 'BebasNeuePro',
                        fontSize: textSize,
                      )),
                  TextSpan(
                      text: " REWARDS",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BebasNeuePro',
                        fontSize: textSize,
                      )),
                ],
              ),
            ),
          ],
        ));
  }

  Widget andoridLandingPage(BuildContext context, textSize) {
    return Container();
  }

  Widget reloadPageButton(double tradingTextSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text(
            'Could not load Athlete\'s information',
            style: TextStyle(
                fontSize: 14,
                color: Colors.red,
                decoration: TextDecoration.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          decoration: isWeb
              ? boxDecoration(Colors.transparent, 100, 1, Colors.red[400]!)
              : boxDecoration(Colors.red[300]!.withOpacity(0.15), 100, 1,
                  Colors.transparent),
          child: TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(
              "Reload the App",
              style: textStyle(Colors.red[400]!, tradingTextSize, true, false),
            ),
          ),
        ),
      ],
    );
  }

  Widget startTradingButton(double tradingTextSize) {
    return isWeb
        ? TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(color: Colors.amber[400]!)
              )
            )
          ),
          onPressed: () {
            setState(() {
              next = true;
            });
          },
          child: Text(
            "Start Trading",
            style:
                textStyle(Colors.amber[400]!, tradingTextSize, true, false),
          ),
        )         
        : TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[300]!.withOpacity(0.15)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.transparent)
              )
            )
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => V1App()));
          },
          child: Text(
            "Start",
            style:
                textStyle(Colors.amber[400]!, tradingTextSize, true, false),
          ),
        );      
  }
}
