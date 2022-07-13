// ignore_for_file: non_constant_identifier_names
import 'package:ax_dapp/pages/connectWallet/MobileLoginPage.dart';
import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/service/ApproveButton.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Pool/PoolController.dart';
import 'package:ax_dapp/service/Controller/Scout/LSPController.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> testFunction() async {
  print("[Console] hello world");
  return;
}

Dialog connectMetamaskDialog(BuildContext context) {
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
                "Metamask wallet",
                style: textStyle(Colors.white, 18, true),
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
            children: <Widget>[
              Text('Couldn\'t find MetaMask extension',
                  style: TextStyle(color: Colors.grey[400]))
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
                    launchUrl(Uri.parse('https://metamask.io/download/'));
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Install MetaMask extension",
                    style: textStyle(Colors.white, 16, false),
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
                style: textStyle(Colors.white, 18, true),
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
                width: wid_child,
                height: 45,
                decoration: boxDecoration(
                    Colors.transparent, 100, 2, Colors.purple[900]!),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // controller.switchNetwork();
                  },
                  child: Text(
                    "Switch to Matic Network",
                    style: textStyle(Colors.white, 16, false),
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
  WalletController walletController = Get.find();

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: LayoutBuilder(
      builder: ((context, constraints) => Container(
        constraints: BoxConstraints(minHeight: 235, maxHeight: 250),
        height: constraints.maxHeight * 0.26,
        width: constraints.maxWidth * 0.27,
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
                  style: textStyle(Colors.white, 18, true),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  width: constraints.maxWidth < 450 ? constraints.maxWidth * 0.62 : constraints.maxWidth * 0.22,
                  height: 45,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 2, Colors.grey[400]!),
                  child: TextButton(
                    onPressed: () {
                      controller.connect().then((response) {
                        if (response == -1) {
                          // No MetaMask
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  connectMetamaskDialog(context));
                        } else if (response == 0) {
                          // Wrong network
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  wrongNetworkDialog(context));
                        } else {
                          Navigator.pop(context);
                          walletController.getTokenMetrics();
                          walletController.getYourAxBalance();
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/fox.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          "Metamask",
                          style: textStyle(Colors.white, 16, false),
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              width: constraints.maxWidth < 450 ? constraints.maxWidth * 0.62 : constraints.maxWidth * 0.22,
              height: 45,
              decoration:
                  boxDecoration(Colors.transparent, 100, 2, Colors.grey[400]!),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MobileLoginPage()));
                },
                child: Text(
                  "Add/Create wallet",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      )),
    ),
  );
}

