import 'package:ax_dapp/pages/landingPage/components/landing_page_widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isWeb = true;

  @override
  Widget build(BuildContext context) {
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
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //AX Markets Image
              AthleteXLogo(height: _height),
              DesktopLandingPage(textSize: textSize),
              //Button load athletes
              Container(
                width: _width * 0.20,
                height: _height * 0.1,
                margin: EdgeInsets.only(bottom: 130.0),
                child: StartTradingButton(
                    isWeb: isWeb, tradingTextSize: tradingTextSize),
              ),
            ],
          )
        :
        //Mobile landing page
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //AX Markets Image
            AthleteXLogo(height: _height),
            MobileLandingPage(),
            //Button load athletes
            Container(
                width: _width * 0.6,
                height: _height * 0.07,
                child: StartTradingButton(
                    isWeb: isWeb, tradingTextSize: tradingTextSize),
            ),
          ],
        ),
    );
  }
}
