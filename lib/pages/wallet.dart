import 'package:ae_dapp/pages/PriceAction.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:provider/provider.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:qrscan/qrscan.dart' as QRScanner;

// Smart Contract specific imports

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
  final _buyTokenUrl = "https://www.athlete-equity.com/buy-ae";
  void _buyStuff() {
    Navigator.pushNamed(context, "/athletes");
  }

  void _launchURL() async => await canLaunch(_buyTokenUrl)
      ? await launch(_buyTokenUrl)
      : throw 'Could not launch $_buyTokenUrl';

  Future<void> _buyTokensOnline() async {
    (kIsWeb) ? _launchURL() : buyTokensSite = await QRScanner.scan();
  }

  Controller contractLink;
  Web3Provider web3;
  BigInt balanceOfAE = BigInt.from(1);
  BigInt balanceofBNB = BigInt.from(1);
  String publicAddress;
  String aeToken =
      "0x805624d8a34473f24d66d74c2fb86400c90862a1"; // Hash for the AE Token
  @override
  void initState() {
    super.initState();
  }

  void _updatePublicAddress(String address) {
    setState(() {
      publicAddress = address;
    });
  }

  void _updateTokenBalance(BigInt ae) {
    setState(() {
      balanceOfAE = ae;
    });
  }

  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<Controller>(context);
    data = true;
    var announcements = "Stake your AE Token and Earn rewards";
    return Scaffold(
      backgroundColor: Vx.hexToColor("#232b2b"),
      body: ZStack([
        VxBox()
            .hexColor("#fec901")
            .size(context.screenWidth, context.percentHeight * 40)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "$announcements".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(child: PriceActionChart())
              .p16
              .size(context.screenWidth, context.percentHeight * 30)
              .rounded
              .shadowLg
              .make()
              .p16(),
          30.heightBox,
          HStack([
            Icon(Icons.local_gas_station_rounded, color: Colors.amber).h(20),
            Text("$balanceofBNB").h(20),
          ]),
          HStack(
            [
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () async {
                  // Staking token
                  try {
                    final stakeAmount = BigInt.parse("9225807");
                    String txHash = await contractLink.stake(stakeAmount);
                    print("txHash: $txHash");
                  } catch (e) {
                    print("staking: $e");
                  }
                },
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
                onPressed: () async => {
                  _buyTokensOnline(),
                  _updateTokenBalance(await contractLink
                      .getStakeBalance(contractLink.publicAddress)),
                  print("Your Public Address: ${contractLink.publicAddress}")
                },
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
                onPressed: () {
                  try {
                    contractLink.withdraw(10 as BigInt);
                  } catch (e) {
                    print(e);
                  }
                }, //Withdraw Smart Contract Logic
                color: Colors.red,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_received_rounded,
                  color: Colors.white,
                ),
                label: "Withdraw".text.white.make(),
              ).h(60).tooltip("Sell your tokens to realize your gains"),
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ])
      ]),
    );
  }
}
