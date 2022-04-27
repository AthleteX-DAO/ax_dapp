import 'package:ax_dapp/pages/connectWallet/DeviceAuthentication.dart';
import 'package:ax_dapp/pages/connectWallet/MobileAxWalletLoginPage.dart';
import 'package:flutter/material.dart';
import 'MobileCreateWalletPage.dart';

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({Key? key}) : super(key: key);

  @override
  _MobileLoginPageState createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/axBackground.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
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
                        icon: Icon(Icons.arrow_back))),
                Positioned(
                    left: 100,
                    bottom: 0,
                    height: 40,
                    width: _width * .5,
                    child: Center(
                        child: Text(
                      "AX Wallet",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ))),
              ],
            ),
          ),
          //AX Markets Image
          Container(
            margin: EdgeInsets.only(top: 60),
            width: _width * 0.5,
            decoration: boxDecoration(Colors.amber[300]!.withOpacity(0.15), 20,
                1, Colors.transparent),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MobileCreateWalletPage()));
              },
              child: Text(
                "Create Wallet",
                style: textStyle(Colors.amber[400]!, 20, true, false),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            width: _width * 0.5,
            decoration: boxDecoration(
                Colors.grey[300]!.withOpacity(0.15), 20, 1, Colors.transparent),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeviceAuthentication()));
              },
              child: Text(
                "Login",
                style: textStyle(Colors.white, 20, true, false),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            width: _width * 0.5,
            decoration: boxDecoration(
                Colors.grey[300]!.withOpacity(0.15), 20, 1, Colors.transparent),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MobileAxWalletLoginPage()));
              },
              child: Text(
                "Existing Wallet",
                style: textStyle(Colors.white, 20, true, false),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold) if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}
