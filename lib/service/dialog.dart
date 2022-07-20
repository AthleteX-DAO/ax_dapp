// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:developer';

import 'package:ax_dapp/pages/connect_wallet/mobile_login_page.dart';
import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/approve_button.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> testFunction() async {
  log('Test function invoked');
  return;
}

Dialog connectMetamaskDialog(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 450.0;
  var hgt = 200.0;
  const edge = 75.0;
  if (_width < 405) wid = _width;
  if (_height < 505) hgt = _height * 0.45;
  final wid_child = wid - edge;
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: const EdgeInsets.all(20),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Metamask wallet',
                style: textStyle(Colors.white, 18, true),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "Couldn't find MetaMask extension",
                style: TextStyle(color: Colors.grey[400]),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                width: wid_child,
                height: 45,
                decoration: boxDecoration(
                  Colors.transparent,
                  100,
                  2,
                  Colors.purple[900]!,
                ),
                child: TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('https://metamask.io/download/'));
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Install MetaMask extension',
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
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 450.0;
  var hgt = 200.0;
  const edge = 75.0;
  if (_width < 405) wid = _width;
  if (_height < 505) hgt = _height * 0.45;
  final wid_child = wid - edge;
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: const EdgeInsets.all(20),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wrong Network',
                style: textStyle(Colors.white, 18, true),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                width: wid_child,
                height: 45,
                decoration: boxDecoration(
                  Colors.transparent,
                  100,
                  2,
                  Colors.purple[900]!,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // controller.switchNetwork();
                  },
                  child: Text(
                    'Switch to Matic Network',
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
  final controller = Get.find<Controller>();
  final walletController = Get.find<WalletController>();

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) => Container(
        constraints: const BoxConstraints(minHeight: 235, maxHeight: 250),
        height: constraints.maxHeight * 0.26,
        width: constraints.maxWidth * 0.27,
        padding: const EdgeInsets.all(20),
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose Wallet',
                  style: textStyle(Colors.white, 18, true),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  width: constraints.maxWidth < 450
                      ? constraints.maxWidth * 0.62
                      : constraints.maxWidth * 0.22,
                  height: 45,
                  decoration: boxDecoration(
                    Colors.transparent,
                    100,
                    2,
                    Colors.grey[400]!,
                  ),
                  child: TextButton(
                    onPressed: () {
                      controller.connect().then((response) {
                        if (response == -1) {
                          // No MetaMask
                          Navigator.pop(context);
                          showDialog<void>(
                            context: context,
                            builder: connectMetamaskDialog,
                          );
                        } else if (response == 0) {
                          // Wrong network
                          Navigator.pop(context);
                          showDialog<void>(
                            context: context,
                            builder: wrongNetworkDialog,
                          );
                        } else {
                          Navigator.pop(context);
                          walletController
                            ..getTokenMetrics()
                            ..getYourAxBalance();
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/fox.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          'Metamask',
                          style: textStyle(Colors.white, 16, false),
                        ),
                        //empty container
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !kIsWeb,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                width: constraints.maxWidth < 450
                    ? constraints.maxWidth * 0.62
                    : constraints.maxWidth * 0.22,
                height: 45,
                decoration: boxDecoration(
                  Colors.transparent,
                  100,
                  2,
                  Colors.grey[400]!,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const MobileLoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Add/Create wallet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// dynamic
Dialog redeemDialog(BuildContext context, AthleteScoutModel athlete) {
  var isWeb = true;
  isWeb =
      kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
  final _height = MediaQuery.of(context).size.height;
  final wid = isWeb ? 370.0 : 355.0;
  const edge = 40.0;
  var hgt = 430.0;
  if (_height < 435) hgt = _height;
  final lspController = Get.find<LSPController>();

  return Dialog(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: wid - edge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Redeem ${athlete.name} APT Pair',
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
              ],
            ),
          ),
          SizedBox(
            width: wid - edge,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "You can redeem APT's at their Book Value for AX.",
                    style: textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                  ),
                  TextSpan(
                    text:
                        ''' You can access other funds with AX on the Matic network through''',
                    style: textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                  ),
                  TextSpan(
                    text: ' SushiSwap',
                    style:
                        textStyle(Colors.amber[400]!, isWeb ? 14 : 12, false),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: wid - edge,
                child: Text(
                  isWeb ? 'Input APT pair:' : 'Input APT pair and amount:',
                  style: textStyle(Colors.grey[600]!, 14, false),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: wid - edge,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 5),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          scale: 0.5,
                          image: AssetImage(
                            'assets/images/apt_noninverted.png',
                          ),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        'Long APTs',
                        style: textStyle(Colors.white, 15, false),
                      ),
                    ),
                    Container(
                      height: 28,
                      width: 48,
                      decoration: boxDecoration(
                        Colors.transparent,
                        100,
                        0.5,
                        Colors.grey[400]!,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'MAX',
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
                          contentPadding: isWeb
                              ? const EdgeInsets.all(9)
                              : const EdgeInsets.all(6),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,6}'),
                          ),
                        ],
                        onChanged: (value) {
                          final newAmount = double.parse(value);
                          lspController.updateRedeemAmt(newAmount);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                width: wid - edge,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 5),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          scale: 0.5,
                          image: AssetImage('assets/images/apt_inverted.png'),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        'Short APTs',
                        style: textStyle(Colors.white, 15, false),
                      ),
                    ),
                    Container(
                      height: 28,
                      width: 48,
                      decoration: boxDecoration(
                        Colors.transparent,
                        100,
                        0.5,
                        Colors.grey[400]!,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'MAX',
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
                          contentPadding: isWeb
                              ? const EdgeInsets.all(9)
                              : const EdgeInsets.all(6),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,6}'),
                          ),
                        ],
                        onChanged: (value) {
                          final newAmount = double.parse(value);
                          lspController.updateRedeemAmt(newAmount);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.35,
            color: Colors.grey[400],
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: wid - edge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You receive:',
                  style: textStyle(Colors.white, 15, false),
                ),
                Text(
                  '120 AX',
                  style: textStyle(Colors.white, 15, false),
                ),
              ],
            ),
          ),
          SizedBox(
            width: wid - edge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: 175,
                  height: 45,
                  decoration: boxDecoration(
                    Colors.amber[500]!.withOpacity(0.20),
                    500,
                    1,
                    Colors.transparent,
                  ),
                  child: TextButton(
                    onPressed: () {
                      lspController.redeem();
                      Navigator.pop(context);
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) =>
                            confirmTransaction(context, true, ''),
                      );
                    },
                    child: Text(
                      'Confirm',
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
  );
}

