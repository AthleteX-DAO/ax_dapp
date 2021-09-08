import 'dart:math';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:ae_dapp/contracts/AthleteX.g.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/browser.dart';

// flutter format .
import 'package:url_launcher/url_launcher.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ae_dapp/style/Style.dart';
import 'package:web3dart/web3dart.dart';
import '../contracts/StakingRewards.g.dart';

_launchURL(String $url) async {
  if (await canLaunch($url)) {
    await launch($url);
  } else {
    throw 'Could not launch ${$url}';
  }
}

Controller _controller = Controller();

// Defined Staking
final EthereumAddress stakingAddr =
    EthereumAddress.fromHex("0x063086C5b352F986718Db9383c894Be9Cd4350fA");
StakingRewards _stakingRewards =
    StakingRewards(address: stakingAddr, client: _controller.client);
int _amount = 0;
bool stakeBoolean = true;
// Defined AthelteX
final EthereumAddress axTokenAddr =
    EthereumAddress.fromHex("0x8c086885624c5b823cc6fca7bff54c454d6b5239");
AthleteX athleteX = AthleteX(address: axTokenAddr, client: _controller.client);

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    backgroundColor: Colors.grey[900],
    title: Text('Connect to a wallet',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 20,
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
              _launchURL("https://metamask.io");
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
            onPressed: () async {
              _launchURL("https://walletconnect.org");
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
                child: Text('Coinbase Wallet'),
              ),
            ),
            onPressed: () {
              _launchURL("https://wallet.coinbase.com");
            },
            style: walletButton,
          ),
        ),
      ],
    ),
  );
}

class AXPage extends StatefulWidget {
  @override
  _AXState createState() => _AXState();
}

class _AXState extends State<AXPage> {
  // final EthereumAddress tokenAddr = "0x585E0c93F73C520ca6513fc03f450dAea3D4b493";
  // final EthereumAddress stakingAddr = "0x063086C5b352F986718Db9383c894Be9Cd4350fA";

  @override
  void initState() {
    checkMetamask();
    super.initState();
  }

  // Actionable
  Future<void> buyAX() async {}
  Future<void> stakeAX() async {
    BigInt stakeAmount = BigInt.from(_amount);
    Credentials stakeCredentials = _controller.credentials;
    try {
      _stakingRewards.stake(stakeAmount, credentials: stakeCredentials);
    } catch (e) {
      print('Error occured! $e');
    } finally {
      print("Staked successfully!");
    }
    print("Attempting to stake... ");
  }

  Future<void> checkMetamask() async {
    final eth = window.ethereum;
    if (eth != null) {
      print('Connected to the decentralized web!');
      // Immediately
      final client = Web3Client.custom(eth.asRpcService());
      final credentials = await eth.requestAccount();
      _controller.updateClient(client);
      _controller.updateCredentials(credentials);
      return;
    }
  }

  Future<void> claimRewards() async {}
  Future<void> unstakeAX() async {
    Credentials credentials = _controller.credentials;
    BigInt amount = BigInt.from(_amount);
    try {
      _stakingRewards.withdraw(amount, credentials: credentials);
    } catch (e) {
      print(e);
    }
  }

  // Viewable
  Future<BigInt> totalBalance() async {
    return BigInt.from(111);
  }

  Future<BigInt> availableBalance() async {
    EthereumAddress account = await _controller.credentials.extractAddress();
    return athleteX.balanceOf(account);
  }

  Future<BigInt> stakedAX() async {
    EthereumAddress account = await _controller.credentials.extractAddress();
    return _stakingRewards.balanceOf(account);
  }

  Future<double> getAPY() async {
    return new Random().nextDouble();
  }

  Future<BigInt> rewardsEarned() async {
    return _stakingRewards.rewardPerToken();
  }

