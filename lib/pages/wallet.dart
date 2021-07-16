import 'package:flutter/services.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscan/qrscan.dart' as QRScanner;
import 'package:web3dart/credentials.dart';

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
  String? buyTokensSite;
  final _buyTokenUrl = "https://www.axmarkets.net/buy-ax";
  void _buyStuff() {
    Navigator.pushNamed(context, "/athletes");
  }

  void _launchURL() async => await canLaunch(_buyTokenUrl)
      ? await launch(_buyTokenUrl)
      : throw 'Could not launch $_buyTokenUrl';

  Future<void> _buyTokensOnline() async {
    (kIsWeb) ? _launchURL() : buyTokensSite = await QRScanner.scan();
  }

  Controller? contractLink;
  BigInt? balanceOfAE;
  BigInt? stakedAX;
  BigInt? balanceofMATIC;
  String? publicAddress;
  String? AX;

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
    Future<EthereumAddress> getPublicAddress() async {
      EthereumAddress returnValue = "Your Address!" as EthereumAddress;
      await contractLink.getPublicAddress().then((value) => returnValue = value);
      return returnValue;
    }

    return Scaffold(
      backgroundColor: Vx.hexToColor("#232b2b"),
      body: ZStack([
        VxBox()
            .hexColor("#fec901")
            .size(context.screenWidth * 50, context.percentHeight * 40)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "$announcements"
              .text
              .xl4
              .white
              .bold
              .center
              .makeCentered()
              .py16()
              .onTap(() {
            setState(() {
              announcements = "Your Wallet Address: ";
            });
          }),
          (context.percentHeight * 5).heightBox,
          VxBox(
            child: Center(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.local_gas_station_rounded,
                            color: Colors.amber[200]
                            )
                              .h(20) //TODO: What is this doing?
                              .tooltip(
                                  "You need gas (MATIC) to conduct transactions on the network"),
                        ),
                        Text("20").h(20),
                        Text("Public Address: ")
                        .onTap(() {
                        Clipboard.setData(
                          ClipboardData(text: "Copied!")
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text("Copied!")));
                        }),
                      ]
                    )
                  ),
                  Text("Your Staked Balance: "),
                  Text("Available to Stake: 0"),
                  Text("Rewards accrued: 0"),
                ]
              )
            )
          )
            .p16
            .gray400
            .size(context.screenWidth * 40, context.percentHeight * 30)
            .rounded
            .shadowLg
            .make()
            .p12(),
          30.heightBox,
          HStack(
            [
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () async {
                  // Staking token
                  try {
                    String txHash = "Hash Goes Here!";
                    // await contractLink.stake(stakedAE);
                    print("txHash: $txHash");
                  } catch (e) {
                    print("Console: error attempting staking \n\n$e");
                  }
                },
                color: Colors.green,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_made_rounded,
                  color: Colors.white,
                ),
                label: "Stake AX".text.white.make(),
              ).h(60).tooltip("Lock your tokens in to earn interest rewards"),

              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () async => {
                  _buyTokensOnline(),
                  print("Your Public Address: ")
                },
                color: Colors.blue,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
                label: "Buy AX".text.white.make(),
              ).h(60).tooltip("Buy AX at the Athlete Presale!"),

              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {
                  try {
                    // contractLink.withdraw(10 as BigInt);
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
                label: "Withdraw AX".text.white.make(),
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
