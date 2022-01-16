// ignore_for_file: non_constant_identifier_names

import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

//dynamic
Dialog wrongNetworkDialog(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 450;
  double hgt = 200;
  double edge = 75;
  if (_width < 405) wid = _width;
  if (_height < 505) hgt = _height * 0.45;
  double wid_child = wid - edge;
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: EdgeInsets.all(20),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Wrong Network",
                style: textStyle(Colors.white, 18, true, false),
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    Controller.switchNetwork();
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                width: wid_child,
                height: 45,
                decoration: boxDecoration(
                    Colors.transparent, 100, 2, Colors.purple[900]!),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Switch to Matic Network",
                    style: textStyle(Colors.white, 16, false, false),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

//dynamic
Dialog walletDialog(BuildContext context) {
  Controller controller = Get.find();
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 450;
  double hgt = 200;
  double edge = 75;
  double wid_child = wid - edge;
  if (_width < 405) wid = _width;
  if (_height < 505) hgt = _height * 0.45;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: EdgeInsets.all(20),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Wallet",
                style: textStyle(Colors.white, 18, true, false),
              ),
              Container(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      )))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                width: wid_child,
                height: 45,
                decoration: boxDecoration(
                    Colors.transparent, 100, 2, Colors.grey[400]!),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.connect();
                    // if (controller.networkID != Controller.TESTNET_CHAIN_ID) {
                    //   showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) =>
                    //           wrongNetworkDialog(context));
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("../assets/images/fox.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        "Metamask",
                        style: textStyle(Colors.white, 16, false, false),
                      ),
                      //empty container
                      Container(
                        margin: EdgeInsets.only(left: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Dialog depositDialog(BuildContext context) {
  double amount = 0;
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 390;
  double edge = 60;
  if (_width < 395) wid = _width;
  double hgt = 450;
  if (_height < 455) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Deposit AX",
                style: textStyle(Colors.white, 20, false, false),
              ),
              Container(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      )))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Amount Box
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(10),
                width: wid - edge,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(width: 10),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("../assets/images/x.jpg"),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        "AX",
                        style: textStyle(Colors.white, 15, false, false),
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 35,
                      decoration: boxDecoration(
                          Colors.transparent, 100, 0.5, Colors.grey[400]!),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Max",
                          style: textStyle(Colors.grey[400]!, 9, false, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {
                          amount = double.parse(value);
                          print(amount);
                        },
                        style: textStyle(Colors.grey[400]!, 22, false, false),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle:
                              textStyle(Colors.grey[400]!, 22, false, false),
                          contentPadding: const EdgeInsets.all(9),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current AX Staked",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
              Text(
                "1,000 AX",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 55),
                child: Text(
                  "+",
                  style: textStyle(Colors.grey[400]!, 14, false, false),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Funds Added",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
              Text(
                "100 AX",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("New Staked Balance"),
              Text("1,100 AX"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                width: 175,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.amber[400],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            depositConfimed(context));
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

// dynamic
Dialog dualDepositDialog(BuildContext context, Athlete athlete) {
  double amount = 0;
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 390;
  double edge = 60;
  if (_width < 395) wid = _width;
  double hgt = 450;
  if (_height < 455) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
        height: hgt,
        width: wid,
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  width: wid - edge,
                  margin: EdgeInsets.only(top: 25, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: Text(
                        "Deposit Liquidity",
                        style: textStyle(Colors.white, 20, false, false),
                      )),
                      Container(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.white,
                              )))
                    ],
                  )),
              Container(
                  width: wid - edge,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "*Add liquidity to supply LP tokens to your wallet\nDeposit LP tokens to AX rewards",
                    style: textStyle(Colors.grey[600]!, 11, false, false),
                  )),
              //Amount Box
              Container(
                width: wid - edge,
                height: 55,
                decoration: boxDecoration(
                    Colors.transparent, 14, 0.5, Colors.grey[400]!),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(width: 10),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("../assets/images/x.jpg"),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        "AX",
                        style: textStyle(Colors.white, 15, false, false),
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 35,
                      decoration: boxDecoration(
                          Colors.transparent, 100, 0.5, Colors.grey[400]!),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Max",
                          style: textStyle(Colors.grey[400]!, 9, false, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {
                          amount = double.parse(value);
                          print(amount);
                        },
                        style: textStyle(Colors.grey[400]!, 22, false, false),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle:
                              textStyle(Colors.grey[400]!, 22, false, false),
                          contentPadding: const EdgeInsets.all(9),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Amount Box
              Container(
                  width: wid - edge,
                  height: 55,
                  decoration: boxDecoration(
                      Colors.transparent, 14, 0.5, Colors.grey[400]!),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(width: 10),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            scale: 0.5,
                            image: AssetImage("../assets/images/apt.png"),
                          ),
                        ),
                      ),
                    Container(width: 15),
                      Expanded(
                        child: Text(
                          athlete.name + " APT",
                          style: textStyle(Colors.white, 15, false, false),
                        ),
                      ),
                      Container(
                        height: 18,
                        width: 35,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Max",
                            style:
                                textStyle(Colors.grey[400]!, 9, false, false),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          onChanged: (value) {
                            amount = double.parse(value);
                            print(amount);
                          },
                          style: textStyle(Colors.grey[400]!, 22, false, false),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle:
                                textStyle(Colors.grey[400]!, 22, false, false),
                            contentPadding: const EdgeInsets.all(9),
                            border: InputBorder.none,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(
                  width: 175,
                  height: 35,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 1, Colors.amber[400]!),
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                depositConfimed(context));
                      },
                      child: Text("Add Liquidity",
                          style:
                              textStyle(Colors.amber[400]!, 20, true, false)))),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text("LP Tokens: " + "0",
                    style: textStyle(Colors.white, 18, true, false)),
              ),
              Container(
                width: 175,
                height: 35,
                decoration: boxDecoration(Colors.grey, 100, 1, Colors.grey),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            depositConfimed(context));
                  },
                  child: Text("Deposit",
                      style: textStyle(Colors.black, 16, true, false)),
                ),
              )
            ],
          ),
        )),
  );
}

