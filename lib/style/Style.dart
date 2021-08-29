// flutter format .

import 'package:flutter/material.dart';

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
        minimumSize: Size(350, 60));

final ButtonStyle approveButton = ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontSize: smTxSize,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600),
        primary: Colors.grey[900],
        onPrimary: Colors.amber[600],
        minimumSize: Size(250, 75));

final ButtonStyle claimButton = ElevatedButton.styleFrom(
  textStyle: TextStyle(
      fontSize: smTxSize,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w600),
  primary: Colors.grey[900],
  onPrimary: Colors.amber[600],
  minimumSize: Size(250, 75));

final ButtonStyle connectButton = ElevatedButton.styleFrom(
  textStyle: TextStyle(
      fontSize: smTxSize,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w200),
  primary: Colors.blue.withOpacity(0.3),
  onPrimary: Colors.white.withOpacity(0.8),
  minimumSize: Size(250, 75));
