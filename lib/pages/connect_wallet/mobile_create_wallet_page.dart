// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

class MobileCreateWalletPage extends StatefulWidget {
  const MobileCreateWalletPage({super.key});

  @override
  State<MobileCreateWalletPage> createState() => _MobileCreateWalletPageState();
}

class _MobileCreateWalletPageState extends State<MobileCreateWalletPage> {
  Color primaryWhiteColor = const Color.fromRGBO(255, 255, 255, 1);
  Color primaryOrangeColor = const Color.fromRGBO(254, 197, 0, 1);
  Color secondaryGreyColor = const Color.fromRGBO(255, 255, 255, 0.1);
  Color greyTextColor = const Color.fromRGBO(160, 160, 160, 1);
  Color secondaryOrangeColor = const Color.fromRGBO(254, 197, 0, 0.2);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/axBackground.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              width: _width,
              height: _height * 0.1,
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    bottom: 0,
                    height: 80,
                    width: 40,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Positioned(
                    left: 100,
                    bottom: 0,
                    height: 80,
                    width: _width * .5,
                    child: const Center(
                      child: Text(
                        'Create Wallet',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Text('Please enter your email', style: TextStyle(fontSize: 20)),
            ),
            Container(
              height: _height * .08,
              width: _width * .8,
              margin: const EdgeInsets.only(top: 10),
              decoration: boxDecoration(
                Colors.grey.withOpacity(.2),
                10,
                1,
                Colors.grey,
              ),
              child: const Center(
                child: Text(
                  ''' Enter your email here! ''',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              width: _width * .8,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  children: [
                    const TextSpan(
                      text:
                          '''We will generate a mnemonic seed phrase, along with your account.  This is saved in the local cache, and viewable at any time from the account screen''',
                    ),
                    TextSpan(
                      text: 'There is no recourse if your seed phrase is lost',
                      style: TextStyle(color: primaryOrangeColor),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: _width * .8,
              child: const Text(
                '''Import the above seed phrase into Metamask to login on the AthleteX desktop application''',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60),
              width: _width * 0.5,
              decoration: boxDecoration(
                Colors.amber[300]!.withOpacity(0.15),
                20,
                1,
                Colors.transparent,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Continue',
                  style: textStyle(Colors.amber[400]!, 20, true, false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    // ignore: curly_braces_in_flow_control_structures
    if (isBold) if (isUline) {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.underline,
      );
    } else {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    }
    else if (isUline) {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        decoration: TextDecoration.underline,
      );
    } else {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
    }
  }

  BoxDecoration boxDecoration(
    Color col,
    double rad,
    double borWid,
    Color borCol,
  ) {
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(color: secondaryGreyColor, width: borWid),
    );
  }
}
