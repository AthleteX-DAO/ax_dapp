import 'package:ax_dapp/pages/V1App.dart';
import 'package:flutter/material.dart';

class MobileAxWalletLoginPage extends StatefulWidget {
  const MobileAxWalletLoginPage({Key? key}) : super(key: key);

  @override
  _MobileAxWalletLoginPageState createState() =>
      _MobileAxWalletLoginPageState();
}

class _MobileAxWalletLoginPageState extends State<MobileAxWalletLoginPage> {
  Color primaryWhiteColor = Color.fromRGBO(255, 255, 255, 1);
  Color primaryOrangeColor = Color.fromRGBO(254, 197, 0, 1);
  Color secondaryGreyColor = Color.fromRGBO(255, 255, 255, 0.1);
  Color greyTextColor = Color.fromRGBO(160, 160, 160, 1);
  Color secondaryOrangeColor = Color.fromRGBO(254, 197, 0, 0.2);
  final seedPhraseTextController = TextEditingController();

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
                    height: 80,
                    width: 40,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back))),
                Positioned(
                    left: 60,
                    bottom: 0,
                    height: 80,
                    width: _width * .7,
                    child: Center(
                        child: Text(
                      "Import AX Wallet",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ))),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Text("Input your 10 word seed phrase:")),
          Container(
              height: _height * .08,
              width: _width * .8,
              margin: EdgeInsets.only(top: 10),
              decoration: boxDecoration(
                  Colors.grey.withOpacity(.2), 10, 1, Colors.grey),
              child: Center(
                  child: TextFormField(
                controller: seedPhraseTextController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Enter your seed phrase here...',
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsetsDirectional.only(start: 10.0),
                ),
                style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                textAlign: TextAlign.center,
              ))),
          Container(
            margin: EdgeInsets.only(top: 60),
            width: _width * 0.5,
            decoration: boxDecoration(Colors.amber[300]!.withOpacity(0.15), 20,
                1, Colors.transparent),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => V1App()));
              },
              child: Text(
                "Continue to App",
                style: textStyle(Colors.amber[400]!, 20, true, false),
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
        border: Border.all(color: secondaryGreyColor, width: borWid));
  }
}
