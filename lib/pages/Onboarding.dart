import 'package:ae_dapp/pages/NavigationBar.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final introKey = GlobalKey<IntroductionScreenState>();
  String warning =
      "Understand that AthleteX does not have custody over your funds. \n You are in control, and responsible for your own wallet. \n We cannot recover your funds if lost";
  @override
  void initState() {
    super.initState();
  }


  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NavigationBar()),
    );
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/images/asu-hero.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          color: Color.fromRGBO(35, 43, 43, 1.0),
          fontSize: 28.0,
          fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.normal),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.black87,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: Text(
              "AE",
              style: TextStyle(
                  color: Color.fromRGBO(254, 201, 1, 1.0), fontSize: 45.55),
            ),
          ),
        ),
      ),
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'Let\s go right away!',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        PageViewModel(
          title: "Welcome to AthleteX",
          body:
              "Invest in the player performance of athletes \n AthleteX lets you buy the player performance of athletes",
          image: _buildImage('img2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Before you Start...",
          body: warning,
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
                color: Color.fromRGBO(35, 43, 43, 1.0),
                fontSize: 28.0,
                fontWeight: FontWeight.w700),
            bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.normal),
            descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            pageColor: Colors.white,
            bodyAlignment: Alignment.center,
            imagePadding: EdgeInsets.zero,
          ),
          footer: ElevatedButton(
            onPressed: () {
              setState(() {
                warning = "Great! Good luck and have fun!";
              });
            },
            child: const Text(
              'Understood',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        PageViewModel(
          title: "Create a Wallet",
          body: "walletDetails",
          footer: ElevatedButton(
            onPressed: () {
              setState(() {
                // walletDetails = "Your seed: \n$mneumonicSeed";
              });
            },
            child: const Text(
              'Generate my Key Pair',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          image: _buildFullscrenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color.fromRGBO(254, 201, 1, 1.0),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Color.fromRGBO(35, 43, 43, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
// Image(image: AssetImage('assets/images/img1.png'), width: 40.22, height: 40.22,)