// dynamic
Dialog buyDialog(BuildContext context, Athlete athlete) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 400;
  double edge = 40;
  if (_width < 405) wid = _width;
  double hgt = 500;
  if (_height < 505) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              height: 80,
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Buy " + athlete.name + " APT",
                      style: textStyle(Colors.white, 20, false, false)),
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
            height: 45,
            width: wid - edge,
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "You can redeem APT's at their Book Value for AX.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                  TextSpan(
                      text: " You can buy AX on the Matic network through",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                  TextSpan(
                      text: " SushiSwap",
                      style: TextStyle(color: Colors.amber[400], fontSize: 15)),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: wid - edge,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Learn How to buy AX",
                    style: TextStyle(color: Colors.amber[400], fontSize: 15),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        String urlString =
                            "https://athletex-markets.gitbook.io/athletex-huddle/how-to.../buy-ax-coin";
                        launch(urlString);
                      },
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: wid - edge,
                    child: Text(
                      "Input AX:",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Container(
                      width: wid - edge,
                      height: 55,
                      decoration: boxDecoration(
                          Colors.transparent, 14, 0.5, Colors.grey[400]!),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(width: 15),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("../assets/images/x.jpg"),
                              ),
                            ),
                          ),
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              "AX",
                              style: textStyle(Colors.white, 15, false, false),
                            ),
                          ),
                          Container(
                            height: 18,
                            width: 35,
                            decoration: boxDecoration(Colors.transparent, 100,
                                0.5, Colors.grey[400]!),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Max",
                                style: textStyle(
                                    Colors.grey[400]!, 9, false, false),
                              ),
                            ),
                          ),
                          Container(width: 25),
                          SizedBox(
                            width: 70,
                            child: TextFormField(
                              style: textStyle(
                                  Colors.grey[400]!, 22, false, false),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: textStyle(
                                    Colors.grey[400]!, 22, false, false),
                                border: InputBorder.none,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              )),
          Container(
            height: 30,
            child: Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
          ),
          Container(
              width: wid - edge,
              height: 125,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "1.2 AX per " + athlete.name + " APT",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "LP Fee",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "0.5 AX",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Market Price Impact",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "-0.04%",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Minimum Recieved",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "L.J.APT",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Estimated Slippage",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "~5%",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Container(
            width: wid - edge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    "You recieve:",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "100 " + athlete.name + " APT",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 75,
            width: wid - edge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.amber[400],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TextButton(
                    //onPressed: () => showDialog(context: context, builder: (BuildContext context) => confirmTransaction(context)),
                    onPressed: () async {
                      Navigator.pop(context);
                      EthereumAddress aptAddress = EthereumAddress.fromHex(
                          "0x192AB27a6d1d3885e1022D2b18Dd7597272ebD22");
                      bool confirmed;
                      String txString =
                          "0x192AB27a6d1d3885e1022D2b18Dd7597272ebD22";
                      try {
                        confirmed = true;
                      } catch (e) {
                        confirmed = false;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              confirmTransaction(context, confirmed, txString));
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ))),
    ),
  );
}

