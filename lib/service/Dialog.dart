import 'dart:ui';
import 'package:ae_dapp/service/Controller.dart';
import 'package:ae_dapp/service/Controller/Token.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

Dialog wrongNetworkDialog(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width * 0.25,
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
                width: MediaQuery.of(context).size.width * 0.2,
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

Dialog walletDialog(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width * 0.25,
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
                width: MediaQuery.of(context).size.width * 0.2,
                height: 45,
                decoration: boxDecoration(
                    Colors.transparent, 100, 2, Colors.grey[400]!),
                child: TextButton(
                  onPressed: () {
                    Controller _controller = Controller();
                    _controller.connect();
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            wrongNetworkDialog(context));
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

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width * 0.25,
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
                width: MediaQuery.of(context).size.width * 0.2,
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
                  onPressed: () {},
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

Dialog buyDialog(BuildContext context, Athlete athlete) {
  double wid = 0.225;
  double hgt = 0.6;
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * hgt,
      width: MediaQuery.of(context).size.width * wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width * (wid - 0.04),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            "You can redeem APT's at their Book Value for AX.",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 15)),
                    TextSpan(
                        text: " You can buy AX on the Matic network through",
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
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * (wid - 0.04),
                    child: Text(
                      "Input AX:",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * (wid - 0.04),
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
                              style:
                                  textStyle(Colors.grey[400]!, 9, false, false),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextFormField(
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
              )
            ),
            Container(
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * (wid - 0.04),
                height: 100,
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
                            "1.2 AX per " + athlete.name + "APT",
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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

Dialog sellDialog(BuildContext context, Athlete athlete) {
  double wid = 0.225;
  double hgt = 0.6;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * hgt,
      width: MediaQuery.of(context).size.width * wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
                  width: MediaQuery.of(context).size.width * (wid - 0.04),
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
                  width: MediaQuery.of(context).size.width * (wid - 0.04),
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
                width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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

Dialog redeemDialog(BuildContext context, Athlete athlete) {
  double wid = 0.225;
  double hgt = 0.6;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * hgt,
      width: MediaQuery.of(context).size.width * wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
                  width: MediaQuery.of(context).size.width * (wid - 0.04),
                  child: Text(
                    "Input APT:",
                    style: textStyle(Colors.grey[600]!, 15, false, false),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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

Dialog mintDialog(BuildContext context, Athlete athlete) {
  double wid = 0.225;
  double hgt = 0.6;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * hgt,
      width: MediaQuery.of(context).size.width * wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
                    width: MediaQuery.of(context).size.width * (wid - 0.04),
                    child: Text(
                      "Input AX:",
                      style: textStyle(Colors.grey[600]!, 15, false, false),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              )
            ),
            Container(
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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

Dialog confirmTransaction(
    BuildContext context, bool IsConfirmed, String txString) {
  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width * .23,
          decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          child: Center(
              child: Container(
            height: 200,
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * .21,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(width: 40),
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
                        size: 90,
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

Dialog yourAXDialog(BuildContext context) {
  double wid = 0.3;
  double hgt = 0.6;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * hgt,
      width: MediaQuery.of(context).size.width * wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * (wid - 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Your AX", style: textStyle(Colors.white, 20, false, false)),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.0675,
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
              child: Text("100.00", style: textStyle(Colors.white, 20, false, false)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              )
            ),
            Container(
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * (wid - 0.04),
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
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.085,
                    height: MediaQuery.of(context).size.height*0.035,
                    decoration: boxDecoration(Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Buy AX",
                        style: textStyle(Colors.black, 14, true, false)
                      )
                    )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.085,
                    height: MediaQuery.of(context).size.height*0.035,
                    decoration: boxDecoration(Colors.transparent, 100, 0, Colors.amber[600]!),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "+ Add to Wallet",
                        style: textStyle(Colors.amber[600]!, 14, true, false)
                      )
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Dialog accountDialog(BuildContext context) {
  double wid = 475;
  double hgt = 200;

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
        height: hgt*0.875,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: wid*0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Account", style: textStyle(Colors.white, 20, false, false)),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: wid*0.925,
              height: hgt*0.6,
              decoration: boxDecoration(Colors.transparent, 14, .5, Colors.grey[400]!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: wid*.925*0.75,
                        height: hgt*0.275,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Connected With Metamask", style: textStyle(Colors.grey[600]!, 13, false, false)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                ),
                                Text(
                                  "0x24fd78...4c22",
                                  style: textStyle(Colors.white, 20, false, false),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      Container(
                        height: hgt*0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 75,
                              height: 25,
                              decoration: boxDecoration(Colors.transparent, 100, 0, Colors.blue[800]!),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Change",
                                  style: textStyle(Colors.blue[300]!, 10, true, false)
                                )
                              )
                            ),
                            Container(
                              width: 75,
                              height: 25,
                              decoration: boxDecoration(Colors.transparent, 100, 0, Colors.red[900]!),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Disconnect",
                                  style: textStyle(Colors.red[900]!, 10, true, false)
                                )
                              )
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Icon(
                              Icons.filter_none,
                              color: Colors.grey,
                            ),
                            Text("Copy Address", style: textStyle(Colors.grey[400]!, 15, false, false)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Icon(
                              Icons.open_in_new,
                              color: Colors.grey,
                            ),
                            Text("Show on Polygonscan", style: textStyle(Colors.grey[400]!, 15, false, false)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      )
    ),
  );
}

Dialog removeDialog(BuildContext context) {
  double amount = 0;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width * 0.25,
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
                width: MediaQuery.of(context).size.width * 0.2,
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
                  onPressed: () {},
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

Dialog swapDialog(BuildContext context, Token token1, Token token2){
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: 500,
      width: MediaQuery.of(context).size.width * 0.25,
      padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // Confirm Swap
        children: <Widget>[
          Container(
            //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            width: MediaQuery.of(context)
                    .size
                    .width *
                .22,
            height: 50,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Confirm Swap",
                  style: textStyle(Colors.white,
                      20, false, false),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () =>
                      Navigator.pop(context),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context)
                    .size
                    .width *
                .22,
            height: 50,
            //color: Colors.red,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
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
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        token1.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "10.24",
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
            width: MediaQuery.of(context)
                    .size
                    .width *
                .22,
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
          Container(
            width: MediaQuery.of(context)
                    .size
                    .width *
                .22,
            height: 50,
            //color: Colors.red,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
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
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        token2.name,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "8.48",
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
            width: MediaQuery.of(context)
                    .size
                    .width *
                .22,
            height: 125,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
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
                        "1.2 "+token1.ticker+" per "+token2.ticker,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
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
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
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
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
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
                        "8.2 "+token2.ticker,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
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
            ),
          ),
          Container(
            width: MediaQuery.of(context)
                    .size
                    .width *
                .22,
            height: 30,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 15.0),
                  child: Text(
                    "You recieve:",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 15.0),
                  child: Text(
                    "7.98 "+token2.name,
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
            width: MediaQuery.of(context)
                    .size
                    .width *
                .22,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 30.0, bottom: 10.0),
                  width: 210,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.amber[400],
                    borderRadius:
                        BorderRadius.circular(
                            100),
                  ),
                  child: TextButton(
                    //onPressed: () => showDialog(context: context, builder: (BuildContext context) => confirmTransaction(context)),
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext
                                  context) =>
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
    )
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