// dynamic
Dialog redeemDialog(BuildContext context, AthleteScoutModel athlete) {
  bool isWeb = true;
  isWeb =
      kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
  double _height = MediaQuery.of(context).size.height;
  double wid = isWeb ? 370 : 355;
  double edge = 40;
  double hgt = 430;
  if (_height < 435) hgt = _height;
  LSPController lspController = Get.find();

  return Dialog(
    insetPadding: EdgeInsets.zero,
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
                    Text("Redeem " + athlete.name + " APT Pair",
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
              width: wid - edge,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "You can redeem APT's at their Book Value for AX.",
                      style:
                          textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                    ),
                    TextSpan(
                      text:
                          " You can access other funds with AX on the Matic network through",
                      style:
                          textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                    ),
                    TextSpan(
                      text: " SushiSwap",
                      style:
                          textStyle(Colors.amber[400]!, isWeb ? 14 : 12, false),
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
                    isWeb ? "Input APT pair:" : "Input APT pair and amount:",
                    style: textStyle(Colors.grey[600]!, 14, false),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
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
                            scale: 0.5,
                            image:
                                AssetImage("assets/images/apt_noninverted.png"),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          "Long APTs",
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
                          onChanged: (value) {
                            double newAmount = double.parse(value);
                            lspController.updateRedeemAmt(newAmount);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
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
                            scale: 0.5,
                            image: AssetImage("assets/images/apt_inverted.png"),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          "Short APTs",
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
                          onChanged: (value) {
                            double newAmount = double.parse(value);
                            lspController.updateRedeemAmt(newAmount);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "You receive:",
                    style: textStyle(Colors.white, 15, false),
                  ),
                  Text(
                    "120 AX",
                    style: textStyle(Colors.white, 15, false),
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
                    decoration: boxDecoration(
                        Colors.amber[500]!.withOpacity(0.20),
                        500,
                        1,
                        Colors.transparent),
                    child: TextButton(
                      onPressed: () {
                        lspController.redeem();
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                confirmTransaction(context, true, ""));
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

// dynamic
Dialog mintDialog(BuildContext context, AthleteScoutModel athlete) {
  bool isWeb = true;
  isWeb =
      kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
  double _height = MediaQuery.of(context).size.height;
  double wid = isWeb ? 370 : 355;
  double edge = 40;
  double hgt = 390;
  if (_height < 395) hgt = _height;

  LSPController lspController = Get.find();

  return Dialog(
    insetPadding: EdgeInsets.zero,
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
                    Text("Mint " + athlete.name + " APT Pair",
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
              width: wid - edge,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "You can mint APTs at their Book Value with AX.",
                      style:
                          textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                    ),
                    TextSpan(
                      text: " You can buy AX on the Matic network through",
                      style:
                          textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                    ),
                    TextSpan(
                      text: " SushiSwap",
                      style:
                          textStyle(Colors.amber[400]!, isWeb ? 14 : 12, false),
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
                    style: textStyle(Colors.grey[600]!, 14, false),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
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
                            image:
                                AssetImage("assets/images/apt_noninverted.png"),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          athlete.name + " APT",
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
                          onChanged: (value) {
                            double newAmount = double.parse(value);
                            print("new create amt $newAmount");
                            lspController.updateCreateAmt(newAmount);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            Container(
              //margin: EdgeInsets.only(top: 15.0),
              width: wid - edge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "You receive:",
                    style: textStyle(Colors.white, 15, false),
                  ),
                  Center(
                    child: Obx(
                      () => Text(
                        "${lspController.createAmt} Long APTs"
                        " + "
                        "${lspController.createAmt} Short APTs",
                        style: textStyle(Colors.white, 15, false),
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
                    margin: EdgeInsets.only(bottom: 30.0),
                    width: 175,
                    height: 45,
                    decoration: isWeb
                        ? boxDecoration(
                            Colors.amber[400]!, 500, 1, Colors.amber[400]!)
                        : boxDecoration(Colors.amber[500]!.withOpacity(0.20),
                            500, 1, Colors.transparent),
                    child: TextButton(
                      onPressed: () {
                        // call mint functionality
                        lspController.mint();
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                confirmTransaction(context, true, ""));
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
    ),
  );
}

// dynamic
Dialog confirmTransaction(
    BuildContext context, bool IsConfirmed, String txString) {
  bool isWeb = true;
  isWeb =
      kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
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
                              style: textStyle(Colors.white, 20, false)),
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
                      decoration: isWeb
                          ? boxDecoration(
                              Colors.amber[400]!, 500, 1, Colors.amber[400]!)
                          : boxDecoration(Colors.amber[500]!.withOpacity(0.20),
                              500, 1, Colors.transparent),
                      child: TextButton(
                        onPressed: () {
                          Controller.viewTx();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "View on Polygonscan",
                          style: isWeb
                              ? textStyle(Colors.black, 16, false)
                              : textStyle(Colors.amber[500]!, 16, false),
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
Dialog removalConfirmed(BuildContext context) {
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
                              style: textStyle(Colors.white, 20, false)),
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
Dialog transactionConfirmed(BuildContext context) {
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
                              style: textStyle(Colors.white, 20, false)),
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
  WalletController walletController = Get.find();
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
                            style: textStyle(Colors.white, 20, false)),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            walletController.getTokenMetrics();
                            walletController.getYourAxBalance();
                            Navigator.pop(context);
                          },
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
                      image: AssetImage('assets/images/x.jpg'),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 65,
                  alignment: Alignment.center,
                  child: Text("${walletController.yourBalance} AX",
                      style: textStyle(Colors.white, 20, false)),
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
                            Text(
                              "Balance:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            Obx(
                              () => Text(
                                "${walletController.yourBalance} AX",
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
                            Text(
                              "AX price:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "${walletController.axPrice} USD",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "AX in circulation:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "${walletController.axCirculation}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "AX total supply:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "${walletController.axTotalSupply}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
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
                                  onPressed: () {
                                    walletController.buyAX();
                                  },
                                  child: Text("Buy AX",
                                      style:
                                          textStyle(Colors.black, 14, true)))),
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
                    Text("Account", style: textStyle(Colors.white, 20, false)),
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
                                          Colors.grey[600]!, 13, false)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.account_balance_wallet,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "$retStr",
                                        style:
                                            textStyle(Colors.white, 20, false),
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
                                                  true)))),
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
                                                  10, true)))),
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
                                style: textStyle(Colors.grey[400]!, 15, false)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          String address =
                              controller.publicAddress.value.toString();
                          String urlString =
                              "https://polygonscan.com/address/$address";
                          launchUrl(Uri.parse(urlString));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Icon(
                              Icons.open_in_new,
                              color: Colors.grey,
                            ),
                            Text("Show on Polygonscan",
                                style: textStyle(Colors.grey[400]!, 15, false)),
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

Dialog poolAddLiquidity(BuildContext context, String name) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 390;
  if (_width < 395) wid = _width;
  double hgt = 450;
  if (_height < 455) hgt = _height;
  PoolController poolController = Get.find();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Add Liquidity",
                        style: textStyle(Colors.white, 20, false),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ]),
                // AX & Athlete deposited
                Container(
                    child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "AX deposited:",
                          style: textStyle(Colors.grey[600]!, 16, false),
                        ),
                        Text("1000", style: textStyle(Colors.white, 16, false))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          name + " deposited:",
                          style: textStyle(Colors.grey[600]!, 16, false),
                        ),
                        Text("500", style: textStyle(Colors.white, 16, false))
                      ],
                    )
                  ],
                )),
                // ax per apt & share of pool
                Container(
                    child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "AX per " + name,
                          style: textStyle(Colors.grey[600]!, 16, false),
                        ),
                        Text("2.24", style: textStyle(Colors.white, 16, false))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          name + " per AX:",
                          style: textStyle(Colors.grey[600]!, 16, false),
                        ),
                        Text("1.48", style: textStyle(Colors.white, 16, false))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Share of pool:",
                          style: textStyle(Colors.grey[600]!, 16, false),
                        ),
                        Text("0.12%", style: textStyle(Colors.white, 16, false))
                      ],
                    )
                  ],
                )),
                Divider(thickness: 1, color: Colors.grey[600]),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "You will receive:",
                      style: textStyle(Colors.grey[600]!, 16, false),
                    )),
                // bottom receive amount
                Container(
                    width: wid - 100,
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: Text(
                              "20.24",
                              style: textStyle(Colors.white, 38, false),
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "AX/" + name,
                                  style: textStyle(Colors.white, 16, false),
                                ),
                                Text(
                                  "LP Tokens",
                                  style: textStyle(Colors.white, 16, false),
                                )
                              ],
                            )
                          ],
                        )),
                        Container(
                          child: Text(
                              "*Output is estimated. If the price changes by more than 2%, your transaction will revert.",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 11)),
                        ),
                      ],
                    )),
                ApproveButton(175, 40, "Approve", poolController.approve,
                    poolController.addLiquidity, transactionConfirmed)
              ])));
}