// dynamic
Dialog sellDialog(BuildContext context, Athlete athlete) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 400;
  double edge = 40;
  if (_width < 405) wid = _width;
  double hgt = 500;
  if (_height < 505) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: wid - edge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sell " + athlete.name + " APT",
                        style: textStyle(Colors.white, 20, false, false)),
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
              width: wid - edge,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: "You can sell APT's at Market Price for AX.",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 15)),
                    TextSpan(
                        text:
                            " You can access other funds with AX on the Matic network through",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 15)),
                    TextSpan(
                        text: " SushiSwap",
                        style:
                            TextStyle(color: Colors.amber[400], fontSize: 15)),
                  ],
                ),
              ),
            ),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: wid - edge,
                  child: Text(
                    "Input APT:",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: wid - edge,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 0.5,
                    ),
                  ),
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
                            image: AssetImage("../assets/images/apt.png"),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          athlete.name + " APT",
                          style: textStyle(Colors.white, 15, false, false),
                        ),
                      ),
                      Container(
                        height: 18,
                        width: 35,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Max",
                            style:
                                textStyle(Colors.grey[400]!, 9, false, false),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          style: textStyle(Colors.grey[400]!, 22, false, false),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle:
                                textStyle(Colors.grey[400]!, 22, false, false),
                            contentPadding: const EdgeInsets.all(9),
                            border: InputBorder.none,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Container(
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            Container(
                width: wid - edge,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text("Price",
                              style: textStyle(Colors.white, 15, false, false)),
                        ),
                        Container(
                          child: Text("0.8 " + athlete.name + " APT per AX",
                              style: textStyle(Colors.white, 15, false, false)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "LP Fee",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "0.5 AX",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Market Price Impact",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "-0.04%",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Minimum Recieved",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "L.J.APT",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Estimated Slippage",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "~5%",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "You recieve:",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "120 AX",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    width: 175,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(100),
                    ),
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
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
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

// dynamic
Dialog redeemDialog(BuildContext context, Athlete athlete) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 370;
  double edge = 40;
  if (_width < 375) wid = _width;
  double hgt = 450;
  if (_height < 455) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: wid - edge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Redeem " + athlete.name + " APT",
                        style: textStyle(Colors.white, 20, false, false)),
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
              width: wid - edge,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "You can redeem APT's at their Book Value for AX.",
                      style: textStyle(Colors.grey[600]!, 15, false, false),
                    ),
                    TextSpan(
                      text:
                          " You can access other funds with AX on the Matic network through",
                      style: textStyle(Colors.grey[600]!, 15, false, false),
                    ),
                    TextSpan(
                      text: " SushiSwap",
                      style: textStyle(Colors.amber[400]!, 15, false, false),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: wid - edge,
                  child: Text(
                    "Input APT:",
                    style: textStyle(Colors.grey[600]!, 15, false, false),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: wid - edge,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 0.5,
                    ),
                  ),
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
                            image: AssetImage("../assets/images/apt.png"),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          athlete.name + " APT",
                          style: textStyle(Colors.white, 15, false, false),
                        ),
                      ),
                      Container(
                        height: 18,
                        width: 35,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Max",
                            style:
                                textStyle(Colors.grey[400]!, 9, false, false),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          style: textStyle(Colors.grey[400]!, 22, false, false),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle:
                                textStyle(Colors.grey[400]!, 22, false, false),
                            contentPadding: const EdgeInsets.all(9),
                            border: InputBorder.none,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Container(
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            Container(
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "You recieve:",
                      style: textStyle(Colors.white, 15, false, false),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "120 AX",
                      style: textStyle(Colors.white, 15, false, false),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    width: 175,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                confirmTransaction(context, true, ""));
                      },
                      child: Text(
                        "Confirm",
                        style: textStyle(Colors.black, 16, false, false),
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

// dynamic
Dialog mintDialog(BuildContext context, Athlete athlete) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 370;
  double edge = 40;
  if (_width < 375) wid = _width;
  double hgt = 450;
  if (_height < 455) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: wid - edge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Mint " + athlete.name + " APT",
                        style: textStyle(Colors.white, 20, false, false)),
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
              width: wid - edge,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "You can mint APT's at their Book Value for AX.",
                      style: textStyle(Colors.grey[600]!, 15, false, false),
                    ),
                    TextSpan(
                      text: " You can buy AX on the Matic network through",
                      style: textStyle(Colors.grey[600]!, 15, false, false),
                    ),
                    TextSpan(
                      text: " SushiSwap",
                      style: textStyle(Colors.amber[400]!, 15, false, false),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: wid - edge,
                  child: Text(
                    "Input AX:",
                    style: textStyle(Colors.grey[600]!, 15, false, false),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: wid - edge,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 0.5,
                    ),
                  ),
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
                            image: AssetImage("../assets/images/x.jpg"),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          "AX",
                          style: textStyle(Colors.white, 15, false, false),
                        ),
                      ),
                      Container(
                        height: 18,
                        width: 35,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Max",
                            style:
                                textStyle(Colors.grey[400]!, 9, false, false),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          style: textStyle(Colors.grey[400]!, 22, false, false),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle:
                                textStyle(Colors.grey[400]!, 22, false, false),
                            contentPadding: const EdgeInsets.all(9),
                            border: InputBorder.none,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Container(
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            Container(
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "You recieve:",
                      style: textStyle(Colors.white, 15, false, false),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "120 AX",
                      style: textStyle(Colors.white, 15, false, false),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    width: 175,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                confirmTransaction(context, true, ""));
                      },
                      child: Text(
                        "Confirm",
                        style: textStyle(Colors.black, 16, false, false),
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

// dynamic
Dialog confirmTransaction(
    BuildContext context, bool IsConfirmed, String txString) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 500;
  double edge = 40;
  if (_width < 505) wid = _width;
  double hgt = 335;
  if (_height < 340) hgt = _height;

  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          height: hgt,
          width: wid,
          decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          child: Center(
              child: Container(
            height: 275,
            width: wid - edge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(width: 5),
                        Container(
                          child: Text("Transaction Confirmed",
                              style: textStyle(Colors.white, 20, false, false)),
                        ),
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 150,
                        color: Colors.amber[400],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 275,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Controller.viewTx();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "View on Polygonscan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ))));
}

// dynamic
Dialog rewardsClaimed(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 500;
  double edge = 40;
  if (_width < 505) wid = _width;
  double hgt = 335;
  if (_height < 340) hgt = _height;

  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          height: hgt,
          width: wid,
          decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          child: Center(
              child: Container(
            height: 275,
            width: wid - edge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(width: 5),
                        Container(
                          child: Text("Rewards Claimed",
                              style: textStyle(Colors.white, 20, false, false)),
                        ),
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 150,
                        color: Colors.amber[400],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 275,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "View on Polygonscan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ))));
}

// dynamic
Dialog removalConfimed(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 500;
  double edge = 40;
  if (_width < 505) wid = _width;
  double hgt = 335;
  if (_height < 340) hgt = _height;

  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          height: hgt,
          width: wid,
          decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          child: Center(
              child: Container(
            height: 275,
            width: wid - edge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(width: 5),
                        Container(
                          child: Text("Removal Confirmed",
                              style: textStyle(Colors.white, 20, false, false)),
                        ),
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 150,
                        color: Colors.amber[400],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 275,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "View on Polygonscan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ))));
}

// dynamic
Dialog depositConfimed(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 500;
  double edge = 40;
  if (_width < 505) wid = _width;
  double hgt = 335;
  if (_height < 340) hgt = _height;

  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          height: hgt,
          width: wid,
          decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          child: Center(
              child: Container(
            height: 275,
            width: wid - edge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(width: 5),
                        Container(
                          child: Text("Deposit Confirmed",
                              style: textStyle(Colors.white, 20, false, false)),
                        ),
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 150,
                        color: Colors.amber[400],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 275,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "View on Polygonscan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ))));
}

// dynamic
Dialog yourAXDialog(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 400;
  double edge = 40;
  if (_width < 405) wid = _width;
  double hgt = 500;
  if (_height < 505) hgt = _height;

  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          height: hgt,
          width: wid,
          decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          child: Container(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                Container(
                    height: 80,
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Your AX",
                            style: textStyle(Colors.white, 20, false, false)),
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
                // 'X' logo
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * (wid - 0.04),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      scale: 2.0,
                      image: AssetImage('../assets/images/x.jpg'),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 65,
                  alignment: Alignment.center,
                  child: Text("100.00",
                      style: textStyle(Colors.white, 20, false, false)),
                ),
                Container(
                    width: wid - edge,
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Balance:",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "100 AX",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Unlcaimed:",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "50 AX",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                  child: Divider(
                    thickness: 0.35,
                    color: Colors.grey[400],
                  ),
                ),
                Container(
                    width: wid - edge,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "AX price:",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "\$1.00",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "AX in circulation",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "50,000,000",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "AX total supply:",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "100,000,000",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                    height: 80,
                    width: wid - edge,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                              width: 150,
                              height: 30,
                              decoration: boxDecoration(Colors.amber[600]!, 100,
                                  0, Colors.amber[600]!),
                              child: TextButton(
                                  onPressed: () {},
                                  child: Text("Buy AX",
                                      style: textStyle(
                                          Colors.black, 14, true, false)))),
                          Container(
                              width: 150,
                              height: 30,
                              decoration: boxDecoration(Colors.transparent, 100,
                                  0, Colors.amber[600]!),
                              child: TextButton(
                                  onPressed: () {},
                                  child: Text("+ Add to Wallet",
                                      style: textStyle(Colors.amber[600]!, 14,
                                          true, false)))),
                        ])),
              ])))));
}

