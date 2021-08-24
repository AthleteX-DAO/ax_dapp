import 'dart:math';


// flutter format .

import 'package:ae_dapp/service/colors.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
// import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ae_dapp/pages/AXPage.dart';

const double lgTxSize = 52;
const double mdTxSize = 35;
const double smTxSize = 15;
const double xsTxSize = 12;

const url = "https://www.axmarkets.net/ax";

final ButtonStyle walletButton = ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontSize: smTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600),
        primary: Colors.grey[900],
        onPrimary: Colors.amber[600],
        fixedSize: Size(350, 60));

final ButtonStyle approveButton = ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontSize: smTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600),
        primary: Colors.grey[900],
        onPrimary: Colors.amber[600],
        fixedSize: Size(250, 75));

final ButtonStyle claimButton = ElevatedButton.styleFrom(
  textStyle: TextStyle(
      fontSize: smTxSize,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w600),
  primary: Colors.grey[800],
  onPrimary: Colors.amber[600],
  fixedSize: Size(250, 75));

final ButtonStyle connectButton = ElevatedButton.styleFrom(
  textStyle: TextStyle(
      fontSize: xsTxSize,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w200),
  primary: Colors.blue[400],
  onPrimary: Colors.white,
  fixedSize: Size(250, 75));