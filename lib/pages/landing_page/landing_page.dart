import 'package:ax_dapp/pages/landing_page/components/landing_page_widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isWeb = true;

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var textSize = _height * 0.05;
    var tradingTextSize = textSize * 0.7;
    if (_width < _height) textSize = _width * 0.05;
    if (!isWeb) tradingTextSize = textSize * 1.25;

    return Container(
      width: _width,
      height: _height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/axBackground.jpeg'),
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
                  margin: const EdgeInsets.only(bottom: 130),
                  child: StartTradingButton(
                    isWeb: isWeb,
                    tradingTextSize: tradingTextSize,
                  ),
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
                const MobileLandingPage(),
                //Button load athletes
                SizedBox(
                  width: _width * 0.6,
                  height: _height * 0.07,
                  child: StartTradingButton(
                    isWeb: isWeb,
                    tradingTextSize: tradingTextSize,
                  ),
                ),
              ],
            ),
    );
  }
}