  Future<double> unclaimedRewards() async {
    return new Random(300).nextDouble();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        // background image
        Container(
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(.9), BlendMode.darken),
              image: AssetImage("assets/images/background.jpeg"),
            ),
          ),
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
            margin: EdgeInsets.fromLTRB(0, 75, 0, 250),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("AX LIQUIDITY",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: lgTxSize,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      )),
                ])),

        // main user area
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 125, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: (Colors.grey[900])!),
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      height: 550,
                      width: 1000,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //LEFT SIDE PANEL
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 450,
                                  width: 350,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 300,
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Account',
                                                style: axHeader,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: StreamBuilder(
                                                  stream: Stream.periodic(
                                                          Duration(seconds: 7))
                                                      .asyncMap((event) =>
                                                          stakedAX()),
                                                  builder: (context,
                                                          snapshot) =>
                                                      Text(
                                                          'Staked AX: ${snapshot.data.toString()}',
                                                          style: axSubheader),
                                                )),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: StreamBuilder(
                                                  stream: Stream.periodic(
                                                          Duration(seconds: 7))
                                                      .asyncMap((event) =>
                                                          availableBalance()),
                                                  builder: (context,
                                                          snapshot) =>
                                                      Text(
                                                          'Available AX: ${snapshot.data.toString()}',
                                                          style: axSubheader),
                                                )),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: StreamBuilder(
                                                  stream: Stream.periodic(
                                                          Duration(seconds: 7))
                                                      .asyncMap((event) =>
                                                          totalBalance()),
                                                  builder: (context,
                                                          snapshot) =>
                                                      Text(
                                                          'Total AX: ${snapshot.data.toString()}',
                                                          style: axSubheader),
                                                )),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Rewards',
                                                style: axHeader,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: StreamBuilder(
                                                  stream: Stream.periodic(
                                                          Duration(seconds: 7))
                                                      .asyncMap(
                                                          (event) => getAPY()),
                                                  builder: (context,
                                                          snapshot) =>
                                                      Text(
                                                          'APY: ${snapshot.data.toString()}',
                                                          style: axSubheader),
                                                )),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: StreamBuilder(
                                                  stream: Stream.periodic(
                                                          Duration(seconds: 7))
                                                      .asyncMap((event) =>
                                                          rewardsEarned()),
                                                  builder: (context,
                                                          snapshot) =>
                                                      Text(
                                                          'Rewards Earned: ${snapshot.data.toString()}',
                                                          style: axSubheader),
                                                )),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: StreamBuilder(
                                                  stream: Stream.periodic(
                                                          Duration(seconds: 7))
                                                      .asyncMap((event) =>
                                                          unclaimedRewards()),
                                                  builder: (context,
                                                          snapshot) =>
                                                      Text(
                                                          'Unclaimed Rewards: ${snapshot.data.toString()}',
                                                          style: axSubheader),
                                                )),
                                          ),
                                          Container(height: 20),
                                          Container(
                                            width: 200,
                                            height: 50,
                                            child: ElevatedButton(
                                              child: Text('CLAIM REWARDS'),
                                              onPressed: () async {
                                                if (window.ethereum == null) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        _buildPopupDialog(
                                                            context),
                                                  );
                                                }
                                              },
                                              style: claimButton,
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            height: 50,
                                            child: ElevatedButton(
                                              child: Text('BUY AX'),
                                              onPressed: () async {
                                                _launchURL(
                                                    "https://www.axmarkets.net/ax");
                                              },
                                              style: claimButton,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          ),
                          //RIGHT SIDE PANEL
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: (Colors.grey[800])!),
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                  height: 500,
                                  width: 550,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 30, 0, 20),
                                            child: Container(
                                              width: 300,
                                              height: 50,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Liquidity',
                                                  style: axHeader1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 20,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Add liquidity to stake AX',
                                                style: axSubheader2,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 20,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Remove liquidity to receive AX',
                                                style: axSubheader2,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
                                            child: Container(
                                              width: 300,
                                              height: 75,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: ToggleSwitch(
                                                  customTextStyles: [
                                                    TextStyle(
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    TextStyle(
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ],
                                                  minWidth: 100.0,
                                                  minHeight: 40.0,
                                                  fontSize: 15,
                                                  activeBgColor: [
                                                    (Colors.amber[600])!
                                                  ],
                                                  activeFgColor:
                                                      Colors.grey[800],
                                                  inactiveBgColor:
                                                      Colors.grey[900]!,
                                                  inactiveFgColor:
                                                      Colors.grey[800]!,
                                                  initialLabelIndex: 0,
                                                  totalSwitches: 2,
                                                  labels: ['STAKE', 'UNSTAKE'],
                                                  onToggle: (index) {},
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 100,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                    fillColor: Colors.grey[900],
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      borderSide: BorderSide(
                                                        color: (Colors
                                                            .amber[600])!,
                                                        width: 3.0,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      borderSide: BorderSide(
                                                        color:
                                                            (Colors.grey[900])!,
                                                        width: 3.0,
                                                      ),
                                                    ),
                                                    border:
                                                        UnderlineInputBorder(),
                                                    hintText:
                                                        'Enter the amount of AX to stake'),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Container(
                                              width: 300,
                                              height: 50,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: ElevatedButton(
                                                  child: const Text('APPROVE'),
                                                  onPressed: () async {
                                                    if (window.ethereum ==
                                                        null) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _buildPopupDialog(
                                                                context),
                                                      );
                                                    } else {
                                                      // Testing out staking
                                                      stakeAX();
                                                    }
                                                  },
                                                  style: approveButton,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 50,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                child: const Text(
                                                    'Connect Wallet'),
                                                onPressed: () async {
                                                  if (window.ethereum == null) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          _buildPopupDialog(
                                                              context),
                                                    );
                                                  } else {
                                                    checkMetamask();
                                                  }
                                                },
                                                style: connectButton,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )))
      ],
    ));
  }
}
