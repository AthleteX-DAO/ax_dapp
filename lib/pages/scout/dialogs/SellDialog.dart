import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../service/TokenList.dart';

class SellDialog extends StatefulWidget {
  final AthleteScoutModel athlete;
  SellDialog(this.athlete, {Key? key}) : super(key: key);

  @override
  State<SellDialog> createState() => _SellDialogState();
}

class _SellDialogState extends State<SellDialog> {
  double paddingHorizontal = 20;
  double hgt = 500;
  bool _isLongApt = true;
  double balance = 0.0;
  double marketPriceImpact = 0.0;
  double minimumReceived = 0.0;
  double estimatedSlippage = 0.0;
  double youReceive = 0.0;
  String aptAddress = "";

  WalletController walletController = Get.find();
  SwapController swapController = Get.find();

  Widget toggleLongShortToken(double wid, double hgt) {
    return Container(
      padding: EdgeInsets.all(1.5),
      width: wid * 0.25,
      height: hgt * 0.05,
      decoration: boxDecoration(Colors.transparent, 20, 1, Colors.grey[800]!),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 30),
                  primary: _isLongApt ? Colors.amber : Colors.transparent,
                ),
                onPressed: () {
                  aptAddress = getLongAptAddress(widget.athlete.id);
                  swapController
                      .updateFromAddress(aptAddress);
                  setState(() {
                    _isLongApt = !_isLongApt;
                  });
                },
                child: Text(
                  "Long",
                  style: TextStyle(
                      color: _isLongApt
                          ? Colors.white
                          : Color.fromRGBO(154, 154, 154, 1),
                      fontSize: 11),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 30),
                    primary:
                        _isLongApt ? Colors.transparent : Colors.grey[500]),
                onPressed: () {
                  aptAddress = getShortAptAddress(widget.athlete.id);
                  swapController
                      .updateFromAddress(aptAddress);
                  setState(() {
                    _isLongApt = !_isLongApt;
                  });
                },
                child: Text(
                  "Short",
                  style: TextStyle(
                      color: _isLongApt
                          ? Color.fromRGBO(154, 154, 154, 1)
                          : Colors.white,
                      fontSize: 11),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showBalance() {
    return Flexible(
      child: Text(
        "Balance: $balance",
        style: textStyle(Colors.grey[400]!, 14, false),
      ),
    );
  }

  Widget showMarketPriceImpact() {
    return Flexible(
      child: Text(
        "Market Price Impact: $marketPriceImpact",
        style: textStyle(Colors.grey[400]!, 14, false),
      ),
    );
  }

  Widget showMinimumReceived() {
    return Flexible(
      child: Text(
        "Minimum Received: $minimumReceived",
        style: textStyle(Colors.grey[400]!, 14, false),
      ),
    );
  }

  Widget showSlippage() {
    return Flexible(
      child: Text(
        "Slippage: $estimatedSlippage",
        style: textStyle(Colors.grey[400]!, 14, false),
      ),
    );
  }

  Widget showYouReceived() {
    return Flexible(
      child: Text(
        "You Receive: $youReceive",
        style: textStyle(Colors.grey[400]!, 14, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _height = MediaQuery.of(context).size.height;
    double wid = isWeb ? 400 : 355;
    if (_height < 505) hgt = _height;

    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        height: hgt,
        width: wid,
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: wid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sell " + widget.athlete.name + " APT",
                        style: textStyle(Colors.white, 20, false)),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                )),
            Container(
              width: wid,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: "You can sell APT's at Market Price for AX.",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : 12)),
                    TextSpan(
                        text:
                            " You can access other funds with AX on the Matic network through",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : 12)),
                    TextSpan(
                        text: " SushiSwap",
                        style: TextStyle(
                            color: Colors.amber[400],
                            fontSize: isWeb ? 14 : 12)),
                  ],
                ),
              ),
            ),
            //Input apt text with toggle, and apt input box
            Row(
              children: [
                Text(
                  isWeb ? "Input APT:" : "Input APT amount you want to sell:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                toggleLongShortToken(wid, hgt),
              ],
            ),
            //APT input box
            Container(
              width: wid,
              height: 55,
              decoration:
                  boxDecoration(Colors.transparent, 14, 0.5, Colors.grey[400]!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(width: 5),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        scale: 0.5,
                        image: AssetImage("assets/images/apt_noninverted.png"),
                      ),
                    ),
                  ),
                  Container(width: 15),
                  Expanded(
                    child: Text(
                      widget.athlete.name + " APT",
                      style: textStyle(Colors.white, 15, false),
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 48,
                    decoration: boxDecoration(
                        Colors.transparent, 100, 0.5, Colors.grey[400]!),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "MAX",
                        style: textStyle(Colors.grey[400]!, 9, false),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      style: textStyle(Colors.grey[400]!, 22, false),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: textStyle(Colors.grey[400]!, 22, false),
                        contentPadding:
                            isWeb ? EdgeInsets.all(9) : EdgeInsets.all(6),
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            (RegExp(r'^(\d+)?\.?\d{0,6}'))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            showBalance(),
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            Container(
                width: wid,
                height: 125,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Price",
                            style: textStyle(Colors.white, 15, false)),
                        Text("0.8 " + widget.athlete.name + " APT per AX",
                            style: textStyle(Colors.white, 15, false)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "LP Fee",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "0.5 AX",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [showMarketPriceImpact()],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        showMinimumReceived(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        showSlippage(),
                      ],
                    ),
                  ],
                )),
            Container(
              width: wid,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  showYouReceived(),
                ],
              ),
            ),
            Container(
              width: wid,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    width: 175,
                    height: 45,
                    decoration: isWeb
                        ? boxDecoration(
                            Colors.amber[400]!, 500, 1, Colors.amber[400]!)
                        : boxDecoration(Colors.amber[500]!.withOpacity(0.20),
                            500, 1, Colors.transparent),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        bool confirmed = true;
                        String txString =
                            "0x192AB27a6d1d3885e1022D2b18Dd7597272ebD22";
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                confirmTransaction(
                                    context, confirmed, txString));
                      },
                      child: Text(
                        "Confirm",
                        style: isWeb
                            ? textStyle(Colors.black, 16, false)
                            : textStyle(Colors.amber[500]!, 16, false),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
