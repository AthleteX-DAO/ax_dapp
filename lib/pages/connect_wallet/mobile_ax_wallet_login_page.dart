// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/v1_app.dart';
import 'package:flutter/material.dart';

class MobileAxWalletLoginPage extends StatefulWidget {
  const MobileAxWalletLoginPage({super.key});

  @override
  State<MobileAxWalletLoginPage> createState() =>
      _MobileAxWalletLoginPageState();
}

class _MobileAxWalletLoginPageState extends State<MobileAxWalletLoginPage> {
  Color primaryWhiteColor = const Color.fromRGBO(255, 255, 255, 1);
  Color primaryOrangeColor = const Color.fromRGBO(254, 197, 0, 1);
  Color secondaryGreyColor = const Color.fromRGBO(255, 255, 255, 0.1);
  Color greyTextColor = const Color.fromRGBO(160, 160, 160, 1);
  Color secondaryOrangeColor = const Color.fromRGBO(254, 197, 0, 0.2);
  final seedPhraseTextController = TextEditingController();

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
          children: [
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
                    left: 60,
                    bottom: 0,
                    height: 80,
                    width: _width * .7,
                    child: const Center(
                      child: Text(
                        'Import AX Wallet',
                        style: TextStyle(
                          fontSize: 28,
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
              child: const Text('Input your 10 word seed phrase:'),
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
              child: Center(
                child: TextFormField(
                  controller: seedPhraseTextController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Enter your seed phrase here...',
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsetsDirectional.only(start: 10),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.center,
                ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const V1App(),
                    ),
                  );
                },
                child: Text(
                  'Continue to App',
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
