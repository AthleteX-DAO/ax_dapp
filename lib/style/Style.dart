import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

const double lgTxSize = 52;
const double mdTxSize = 35;
const double smTxSize = 15;
const double xsTxSize = 12;

final ButtonStyle walletButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.grey[800],
  onPrimary: Colors.amber[600],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  minimumSize: const Size(350, 60),
);

final ButtonStyle approveButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.grey[900],
  onPrimary: Colors.amber[600],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  minimumSize: const Size(300, 75),
);

final ButtonStyle claimButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.grey[800],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  onPrimary: Colors.amber[600],
  minimumSize: const Size(300, 75),
);

final ButtonStyle connectButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w200,
  ),
  primary: Colors.blue.withOpacity(0.3),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  onPrimary: Colors.white.withOpacity(0.8),
  minimumSize: const Size(300, 75),
);

final ButtonStyle confirmSwap = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
  ),
  primary: Colors.amber[600],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  onPrimary: Colors.white,
  minimumSize: const Size(350, 50),
);

final ButtonStyle longButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.green,
  onPrimary: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  side: BorderSide(color: (Colors.grey[900])!),
  minimumSize: const Size(120, 40),
);

final ButtonStyle shortButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.red,
  onPrimary: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  side: BorderSide(color: (Colors.grey[900])!),
  minimumSize: const Size(120, 40),
);

final ButtonStyle mintButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.grey[900],
  onPrimary: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  side: BorderSide(color: (Colors.amber[600])!, width: 2),
  minimumSize: const Size(120, 40),
);

final ButtonStyle redeemButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: smTxSize,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.grey[900],
  onPrimary: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  side: BorderSide(color: (Colors.amber[600])!, width: 2),
  minimumSize: const Size(120, 40),
);

final TextStyle confirmText = TextStyle(
  color: Colors.grey[500],
  fontWeight: FontWeight.w100,
  fontSize: 15,
);

const TextStyle confirmTextPercent = TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.w100,
  fontSize: 12,
);

final TextStyle confirmTextCoin = TextStyle(
  color: Colors.grey[200],
  fontWeight: FontWeight.w600,
  fontSize: 23,
);

final TextStyle confirmTextOther = TextStyle(
  color: Colors.grey[500],
  fontWeight: FontWeight.w100,
  fontSize: 13,
);

final TextStyle confirmTextOtherBold = TextStyle(
  color: Colors.grey[400],
  fontWeight: FontWeight.w600,
  fontSize: 13,
);

final TextStyle mintAndRedeemText = TextStyle(
  color: Colors.amber.withOpacity(0.4),
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.italic,
  fontSize: 13,
);

final TextStyle athleteListText = TextStyle(
  letterSpacing: 1,
  color: Colors.amber.withOpacity(0.6),
  fontSize: 20,
  fontWeight: FontWeight.w200,
);

const TextStyle axHeader = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontSize: 30,
  fontWeight: FontWeight.w600,
);

const TextStyle axHeader1 = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontSize: 35,
  fontWeight: FontWeight.w600,
);

final TextStyle axSubheader = TextStyle(
  color: Colors.white.withOpacity(0.8),
  fontFamily: 'OpenSans',
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

final TextStyle axSubheader2 = TextStyle(
  color: Colors.white.withOpacity(0.8),
  fontFamily: 'OpenSans',
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

final ButtonStyle navButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 20,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.transparent,
  onPrimary: Colors.white,
);

final ButtonStyle inactiveSport = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 10,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
  ),
  primary: Colors.grey[900],
  onPrimary: Colors.grey[800],
);

final ButtonStyle nflButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 10,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
  ),
  primary: Colors.amber[600],
  onPrimary: Colors.grey[800],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  side: BorderSide(color: (Colors.amber[600])!, width: 2),
);

final ButtonStyle connectWallet = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 20,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
  ),
  primary: Colors.transparent,
  onPrimary: Colors.grey[800],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  side: BorderSide(color: Colors.amber.withOpacity(0.8), width: 2),
);

final ButtonStyle connectWalletDesktopButton = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 20,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
  ),
  primary: Colors.transparent,
  onPrimary: Colors.grey[800],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  side: BorderSide(color: (Colors.amber[500])!, width: 4),
);

final ButtonStyle dexToggleActive = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(15),
  textStyle: const TextStyle(
    fontSize: 15,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.grey[900],
  onPrimary: Colors.amber[600],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  // side: BorderSide(color: (Colors.amber[500])!, width: 4),
);

final ButtonStyle dexToggleActiveMobile = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(15),
  textStyle: const TextStyle(
    fontSize: 15,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.grey[900],
  onPrimary: Colors.amber[600],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  // side: BorderSide(color: (Colors.amber[500])!, width: 4),
);

final ButtonStyle dexToggleInactive = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(15),
  textStyle: const TextStyle(
    fontSize: 15,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600,
  ),
  primary: Colors.transparent,
  onPrimary: Colors.grey[400],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  // side: BorderSide(color: (Colors.amber[500])!, width: 4),
);

final ButtonStyle dexToggleInactiveMobile = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(15),
  textStyle: const TextStyle(
    fontSize: 15,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w400,
  ),
  primary: Colors.transparent,
  onPrimary: Colors.grey[400],
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  // side: BorderSide(color: (Colors.amber[500])!, width: 4),
);

const TextStyle athleteText = TextStyle(
  letterSpacing: 1,
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.w200,
);

final TextStyle connectWalletMobile = TextStyle(
  color: Colors.amber.withOpacity(0.8),
  fontSize: 15,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w200,
);

final TextStyle connectWalletDesktop = TextStyle(
  color: Colors.amber[500],
  fontSize: 15,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w200,
);

final TextStyle toolbarButton = TextStyle(
  color: Colors.amber[500],
  fontSize: 20,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w600,
);

const TextStyle athleteWAR = TextStyle(
  letterSpacing: 1,
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.w200,
);

const TextStyle athletePercent = TextStyle(
  letterSpacing: 1,
  color: Colors.green,
  fontSize: 20,
  fontWeight: FontWeight.w200,
);

final TextStyle athleteCardName = TextStyle(
  letterSpacing: 1,
  color: Colors.white.withOpacity(0.8),
  fontSize: 18,
  fontWeight: FontWeight.w200,
);

final TextStyle athleteCardPrice = TextStyle(
  letterSpacing: 1,
  color: Colors.white.withOpacity(0.8),
  fontSize: 15,
  fontWeight: FontWeight.w200,
);

final TextStyle comingSoon = TextStyle(
  letterSpacing: 1,
  color: Colors.amber[600],
  fontSize: 40,
  fontWeight: FontWeight.w600,
);

final customChartTickFormatter =
    charts.BasicNumericTickFormatterSpec((num? val) {
  final dt = DateTime.fromMillisecondsSinceEpoch(val!.toInt());
  return '${dt.hour}:00';
});
