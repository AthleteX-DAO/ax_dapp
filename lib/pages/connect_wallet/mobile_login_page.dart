// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/connect_wallet/device_authentication.dart';
import 'package:ax_dapp/pages/connect_wallet/mobile_ax_wallet_login_page.dart';
import 'package:ax_dapp/pages/connect_wallet/mobile_create_wallet_page.dart';
import 'package:flutter/material.dart';

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({super.key});

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
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
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Positioned(
                    left: 100,
                    bottom: 0,
                    height: 40,
                    width: _width * .5,
                    child: const Center(
                      child: Text(
                        'AX Wallet',
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
            //AX Markets Image
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
                      builder: (context) => const MobileCreateWalletPage(),
                    ),
                  );
                },
                child: Text(
                  'Create Wallet',
                  style: textStyle(Colors.amber[400]!, 20, true, false),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: _width * 0.5,
              decoration: boxDecoration(
                Colors.grey[300]!.withOpacity(0.15),
                20,
                1,
                Colors.transparent,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const DeviceAuthentication(),
                    ),
                  );
                },
                child: Text(
                  'Login',
                  style: textStyle(Colors.white, 20, true, false),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: _width * 0.5,
              decoration: boxDecoration(
                Colors.grey[300]!.withOpacity(0.15),
                20,
                1,
                Colors.transparent,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const MobileAxWalletLoginPage(),
                    ),
                  );
                },
                child: Text(
                  'Existing Wallet',
                  style: textStyle(Colors.white, 20, true, false),
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
      border: Border.all(color: borCol, width: borWid),
    );
  }
}