// dynamic
Dialog accountDialog(BuildContext context) {
  // double wid = 475;
  // double hgt = 200;
  Controller controller = Get.find();
  String accNum = "${controller.publicAddress}";
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 400;
  double edge = 40;
  double edge2 = 60;
  if (_width < 405) wid = _width;
  double hgt = 240;
  if (_height < 235) hgt = _height;

  String retStr = accNum;
  if (accNum.length > 15)
    retStr = accNum.substring(0, 7) +
        "..." +
        accNum.substring(accNum.length - 5, accNum.length);

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
        height: hgt,
        width: wid,
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        alignment: Alignment.center,
        child: Container(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // title
            Container(
                width: wid - edge,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Account",
                        style: textStyle(Colors.white, 20, false, false)),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                )),
            // inner box
            Container(
              width: wid - edge,
              height: 145,
              decoration:
                  boxDecoration(Colors.transparent, 14, .5, Colors.grey[400]!),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: wid - edge2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              height: 65,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Connected With Metamask",
                                      style: textStyle(
                                          Colors.grey[600]!, 13, false, false)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.account_balance_wallet,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "$retStr",
                                        style: textStyle(
                                            Colors.white, 20, false, false),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Container(
                              height: 65,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      width: 75,
                                      height: 25,
                                      decoration: boxDecoration(
                                          Colors.transparent,
                                          100,
                                          0,
                                          Colors.blue[800]!),
                                      child: TextButton(
                                          onPressed: () {
                                            controller.changeAddress();
                                          },
                                          child: Text("Change",
                                              style: textStyle(
                                                  Colors.blue[300]!,
                                                  10,
                                                  true,
                                                  false)))),
                                  Container(
                                      width: 75,
                                      height: 25,
                                      decoration: boxDecoration(
                                          Colors.transparent,
                                          100,
                                          0,
                                          Colors.red[900]!),
                                      child: TextButton(
                                          onPressed: () {
                                            controller.disconnect();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Disconnect",
                                              style: textStyle(Colors.red[900]!,
                                                  10, true, false)))),
                                ],
                              ))
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: "${controller.publicAddress}"));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Icon(
                              Icons.filter_none,
                              color: Colors.grey,
                            ),
                            Text("Copy Address",
                                style: textStyle(
                                    Colors.grey[400]!, 15, false, false)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          String address =
                              controller.publicAddress.value.toString();
                          String urlString =
                              "https://polygonscan.com/address/$address";
                          launch(urlString);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Icon(
                              Icons.open_in_new,
                              color: Colors.grey,
                            ),
                            Text("Show on Polygonscan",
                                style: textStyle(
                                    Colors.grey[400]!, 15, false, false)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )))),
  );
}

