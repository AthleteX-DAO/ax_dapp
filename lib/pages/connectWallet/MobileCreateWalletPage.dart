import 'package:flutter/material.dart';
import 'MobileWalletConfirmPage.dart';

class MobileCreateWalletPage extends StatefulWidget {
  const MobileCreateWalletPage({Key? key}) : super(key: key);

  @override
  _MobileCreateWalletPageState createState() => _MobileCreateWalletPageState();
}

class _MobileCreateWalletPageState extends State<MobileCreateWalletPage> {
  Color primaryWhiteColor = Color.fromRGBO(255, 255, 255, 1);
  Color primaryOrangeColor = Color.fromRGBO(254, 197, 0, 1);
  Color secondaryGreyColor = Color.fromRGBO(255, 255, 255, 0.1);
  Color greyTextColor = Color.fromRGBO(160, 160, 160, 1);
  Color secondaryOrangeColor = Color.fromRGBO(254, 197, 0, 0.2);

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
                    left: 100,
                    bottom: 0,
                    height: 80,
                    width: _width * .5,
                    child: Center(
                        child: Text(
                      "Create Wallet",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ))),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Text("Your unique 10 word seed phrase")),
          Container(
              height: _height * .08,
              width: _width * .8,
              margin: EdgeInsets.only(top: 10),
              decoration: boxDecoration(
                  Colors.grey.withOpacity(.2), 10, 1, Colors.grey),
              child: Center(
                  child: Text(
                " Apple Pecker Gator Mountain Daddy Bing Bong Vanilla Ice Cream",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ))),
          Container(
            margin: EdgeInsets.only(top: 40),
            width: _width * .8,
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 14),
                children: [
                  TextSpan(
                      text:
                          "Make sure to copy this seed phrase and store it somewhere safe. you will need it to import your wallet and login to other devices. "),
                  TextSpan(
                      text: "There is no recourse if your seed phrase is lost",
                      style: TextStyle(color: primaryOrangeColor)),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              width: _width * .8,
              child: Text(
                  "Import the above seed phrase into Metamask to login on the AthleteX desktop application")),
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
                        builder: (context) => MobileCreateWalletConfirmPage()));
              },
              child: Text(
                "Continue",
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
