import 'dart:math';

import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/service/Controller/Scout/LSPController.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/service/TokenList.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RedeemDialog extends StatefulWidget {
  final AthleteScoutModel athlete;
  RedeemDialog(this.athlete, {Key? key}) : super(key: key);

  @override
  State<RedeemDialog> createState() => _RedeemDialogState();
}

class _RedeemDialogState extends State<RedeemDialog> {
  double paddingHorizontal = 40;
  double hgt = 450;
  // bool _isLongApt = true;
  RxDouble maxAmount = 0.0.obs;
  RxString longBalance = "---".obs;
  RxString shortBalance = "---".obs;
  TextEditingController _longInputController = TextEditingController();
  TextEditingController _shortInputController = TextEditingController();

  final WalletController walletController = Get.find();
  LSPController lspController = Get.find();

  @override
  void initState() {
    super.initState();
    lspController.updateAptAddress(widget.athlete.id);
    updateStats();
  }

  Future<void> updateStats() async {
    try {
      longBalance.value = await walletController
          .getTokenBalance(getLongAptAddress(widget.athlete.id));
      shortBalance.value = await walletController
          .getTokenBalance(getShortAptAddress(widget.athlete.id));
      maxAmount.value = min(
          double.parse(longBalance.value), double.parse(shortBalance.value));
    } catch (error) {
      print("Wallet is not connected: $error");
    }
    setState(() {});
  }

  Widget showLongBalance() {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Text(
              "Balance: ${longBalance.value}",
              style: textStyle(Colors.grey[600]!, 15, false),
            ),
          ),
        ],
      ),
    );
  }

  Widget showShortBalance() {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Text(
              "Balance: ${shortBalance.value}",
              style: textStyle(Colors.grey[600]!, 15, false),
            ),
          ),
        ],
      ),
    );
  }

  Widget showYouReceive() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "You Receive: ",
            style: textStyle(Colors.white, 15, false),
          ),
          Obx(
            () => Row(
              children: <Widget>[
                Text(
                  "${(lspController.redeemAmt * 15000).toStringAsFixed(6)} AX", // 15000 is the collateral per pair
                  style: textStyle(Colors.white, 15, false),
                ),
              ],
            ),
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
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        height: hgt,
        width: wid,
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  width: wid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Redeem " + widget.athlete.name + " APT Pair",
                          style: textStyle(Colors.white, 20, false)),
                      IconButton(
                        icon: Icon(
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
                        text:
                            "You can redeem APT's at their Book Value for AX.",
                        style: textStyle(
                            Colors.grey[600]!, isWeb ? 14 : 12, false),
                      ),
                      TextSpan(
                        text:
                            " You can access other funds with AX on the Matic network through",
                        style: textStyle(
                            Colors.grey[600]!, isWeb ? 14 : 12, false),
                      ),
                      TextSpan(
                        text: " SushiSwap",
                        style: textStyle(
                            Colors.amber[400]!, isWeb ? 14 : 12, false),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //Input APT pair - Max Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            isWeb
                                ? "Input APT pair:"
                                : "Input APT pair and amount:",
                            style: textStyle(Colors.grey[600]!, 14, false),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 28,
                          width: 48,
                          decoration: boxDecoration(
                              Colors.transparent, 100, 0.5, Colors.grey[400]!),
                          child: TextButton(
                            onPressed: () {
                              updateStats();
                              lspController.updateRedeemAmt(maxAmount.value);
                              _longInputController.text = "${maxAmount.value}";
                              _shortInputController.text = "${maxAmount.value}";
                            },
                            child: Text(
                              "MAX",
                              style: textStyle(Colors.grey[400]!, 9, false),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Long APT input box
                    Container(
                      width: wid,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 35,
                                height: 35,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    scale: 0.5,
                                    image: AssetImage(
                                        "assets/images/apt_noninverted.png"),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Long APTs",
                                  style: textStyle(Colors.white, 15, false),
                                ),
                              ),
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: wid * 0.4),
                                child: IntrinsicWidth(
                                  child: TextField(
                                    controller: _longInputController,
                                    style:
                                        textStyle(Colors.grey[400]!, 22, false),
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: textStyle(
                                          Colors.grey[400]!, 22, false),
                                      contentPadding: isWeb
                                          ? EdgeInsets.all(9)
                                          : EdgeInsets.all(6),
                                      border: InputBorder.none,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp(r'^(\d+)?\.?\d{0,6}'))),
                                    ],
                                    onChanged: (value) {
                                      if (value == '') {
                                        value = '0.00';
                                      }
                                      _shortInputController.text = value;
                                      double newAmount = double.parse(value);
                                      lspController.updateRedeemAmt(newAmount);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          showLongBalance()
                        ],
                      ),
                    ),
                    Container(height: 10),
                    Container(
                      width: wid,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 35,
                                height: 35,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    scale: 0.5,
                                    image: AssetImage(
                                        "assets/images/apt_inverted.png"),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Short APTs",
                                  style: textStyle(Colors.white, 15, false),
                                ),
                              ),
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: wid * 0.4),
                                child: IntrinsicWidth(
                                  child: TextField(
                                    controller: _shortInputController,
                                    style:
                                        textStyle(Colors.grey[400]!, 22, false),
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: textStyle(
                                          Colors.grey[400]!, 22, false),
                                      contentPadding: isWeb
                                          ? EdgeInsets.all(9)
                                          : EdgeInsets.all(6),
                                      border: InputBorder.none,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp(r'^(\d+)?\.?\d{0,6}'))),
                                    ],
                                    onChanged: (value) {
                                      if (value == '') {
                                        value = '0.00';
                                      }
                                      _longInputController.text = value;
                                      double newAmount = double.parse(value);
                                      lspController.updateRedeemAmt(newAmount);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          showShortBalance()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
              showYouReceive(),
              Container(
                width: wid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 30.0),
                      width: 175,
                      height: 45,
                      decoration: boxDecoration(
                          Colors.amber[500]!.withOpacity(0.20),
                          500,
                          1,
                          Colors.transparent),
                      child: TextButton(
                        onPressed: () async {
                          final result = await lspController.redeem();

                          if (result) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    confirmTransaction(context, true, ""));
                          }
                        },
                        child: Text(
                          "Confirm",
                          style: textStyle(Colors.amber[500]!, 16, false),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    lspController.updateRedeemAmt(0);
    _longInputController.dispose();
    _shortInputController.dispose();
    super.dispose();
  }
}