// dynamic
Dialog removeDialog(BuildContext context) {
  
  double amount = 0;
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 390;
  double edge = 60;
  if (_width < 395) wid = _width;
  double hgt = 450;
  if (_height < 455) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Remove AX",
                style: textStyle(Colors.white, 20, false, false),
              ),
              Container(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      )))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Amount Box
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(10),
                width: wid - edge,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "AX",
                        style: textStyle(Colors.white, 15, false, false),
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 35,
                      decoration: boxDecoration(
                          Colors.transparent, 100, 0.5, Colors.grey[400]!),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Max",
                          style: textStyle(Colors.grey[400]!, 9, false, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {
                          amount = double.parse(value);
                          print(amount);
                        },
                        style: textStyle(Colors.grey[400]!, 22, false, false),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle:
                              textStyle(Colors.grey[400]!, 22, false, false),
                          contentPadding: const EdgeInsets.all(9),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current AX Staked",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
              Text(
                "1,000 AX",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 55),
                child: Text(
                  "-",
                  style: textStyle(Colors.grey[400]!, 14, false, false),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Funds Removed",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
              Text(
                "100 AX",
                style: textStyle(Colors.grey[400]!, 14, false, false),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("New Staked Balance"),
              Text("1,000 AX"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                width: 175,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.amber[400],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            removalConfimed(context));
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Dialog swapDialog(BuildContext context) {
  SwapController swapController = Get.find();

  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 450,
        width: MediaQuery.of(context).size.width * 0.25,
        padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // Confirm Swap
          children: <Widget>[
            Container(
              //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              width: MediaQuery.of(context).size.width * .22,
              height: 50,
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Confirm Swap",
                    style: textStyle(Colors.white, 20, false, false),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .22,
              height: 50,
              //color: Colors.red,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "From",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "-\$1.600",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          swapController.activeTkn1.value.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${swapController.amount1.value}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .22,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .22,
              height: 50,
              //color: Colors.red,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "To",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "-\$1.580",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          swapController.activeTkn2.value.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${swapController.amount2.value}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Horizontal Linebreak
            Container(
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            // Price Information and Confirm Swap Button
            Container(
              //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              width: MediaQuery.of(context).size.width * .22,
              height: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${swapController.price} " +
                              swapController.activeTkn1.value.ticker +
                              " per " +
                              swapController.activeTkn2.value.ticker,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "LP Fee",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "0.5 AX",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Market Price Impact",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "-0.04%",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Minimum Recieved",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "8.2 " + swapController.activeTkn2.value.ticker,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Estimated Slippage",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "~5%",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .22,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "You recieve:",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "7.98 " + swapController.activeTkn2.value.name,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    width: 210,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextButton(
                      //onPressed: () => showDialog(context: context, builder: (BuildContext context) => confirmTransaction(context)),
                      onPressed: () {
                        print('swapping!');
                        swapController.swap();
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                confirmTransaction(context, true, ""));
                      },
                      child: const Text(
                        "Confirm Swap",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
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