Dialog poolRemoveLiquidity(BuildContext context, String name) {
  PoolController poolController = Get.find();
  double amount = 0;
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = 390;
  if (_width < 395) wid = _width;
  double hgt = 525;
  if (_height < 530) hgt = _height;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Remove Liquidity",
                        style: textStyle(Colors.white, 20, false),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ]),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your position:",
                      style: textStyle(Colors.grey[600]!, 16, false),
                    )),
                // ax per apt & share of pool
                Container(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "AX/" + name + " LP Tokens:",
                              style: textStyle(Colors.white, 16, false),
                            ),
                            Text("20.24",
                                style: textStyle(Colors.white, 16, false))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Share of pool:",
                              style: textStyle(Colors.grey[600]!, 16, false),
                            ),
                            Text("0.12%",
                                style: textStyle(Colors.white, 16, false))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "AX deposited:",
                              style: textStyle(Colors.grey[600]!, 16, false),
                            ),
                            Text("1,000",
                                style: textStyle(Colors.white, 16, false))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              name + " deposited:",
                              style: textStyle(Colors.grey[600]!, 16, false),
                            ),
                            Text("500",
                                style: textStyle(Colors.white, 16, false))
                          ],
                        )
                      ],
                    )),
                Divider(thickness: 1, color: Colors.grey[600]),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Remove:",
                      style: textStyle(Colors.grey[600]!, 16, false),
                    )),
                Container(
                    width: wid,
                    decoration: boxDecoration(
                        Colors.transparent, 20, 0.5, Colors.grey[600]!),
                    child: Container(
                        width: wid - 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // LP Tokens
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Balance: 20.24",
                                      style: textStyle(
                                          Colors.grey[600]!, 9, false),
                                    ),
                                    Text(
                                      "LP Tokens",
                                      style: textStyle(Colors.white, 16, false),
                                    )
                                  ],
                                )),
                            // Max/amount
                            Container(
                              width: wid * .325,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      height: 17.5,
                                      width: 37.5,
                                      decoration: boxDecoration(
                                          Colors.transparent,
                                          100,
                                          0.5,
                                          Colors.grey[600]!),
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "MAX",
                                            style: textStyle(
                                                Colors.grey[600]!, 9, false),
                                          ))),
                                  SizedBox(
                                    width: 70,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        amount = double.parse(value);
                                        print(amount);
                                      },
                                      style: textStyle(
                                          Colors.grey[400]!, 22, false),
                                      decoration: InputDecoration(
                                        hintText: '0.00',
                                        hintStyle: textStyle(
                                            Colors.grey[400]!, 22, false),
                                        contentPadding: const EdgeInsets.all(9),
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
                            )
                          ],
                        ))),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "You will receive:",
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "AX per " + name,
                            style: textStyle(Colors.grey[600]!, 16, false),
                          ),
                          Text(
                            "1,000",
                            style: textStyle(Colors.white, 16, false),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            name + " per AX",
                            style: textStyle(Colors.grey[600]!, 16, false),
                          ),
                          Text(
                            "500",
                            style: textStyle(Colors.white, 16, false),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                ApproveButton(175, 40, "Approve", poolController.approve,
                    poolController.removeLiquidity, removalConfirmed)
              ])));
}

TextStyle textStyle(Color color, double size, bool isBold) {
  if (isBold)
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
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
