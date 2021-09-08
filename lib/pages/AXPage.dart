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
    EthereumAddress.fromHex("0xD842133F7f9b88866e6B7cd0d72ec05B037b7C92");
StakingRewards _stakingRewards =
    StakingRewards(address: stakingAddr, client: _controller.client);
int _amount = 0;
bool stakeBoolean = true;
// Defined AthelteX
final EthereumAddress axTokenAddr =
    EthereumAddress.fromHex("0xc51d9bf2C238037462BA7FEd84AeC99543e0a1FD");
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
    super.initState();
  }

  // Actionable
  Future<void> buyAX() async {}

  Future<void> stakeAX() async {
    BigInt stakeAmount = BigInt.from(_amount);
    Credentials stakeCredentials = _controller.credentials;
    Transaction stakingTransaction = Transaction(maxGas: 21000, gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 50));
    try {
      _stakingRewards.stake(stakeAmount,
          credentials: stakeCredentials, transaction: stakingTransaction);
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

  Future<void> claimRewards() async {

  }

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

  Future<dynamic> availableBalance() async {
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

  Future<dynamic> rewardsEarned() async {
    return _stakingRewards.rewardPerToken();
  }

  Future<BigInt> unclaimedRewards() async {
    return new Random(300).nextDouble() as BigInt;
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
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              width: 950,
              height: 500,
              margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // my account info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Main Left Area
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: (Colors.grey[900])!),
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          alignment: Alignment.center,
                          height: 450,
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            // Main Left Area
                            children: [
                              Column(
                                children: [
                                  // My Account
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                                      child: StreamBuilder(
                                        stream: Stream.periodic(
                                                Duration(seconds: 7))
                                            .asyncMap(
                                                (event) => availableBalance()),
                                        builder: (context, snapshot) => Text(
                                          'Available AX: ${snapshot.data.toString()}',
                                          style: TextStyle(
                                            fontSize: smTxSize,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )),

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
                                          onPressed: () async {
                                            if (window.ethereum == null) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _buildPopupDialog(context),
                                              );
                                            } else {
                                              checkMetamask();
                                              claimRewards();
                                            }
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
                                          onPressed: () async {
                                            _launchURL(
                                                "https://www.axmarkets.net/ax");
                                          },
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Main Right Area
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: (Colors.grey[900])!),
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          alignment: Alignment.center,
                          height: 450,
                          width: 500,

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
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child:
                                              Text('Add liquidity to stake AX',
                                                  style: TextStyle(
                                                    fontSize: smTxSize,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.w200,
                                                  ))),

                                      // remove note
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 60),
                                          child: Text(
                                              'Remove liquidity to receive AX',
                                              style: TextStyle(
                                                fontSize: smTxSize,
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
                                                activeBgColor: [
                                                  (Colors.grey[900])!
                                                ],
                                                activeFgColor:
                                                    Colors.amber[600],
                                                inactiveBgColor:
                                                    Colors.grey[900],
                                                inactiveFgColor: Colors.white,
                                                initialLabelIndex: 0,
                                                totalSwitches: 2,
                                                labels: ['STAKE', 'UNSTAKE'],
                                                onToggle: (index) {
                                                  setState(() {
                                                    index == 0
                                                        ? stakeBoolean = true
                                                        : stakeBoolean = false;
                                                  });
                                                  print(
                                                      "$index + $stakeBoolean");
                                                },
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              ToggleSwitch(
                                                borderColor: [
                                                  (Colors.grey[900])!
                                                ],
                                                minWidth: 50.0,
                                                minHeight: 30.0,
                                                fontSize: xsTxSize,
                                                activeBgColor: [
                                                  (Colors.grey[900])!
                                                ],
                                                activeFgColor:
                                                    Colors.amber[600],
                                                inactiveBgColor:
                                                    Colors.grey[900],
                                                inactiveFgColor: Colors.white,
                                                initialLabelIndex: 0,
                                                totalSwitches: 4,
                                                labels: [
                                                  '25%',
                                                  '50%',
                                                  '75%',
                                                  'MAX'
                                                ],
                                                onToggle: (index) {},
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),

                                      // text field box
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints.tight(
                                              Size(350, 60)),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                fillColor: Colors.grey[900],
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  borderSide: BorderSide(
                                                    color: (Colors.amber[600])!,
                                                    width: 3.0,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  borderSide: BorderSide(
                                                    color: (Colors.grey[900])!,
                                                    width: 3.0,
                                                  ),
                                                ),
                                                border: UnderlineInputBorder(),
                                                hintText:
                                                    'Enter the amount of AX to stake'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'This field cannot be left empty';
                                              }
                                            },
                                            onChanged: (inputValue) {
                                              int value = int.parse(inputValue);
                                              setState(() {
                                                _amount = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),

                                      // Approve button
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          child: SizedBox(
                                            child: ElevatedButton(
                                              child: const Text('APPROVE'),
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
                                                  stakeBoolean
                                                      ? stakeAX()
                                                      : unstakeAX();
                                                }
                                              },
                                              style: approveButton,
                                            ),
                                            height: 50,
                                            width: 350,
                                          )),

                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: SizedBox(
                                            child: ElevatedButton(
                                              child:
                                                  const Text('Connect Wallet'),
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
            ))
      ],
    ));
  }
}
