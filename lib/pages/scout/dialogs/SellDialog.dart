import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
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
  bool _isLongApt;
  SellDialog(this.athlete, bool? _isLongApt, {Key? key})
      : this._isLongApt = _isLongApt ?? true,
        super(key: key);

  @override
  State<SellDialog> createState() => _SellDialogState();
}

class _SellDialogState extends State<SellDialog> {
  double paddingHorizontal = 20;
  double hgt = 500;
  // bool _isLongApt = true;
  double input = 0.0;
  String balance = "---";
  double price = 0.0;
  double lpFee = 0.0;
  double marketPriceImpact = 0.0;
  double minimumReceived = 0.0;
  double estimatedSlippage = 0.0;
  double youReceive = 0.0;
  String aptAddress = "";
  TextEditingController _aptAmountController = TextEditingController();

  final WalletController walletController = Get.find();
  final SwapController swapController = Get.find();

  @override
  void initState() {
    super.initState();
    updateStats();
  }

  Future<void> updateStats() async {
    if (widget._isLongApt) {
      aptAddress = getLongAptAddress(widget.athlete.id);
    } else {
      aptAddress = getShortAptAddress(widget.athlete.id);
    }
    swapController.updateFromAddress(aptAddress);
    print("Before balance: $aptAddress");
    try {
      balance = await walletController.getTokenBalance(aptAddress);
    } catch (error) {
      print("Wallet is not connected: $error");
    }

    // TODO: Implement calls for marketPriceImpact, minimumReceived, estimatedSlippage, youReceive, price, and lpFee
    marketPriceImpact = 0.0;
    minimumReceived = 0.0;
    estimatedSlippage = 0.0;
    youReceive = 0.0;
    price = 0.0;
    lpFee = 0.0;
    setState(() {});
  }

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
              //Long apt toggle button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 30),
                  primary:
                      widget._isLongApt ? Colors.amber : Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    widget._isLongApt = !widget._isLongApt;
                  });
                  updateStats();
                },
                child: Text(
                  "Long",
                  style: TextStyle(
                      color: widget._isLongApt
                          ? Colors.black
                          : Color.fromRGBO(154, 154, 154, 1),
                      fontSize: 11),
                ),
              ),
            ),
            Expanded(
              //short apt toggle button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 30),
                    primary:
                        widget._isLongApt ? Colors.transparent : Colors.black),
                onPressed: () {
                  setState(() {
                    widget._isLongApt = !widget._isLongApt;
                  });
                  updateStats();
                },
                child: Text(
                  "Short",
                  style: TextStyle(
                      color: widget._isLongApt
                          ? Color.fromRGBO(154, 154, 154, 1)
                          : Colors.amber,
                      fontSize: 11),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showPrice() {
    String tokenType = widget._isLongApt ? "Long" : "Short";
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Price", style: textStyle(Colors.white, 15, false)),
          Text(
            "$price AX per " + widget.athlete.name + " " + tokenType + " APT",
            style: textStyle(Colors.white, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showLpFee() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("LP Fee:", style: textStyle(Colors.grey[600]!, 15, false)),
          Text(
            "LP Fee: $lpFee APT(5%)",
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showBalance() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Balance: $balance",
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showMarketPriceImpact() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Market Price Impact",
              style: textStyle(Colors.grey[600]!, 15, false)),
          Text(
            "$marketPriceImpact",
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showMinimumReceived() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Minimum Received:",
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
          Text(
            "$minimumReceived AX",
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showSlippage() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Slippage:",
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
          Text(
            "$estimatedSlippage APT",
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showYouReceived() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "You Receive:",
            style: textStyle(Colors.white, 15, false),
          ),
          Text(
            "You Receive: $youReceive AX",
            style: textStyle(Colors.white, 15, false),
          ),
        ],
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
      backgroundColor: Colors.transparent,
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
            //Input apt text with toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              padding: EdgeInsets.symmetric(horizontal: 6),
              width: wid,
              height: 70,
              decoration:
                  boxDecoration(Colors.transparent, 14, 0.5, Colors.grey[400]!),
              child: Column(
                children: [
                  //APT icon - athlete name - max button - input field
                  Row(
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
                            image: widget._isLongApt
                                ? AssetImage(
                                    "assets/images/apt_noninverted.png")
                                : AssetImage("assets/images/apt_inverted.png"),
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
                          onPressed: () {
                            swapController
                                .updateFromAmount(double.parse(balance));
                            //update controller text to max balance
                            _aptAmountController.text = balance;
                          },
                          child: Text(
                            "MAX",
                            style: textStyle(Colors.grey[400]!, 9, false),
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: wid * 0.4),
                        child: IntrinsicWidth(
                          child: TextField(
                            controller: _aptAmountController,
                            style: textStyle(Colors.grey[400]!, 22, false),
                            decoration: InputDecoration(
                              hintText: '0.00',
                              hintStyle:
                                  textStyle(Colors.grey[400]!, 22, false),
                              contentPadding: EdgeInsets.only(left: 3),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              input = double.parse(value);
                              swapController.updateFromAmount(input);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  (RegExp(r'^(\d+)?\.?\d{0,6}'))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      showBalance(),
                    ],
                  ),
                ],
              ),
            ),
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
                        showPrice(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        showLpFee(),
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
                        swapController.approve().then((value) => swapController.swapforAX());
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                confirmTransaction(
                                    context, confirmed, Controller.latestTx));
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

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _aptAmountController.dispose();
    super.dispose();
  }
}
