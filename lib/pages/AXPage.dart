import 'dart:js_util';
import 'dart:math';
import 'package:ae_dapp/contracts/StakingRewards.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import '../contracts/AthleteX.g.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:js/js.dart';

// flutter format .
import 'package:url_launcher/url_launcher.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ae_dapp/style/Style.dart';

_launchURL() async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: Text('Connect to a wallet',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[400],
          fontFamily: 'OpenSans',
        )),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text('Install Metamask'),
              ),
            ),
            onPressed: () async {
              var accounts = await promiseToFuture(ethereum!
                  .request(RequestParams(method: 'eth_requestAccounts')));
              print(accounts);
            },
            style: walletButton,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text('WalletConnect'),
              ),
            ),
            onPressed: () {},
            style: walletButton,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text('Coinbase Wallet'),
              ),
            ),
            onPressed: () {},
            style: walletButton,
          ),
        ),
      ],
    ),
  );
}

Controller _c = Controller();

class AXPage extends StatefulWidget {
  @override
  _AXState createState() => _AXState();
}

class _AXState extends State<AXPage> {
  final EthereumAddress tokenAddr =
      EthereumAddress.fromHex('0x585E0c93F73C520ca6513fc03f450dAea3D4b493');
  final EthereumAddress stakingAddr =
      EthereumAddress.fromHex("0x063086C5b352F986718Db9383c894Be9Cd4350fA");
  late Web3Provider web3;
  var balanceF;

  @override
  void initState() {
    print("Initiating Page!");
    super.initState();
    if (ethereum != null) {
      web3 = Web3Provider(ethereum!);
      balanceF = promiseToFuture(web3.getBalance(ethereum!.selectedAddress));
      print(balanceF);
    }
  }

  // Actionable
  Future<void> buyAX() async {}
  Future<void> stakeAX(int _amount) async {}

  Future<void> claimRewards() async {}
  Future<void> unstakeAX(int _amount) async {}

  // Viewable
  Future<BigInt> totalBalance() async {
    return BigInt.one;
  }

  Future<dynamic> availableBalance() async {
    return balanceF;
  }

  Future<BigInt> stakedAX() async {
    return BigInt.from(2);
  }

  Future<double> getAPY() async {
    return new Random().nextDouble();
  }

  Future<double> rewardsEarned() async {
    return new Random().nextDouble();
  }

  Future<double> UnclaimedRewards() async {
    return new Random(300).nextDouble();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        // background image
        Image(
          image: AssetImage("assets/images/background.jpeg"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),

        // upper right logo
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image(
                width: 80,
                height: 80,
                image: AssetImage("assets/images/x.png"),
              ),
            )),

        // header
        Container(
            margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("AX",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: lgTxSize,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      )),
                ])),

        // main user area
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // my account info
            Column(
              children: [
                // Main Left Area
                Container(
                    margin: EdgeInsets.fromLTRB(0, 175, 0, 0),
                    alignment: Alignment.center,
                    height: 500,
                    width: 400,
                    color: Colors.grey[900],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      // Main Left Area
                      children: [
                        Column(
                          children: [
                            // My Account
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 45, 0, 20),
                              child: Text('My Account',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic)),
                            ),

                            // Staked AX
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Staked AX: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Available AX
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Available AX: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Total AX
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Total AX: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // My Rewards
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: Text('My Rewards',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic)),
                            ),

                            // APY
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'APY: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Rewards Earned
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Rewards Earned: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Unclaimed Rewards
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                'Unclaimed Rewards: ',
                                style: TextStyle(
                                  fontSize: smTxSize,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            //Claim rewards button
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SizedBox(
                                  child: ElevatedButton(
                                    child: Text('CLAIM REWARDS'),
                                    onPressed: () {
                                      claimRewards();
                                    },
                                    style: claimButton,
                                  ),
                                  height: 50,
                                  width: 250,
                                )),
                            //Buy AX button
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: SizedBox(
                                  child: ElevatedButton(
                                    child: Text('BUY AX'),
                                    onPressed: _launchURL,
                                    style: claimButton,
                                  ),
                                  height: 50,
                                  width: 250,
                                )),
                          ],
                        )
                      ],
                    )),
              ],
            ),

            //Main right area
            Column(
              children: [
                //Main Right Area
                Container(
                    margin: EdgeInsets.fromLTRB(0, 175, 0, 0),
                    alignment: Alignment.center,
                    height: 500,
                    width: 500,
                    color: Colors.grey[800],

                    // My Liquidity Area
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Column(
                          children: [
                            // My Liquidity
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 45, 0, 10),
                                child: Text('My Liquidity',
                                    style: TextStyle(
                                        fontSize: mdTxSize,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic))),

                            // adding note
                            Container(
                                child: Column(
                              children: [
                                // Add liquidity tag
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text('Add liquidity to stake AX',
                                        style: TextStyle(
                                          fontSize: xsTxSize,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w200,
                                        ))),

                                // remove note
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                                    child:
                                        Text('Remove liquidity to receive AX',
                                            style: TextStyle(
                                              fontSize: xsTxSize,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w200,
                                            ))),

                                Container(
                                    child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        ToggleSwitch(
                                          minWidth: 75.0,
                                          minHeight: 30.0,
                                          fontSize: xsTxSize,
                                          activeBgColor: [(Colors.grey[800])!],
                                          activeFgColor: Colors.amber[600],
                                          inactiveBgColor: Colors.grey[800],
                                          inactiveFgColor: Colors.white,
                                          initialLabelIndex: 0,
                                          totalSwitches: 2,
                                          labels: ['STAKE', 'UNSTAKE'],
                                          onToggle: (index) {},
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        ToggleSwitch(
                                          borderColor: [(Colors.grey[800])!],
                                          minWidth: 50.0,
                                          minHeight: 30.0,
                                          fontSize: xsTxSize,
                                          activeBgColor: [(Colors.grey[800])!],
                                          activeFgColor: Colors.amber[600],
                                          inactiveBgColor: Colors.grey[800],
                                          inactiveFgColor: Colors.white,
                                          initialLabelIndex: 0,
                                          totalSwitches: 4,
                                          labels: ['25%', '50%', '75%', 'MAX'],
                                          onToggle: (index) {},
                                        ),
                                      ],
                                    ),
                                  ],
                                )),

                                // text field box
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: ConstrainedBox(
                                    constraints:
                                        BoxConstraints.tight(Size(350, 60)),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[900],
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: (Colors.amber[600])!,
                                              width: 3.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: (Colors.grey[900])!,
                                              width: 3.0,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(),
                                          hintText:
                                              'Enter the amount of AX to stake'),
                                    ),
                                  ),
                                ),

                                // Approve button
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        child: const Text('APPROVE'),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context),
                                          );
                                        },
                                        style: approveButton,
                                      ),
                                      height: 50,
                                      width: 350,
                                    )),

                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        child:
                                            const Text('Connect to a wallet'),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context),
                                          );
                                        },
                                        style: connectButton,
                                      ),
                                      height: 50,
                                      width: 350,
                                    ))
                              ],
                            )),
                          ],
                        ))
                      ],
                    )),
              ],
            )
          ],
        )),
      ],
    ));
  }
}
