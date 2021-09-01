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
    primary: Colors.grey[900],
    onPrimary: Colors.amber[600],
    fixedSize: Size(250, 75));

final ButtonStyle connectButton = ElevatedButton.styleFrom(
    textStyle: TextStyle(
        fontSize: smTxSize,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w200),
    primary: Colors.blue.withOpacity(0.3),
    onPrimary: Colors.white.withOpacity(0.8),
    fixedSize: Size(250, 75));

final ButtonStyle confirmSwap = ElevatedButton.styleFrom(
    textStyle: TextStyle(
        fontSize: smTxSize,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600),
    primary: Colors.amber[600],
    onPrimary: Colors.white,
    fixedSize: Size(300, 50));

final ButtonStyle longButton = ElevatedButton.styleFrom(
    textStyle: TextStyle(
        fontSize: smTxSize,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600),
    primary: Colors.green,
    onPrimary: Colors.white,
    shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0)),
    side: BorderSide(color: (Colors.grey[900])!),
    fixedSize: Size(120, 40));

final ButtonStyle shortButton = ElevatedButton.styleFrom(
    textStyle: TextStyle(
        fontSize: smTxSize,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600),
    primary: Colors.red,
    onPrimary: Colors.white,
    shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0)),
    side: BorderSide(color: (Colors.grey[900])!),
    fixedSize: Size(120, 40));

final ButtonStyle mintButton = ElevatedButton.styleFrom(
    textStyle: TextStyle(
        fontSize: smTxSize,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600),
    primary: Colors.grey[900],
    onPrimary: Colors.white,
    shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0)),
    side: BorderSide(color: (Colors.amber[600])!),
    fixedSize: Size(120, 40));

final ButtonStyle redeemButton = ElevatedButton.styleFrom(
    textStyle: TextStyle(
        fontSize: smTxSize,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600),
    primary: Colors.grey[900],
    onPrimary: Colors.white,
    shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0)),
    side: BorderSide(color: (Colors.amber[600])!),
    fixedSize: Size(120, 40));
