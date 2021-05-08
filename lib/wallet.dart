import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscan/qrscan.dart' as QRScanner;

// Smart Contract specific imports
import 'dart:math';
import 'package:web3dart/web3dart.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

var myData = 0;
bool data = true;
int myAmount = 0;

// TODO: NEED A WAY TO CLAIM REWARDS

class _WalletState extends State<Wallet> {
  String buyTokensSite;
  final _buyTokenUrl = "https://www.athlete-equity.com/presale";
  void _buyStuff() {
    Navigator.pushNamed(context, "/athletes");
  }

  void _launchURL() async => await canLaunch(_buyTokenUrl)
      ? await launch(_buyTokenUrl)
      : throw 'Could not launch $_buyTokenUrl';

  Future<void> _buyTokensOnline() async {
    (kIsWeb) ? _launchURL() : buyTokensSite = await QRScanner.scan();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.hexToColor("#232b2b"),
      body: ZStack([
        VxBox()
            .hexColor("#fec901")
            .size(context.screenWidth, context.percentHeight * 30)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "\$Athlete.Equity".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(
                  child: VStack([
            "Your Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data
                ? "$myData".text.bold.xl6.makeCentered()
                : CircularProgressIndicator().centered()
          ]))
              .p16
              .white
              .size(context.screenWidth, context.percentHeight * 30)
              .rounded
              .shadowLg
              .make()
              .p16(),
          30.heightBox,
          HStack(
            [
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {},
                color: Colors.green,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_made_rounded,
                  color: Colors.white,
                ),
                label: "Stake".text.white.make(),
              ).h(60).tooltip("Lock your tokens in to earn interest rewards"),

              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () => {_buyTokensOnline()},
                color: Colors.blue,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
                label: "Buy Tokens".text.white.make(),
              ).h(60).tooltip("Buy tokens at the Athlete Presale!"),

              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {}, //Withdraw Smart Contract Logic
                color: Colors.red,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_received_rounded,
                  color: Colors.white,
                ),
                label: "Withdraw".text.white.make(),
              ).h(60),
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ])
      ]),
    );
  }
}
