import 'dart:math';


// flutter format .

import 'package:ae_dapp/service/colors.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
// import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ae_dapp/pages/AXPage2.dart';

const double smTxSize = 15;

final ButtonStyle walletButton = ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontSize: smTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600),
        primary: Colors.grey[900],
        onPrimary: Colors.amber[600],
        fixedSize: Size(350, 60));

const url = "https://www.axmarkets.net/ax";


_launchURL() async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}