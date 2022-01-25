import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DesktopPool extends StatefulWidget {
  const DesktopPool({Key? key}) : super(key: key);

  @override
  _DesktopPoolState createState() => _DesktopPoolState();
}

class _DesktopPoolState extends State<DesktopPool> {
  SwapController swapController = Get.find();
  bool allLiq = true;
  List<Token> tokenListFilter = [];

  List<Token> tokens = [
    AXT("AthleteX", "AX", AssetImage('../assets/images/x.jpg')),
    SXT("SportX", "SX", AssetImage('../assets/images/sx.png')),
    MATIC("Matic/Polygon", "Matic", AssetImage('../assets/images/matic.png')),
  ];

  @override
  void initState() {
    super.initState();

    for (Athlete ath in AthleteList.list)
      tokens.add(Token(ath.name + " APT", ath.name + " APT",
          AssetImage('../assets/images/apt.png')));

    tokenListFilter = tokens;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double hgt = _height * 0.7;

    return Container(
      width: _width,
      height: _height - 57,
      alignment: Alignment.center,
      child: Container(
        width: _width * 0.8,
        height: hgt,
        child: (allLiq) ? allLiquidity() : myLiquidity()
      )
    );
  }

  Widget allLiquidity() {
    Widget toggle = Container(
      width: 260,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 120,
              decoration: boxDecoration(
                  Colors.grey[600]!, 100, 0, Colors.transparent),
              child: TextButton(
                onPressed: () {},
                child: Text("Add Liquidity",
                style: textStyle(Colors.white, 16, true, false)
              )
            )
          ),
          Container(
            width: 115,
            decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
            child: TextButton(
              onPressed: () {
                setState(() {
                  allLiq = false;
                });
              },
              child: Text(
                "My Liquidity",
                style: textStyle(Colors.white, 16, true, false)
              )
            )
          )
        ]
      )
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 45,
            alignment: Alignment.bottomLeft,
            child: Text(
              "Liquidity Pool",
              style: textStyle(Colors.white, 24, true, false)
            )
          ),
          toggle
        ],
      ),
    );
  }

  Widget myLiquidity() {
    Widget toggle = Container(
      width: 260,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 120,
              decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    allLiq = true;
                  });
                },
                child: Text("Add Liquidity",
                style: textStyle(Colors.white, 16, true, false)
              )
            )
          ),
          Container(
            width: 115,
            decoration: boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "My Liquidity",
                style: textStyle(Colors.white, 16, true, false)
              )
            )
          )
        ]
      )
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 45,
            alignment: Alignment.bottomLeft,
            child: Text(
              "My Liquidity",
              style: textStyle(Colors.white, 24, true, false)
            )
          ),
          toggle,
        ],
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

  BoxDecoration boxDecoration(Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}