// dynamic
Dialog mintDialog(BuildContext context, AthleteScoutModel athlete) {
  var isWeb = true;
  isWeb =
      kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
  final _height = MediaQuery.of(context).size.height;
  final wid = isWeb ? 370.0 : 355.0;
  const edge = 40.0;
  var hgt = 390.0;
  if (_height < 395) hgt = _height;

  final lspController = Get.find<LSPController>();

  return Dialog(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: wid - edge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mint ${athlete.name} APT Pair',
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
              ],
            ),
          ),
          SizedBox(
            width: wid - edge,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'You can mint APTs at their Book Value with AX.',
                    style: textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                  ),
                  TextSpan(
                    text: ' You can buy AX on the Matic network through',
                    style: textStyle(Colors.grey[600]!, isWeb ? 14 : 12, false),
                  ),
                  TextSpan(
                    text: ' SushiSwap',
                    style:
                        textStyle(Colors.amber[400]!, isWeb ? 14 : 12, false),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: wid - edge,
                child: Text(
                  'Input APT:',
                  style: textStyle(Colors.grey[600]!, 14, false),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: wid - edge,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 5),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/apt_noninverted.png',
                          ),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        '${athlete.name} APT',
                        style: textStyle(Colors.white, 15, false),
                      ),
                    ),
                    Container(
                      height: 28,
                      width: 48,
                      decoration: boxDecoration(
                        Colors.transparent,
                        100,
                        0.5,
                        Colors.grey[400]!,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'MAX',
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
                          contentPadding: isWeb
                              ? const EdgeInsets.all(9)
                              : const EdgeInsets.all(6),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,6}'),
                          ),
                        ],
                        onChanged: (value) {
                          final newAmount = double.parse(value);
                          lspController.updateCreateAmt(newAmount);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.35,
            color: Colors.grey[400],
          ),
          SizedBox(
            //margin: EdgeInsets.only(top: 15.0),
            width: wid - edge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You receive:',
                  style: textStyle(Colors.white, 15, false),
                ),
                Center(
                  child: Obx(
                    () => Text(
                      '${lspController.createAmt} Long APTs'
                      ' + '
                      '${lspController.createAmt} Short APTs',
                      style: textStyle(Colors.white, 15, false),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: wid - edge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: 175,
                  height: 45,
                  decoration: isWeb
                      ? boxDecoration(
                          Colors.amber[400]!,
                          500,
                          1,
                          Colors.amber[400]!,
                        )
                      : boxDecoration(
                          Colors.amber[500]!.withOpacity(0.20),
                          500,
                          1,
                          Colors.transparent,
                        ),
                  child: TextButton(
                    onPressed: () {
                      // call mint functionality
                      lspController.mint();
                      Navigator.pop(context);
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) =>
                            confirmTransaction(context, true, ''),
                      );
                    },
                    child: Text(
                      'Confirm',
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

// dynamic
Dialog confirmTransaction(
  BuildContext context,
  bool IsConfirmed,
  String txString,
) {
  var isWeb = true;
  isWeb =
      kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 500.0;
  const edge = 40.0;
  if (_width < 505) wid = _width;
  var hgt = 335.0;
  if (_height < 340) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Center(
        child: SizedBox(
          height: 275,
          width: wid - edge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: wid - edge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 5),
                    Text(
                      'Transaction Confirmed',
                      style: textStyle(Colors.white, 20, false),
                    ),
                    SizedBox(
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 150,
                    color: Colors.amber[400],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 275,
                    height: 50,
                    decoration: isWeb
                        ? boxDecoration(
                            Colors.amber[400]!,
                            500,
                            1,
                            Colors.amber[400]!,
                          )
                        : boxDecoration(
                            Colors.amber[500]!.withOpacity(0.20),
                            500,
                            1,
                            Colors.transparent,
                          ),
                    child: TextButton(
                      onPressed: () {
                        Controller.viewTx();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'View on Polygonscan',
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
        ),
      ),
    ),
  );
}

// dynamic
Dialog removalConfirmed(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 500.0;
  const edge = 40.0;
  if (_width < 505) wid = _width;
  var hgt = 335.0;
  if (_height < 340) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Center(
        child: SizedBox(
          height: 275,
          width: wid - edge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: wid - edge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 5),
                    Text(
                      'Removal Confirmed',
                      style: textStyle(Colors.white, 20, false),
                    ),
                    SizedBox(
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 150,
                    color: Colors.amber[400],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      child: const Text(
                        'View on Polygonscan',
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
        ),
      ),
    ),
  );
}

// dynamic
Dialog transactionConfirmed(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 500.0;
  const edge = 40.0;
  if (_width < 505) wid = _width;
  var hgt = 335.0;
  if (_height < 340) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Center(
        child: SizedBox(
          height: 275,
          width: wid - edge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: wid - edge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 5),
                    Text(
                      'Deposit Confirmed',
                      style: textStyle(Colors.white, 20, false),
                    ),
                    SizedBox(
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 150,
                    color: Colors.amber[400],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      child: const Text(
                        'View on Polygonscan',
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
        ),
      ),
    ),
  );
}

// dynamic
Dialog yourAXDialog(BuildContext context) {
  final walletController = Get.find<WalletController>();
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 400.0;
  const edge = 40.0;
  if (_width < 405) wid = _width;
  var hgt = 500.0;
  if (_height < 505) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 80,
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your AX',
                    style: textStyle(Colors.white, 20, false),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      walletController
                        ..getTokenMetrics()
                        ..getYourAxBalance();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            // 'X' logo
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * (wid - 0.04),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  scale: 2,
                  image: AssetImage('assets/images/x.jpg'),
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: 65,
              alignment: Alignment.center,
              child: Text(
                '${walletController.yourBalance} AX',
                style: textStyle(Colors.white, 20, false),
              ),
            ),
            SizedBox(
              width: wid - edge,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      Obx(
                        () => Text(
                          '${walletController.yourBalance} AX',
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
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            SizedBox(
              width: wid - edge,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX price:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${walletController.axPrice} USD',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX in circulation:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${walletController.axCirculation}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX total supply:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${walletController.axTotalSupply}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.amber[600]!,
                      100,
                      0,
                      Colors.amber[600]!,
                    ),
                    child: TextButton(
                      onPressed: walletController.buyAX,
                      child: Text(
                        'Buy AX',
                        style: textStyle(Colors.black, 14, true),
                      ),
                    ),
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

// dynamic
Dialog accountDialog(BuildContext context) {
  // double wid = 475;
  // double hgt = 200;
  final controller = Get.find<Controller>();
  final accNum = '${controller.publicAddress}';
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 400.0;
  const edge = 40.0;
  const edge2 = 60.0;
  if (_width < 405) wid = _width;
  var hgt = 240.0;
  if (_height < 235) hgt = _height;

  var retStr = accNum;
  if (accNum.length > 15) {
    retStr =
        '''${accNum.substring(0, 7)}...${accNum.substring(accNum.length - 5, accNum.length)}''';
  }

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // title
            SizedBox(
              width: wid - edge,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Account', style: textStyle(Colors.white, 20, false)),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // inner box
            Container(
              width: wid - edge,
              height: 145,
              decoration: boxDecoration(
                Colors.transparent,
                14,
                .5,
                Colors.grey[400]!,
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: wid - edge2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Connected With Metamask',
                                style: textStyle(
                                  Colors.grey[600]!,
                                  13,
                                  false,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    retStr,
                                    style: textStyle(Colors.white, 20, false),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // TODO(anyone): https://athletex.atlassian.net/browse/AX-734
                              // There's only MetaMask currently supported,
                              // so there's no point in having a change
                              // wallet button yet.

                              // Container(
                              //   width: 75,
                              //   height: 25,
                              //   decoration: boxDecoration(Colors.transparent,
                              //       100, 0, Colors.blue[800]!),
                              //   child: TextButton(
                              //     onPressed: () {
                              //       controller.changeAddress();
                              //     },
                              //     child: Text(
                              //       "Change",
                              //       style: textStyle(
                              //           Colors.blue[300]!, 10, true),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                width: 75,
                                height: 25,
                                decoration: boxDecoration(
                                  Colors.transparent,
                                  100,
                                  0,
                                  Colors.red[900]!,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    controller.disconnect();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Disconnect',
                                    style: textStyle(
                                      Colors.red[900]!,
                                      10,
                                      true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: '${controller.publicAddress}',
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              Icons.filter_none,
                              color: Colors.grey,
                            ),
                            Text(
                              'Copy Address',
                              style: textStyle(Colors.grey[400]!, 15, false),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final address =
                              controller.publicAddress.value.toString();
                          final urlString =
                              'https://polygonscan.com/address/$address';
                          launchUrl(Uri.parse(urlString));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              Icons.open_in_new,
                              color: Colors.grey,
                            ),
                            Text(
                              'Show on Polygonscan',
                              style: textStyle(Colors.grey[400]!, 15, false),
                            ),
                          ],
                        ),
                      ),
                    ],
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

Dialog poolAddLiquidity(BuildContext context, String name) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 390.0;
  if (_width < 395) wid = _width;
  var hgt = 450.0;
  if (_height < 455) hgt = _height;
  final poolController = Get.find<PoolController>();
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Liquidity',
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
            ],
          ),
          // AX & Athlete deposited
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AX deposited:',
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                  Text('1000', style: textStyle(Colors.white, 16, false))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$name deposited:',
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                  Text('500', style: textStyle(Colors.white, 16, false))
                ],
              )
            ],
          ),
          // ax per apt & share of pool
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AX per $name',
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                  Text('2.24', style: textStyle(Colors.white, 16, false))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$name per AX:',
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                  Text('1.48', style: textStyle(Colors.white, 16, false))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Share of pool:',
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                  Text('0.12%', style: textStyle(Colors.white, 16, false))
                ],
              )
            ],
          ),
          Divider(thickness: 1, color: Colors.grey[600]),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'You will receive:',
              style: textStyle(Colors.grey[600]!, 16, false),
            ),
          ),
          // bottom receive amount
          SizedBox(
            width: wid - 100,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '20.24',
                      style: textStyle(Colors.white, 38, false),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AX/$name',
                          style: textStyle(Colors.white, 16, false),
                        ),
                        Text(
                          'LP Tokens',
                          style: textStyle(Colors.white, 16, false),
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  '''*Output is estimated. If the price changes by more than 2%, your transaction will revert.''',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ApproveButton(
            175,
            40,
            'Approve',
            poolController.approve,
            poolController.addLiquidity,
            transactionConfirmed,
          )
        ],
      ),
    ),
  );
}

Dialog poolRemoveLiquidity(BuildContext context, String name) {
  final poolController = Get.find<PoolController>();
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 390.0;
  if (_width < 395) wid = _width;
  var hgt = 525.0;
  if (_height < 530) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remove Liquidity',
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
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your position:',
              style: textStyle(Colors.grey[600]!, 16, false),
            ),
          ),
          // ax per apt & share of pool
          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AX/$name LP Tokens:',
                      style: textStyle(Colors.white, 16, false),
                    ),
                    Text(
                      '20.24',
                      style: textStyle(Colors.white, 16, false),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Share of pool:',
                      style: textStyle(Colors.grey[600]!, 16, false),
                    ),
                    Text(
                      '0.12%',
                      style: textStyle(Colors.white, 16, false),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AX deposited:',
                      style: textStyle(Colors.grey[600]!, 16, false),
                    ),
                    Text(
                      '1,000',
                      style: textStyle(Colors.white, 16, false),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$name deposited:',
                      style: textStyle(Colors.grey[600]!, 16, false),
                    ),
                    Text(
                      '500',
                      style: textStyle(Colors.white, 16, false),
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[600]),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Remove:',
              style: textStyle(Colors.grey[600]!, 16, false),
            ),
          ),
          Container(
            width: wid,
            decoration: boxDecoration(
              Colors.transparent,
              20,
              0.5,
              Colors.grey[600]!,
            ),
            child: SizedBox(
              width: wid - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // LP Tokens
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance: 20.24',
                          style: textStyle(
                            Colors.grey[600]!,
                            9,
                            false,
                          ),
                        ),
                        Text(
                          'LP Tokens',
                          style: textStyle(Colors.white, 16, false),
                        )
                      ],
                    ),
                  ),
                  // Max/amount
                  SizedBox(
                    width: wid * .325,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 17.5,
                          width: 37.5,
                          decoration: boxDecoration(
                            Colors.transparent,
                            100,
                            0.5,
                            Colors.grey[600]!,
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'MAX',
                              style: textStyle(
                                Colors.grey[600]!,
                                9,
                                false,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextFormField(
                            onChanged: (_) {},
                            style: textStyle(
                              Colors.grey[400]!,
                              22,
                              false,
                            ),
                            decoration: InputDecoration(
                              hintText: '0.00',
                              hintStyle: textStyle(
                                Colors.grey[400]!,
                                22,
                                false,
                              ),
                              contentPadding: const EdgeInsets.all(9),
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,6}'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'You will receive:',
              style: textStyle(Colors.grey[600]!, 16, false),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AX per $name',
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                  Text(
                    '1,000',
                    style: textStyle(Colors.white, 16, false),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$name per AX',
                    style: textStyle(Colors.grey[600]!, 16, false),
                  ),
                  Text(
                    '500',
                    style: textStyle(Colors.white, 16, false),
                  )
                ],
              )
            ],
          ),
          ApproveButton(
            175,
            40,
            'Approve',
            poolController.approve,
            poolController.removeLiquidity,
            removalConfirmed,
          )
        ],
      ),
    ),
  );
}

TextStyle textStyle(Color color, double size, bool isBold) {
  if (isBold) {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  } else {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
    );
  }
}

BoxDecoration boxDecoration(
  Color col,
  double rad,
  double borWid,
  Color borCol,
) {
  return BoxDecoration(
    color: col,
    borderRadius: BorderRadius.circular(rad),
    border: Border.all(color: borCol, width: borWid),
  );
}

class FailedDialog extends StatelessWidget {
  const FailedDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var wid = 500.0;
    const edge = 40.0;
    if (_width < 505) wid = _width;
    var hgt = 335.0;
    if (_height < 340) hgt = _height;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: hgt,
        width: wid,
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: Center(
          child: SizedBox(
            height: 275,
            width: wid - edge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: wid - edge,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(width: 5),
                      Text(
                        'Something went wrong',
                        style: textStyle(Colors.white, 20, false),
                      ),
                      SizedBox(
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
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 150,
                      color: Colors.amber[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
