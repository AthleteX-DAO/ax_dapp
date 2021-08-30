import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

class TradingBlock extends StatefulWidget {
  const TradingBlock({Key? key}) : super(key: key);

  @override
  _TradingBlockState createState() => _TradingBlockState();
}

var walletConnected = true;

Future<bool> getIsWalletConnected() async {
  return true;
}


class _TradingBlockState extends State<TradingBlock> {
  
  @override
  Widget build(BuildContext context) {
    // double txt = 30;
    // double butTx = 20;
    double lgTxSize = 52;

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Image(
          image: AssetImage("assets/images/background.jpeg"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Column(
          children: <Widget>[
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
            Text("APT Swap",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: lgTxSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                )),
            Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    child: Container(
                        width: 500,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius:
                              BorderRadius.all(const Radius.circular(10.0)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(25, 15, 0, 5),
                                    child: Text("Swap",
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )))),
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 30),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    const Radius.circular(
                                                        10.0)),
                                                color: Colors.grey[800],
                                              ),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: DropdownButton(
                                                    items: [],
                                                    icon: const Icon(
                                                        Icons.arrow_downward),
                                                  ))),
                                          Container(
                                            height: 10,
                                            color: Colors.transparent,
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 30),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    const Radius.circular(
                                                        10.0)),
                                                color: Colors.grey[800],
                                              ),
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: DropdownButton(
                                                    items: [],
                                                    icon: const Icon(
                                                        Icons.arrow_downward),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.grey[900]!),
                                      ),
                                      child: Icon(
                                        Icons.arrow_downward_sharp,
                                      ),
                                      onPressed: () {},
                                    ),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // boolean is user wallet connected
                                      // ignore: unrelated_type_equality_checks
                                      getIsWalletConnected() == true
                                          ? ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.amber
                                                      .withOpacity(0.8),
                                                  minimumSize: Size(240, 75),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25))),
                                              child: Text("SWAP",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              onPressed: () {},
                                            )
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.blue
                                                      .withOpacity(0.3),
                                                  minimumSize: Size(450, 60),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25))),
                                              child: Text("Connect Wallet",
                                                  style: TextStyle(
                                                      color: Colors.blue
                                                          .withOpacity(0.8),
                                                      fontSize: 20,
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              onPressed: () async {
                                                // `Ethereum.isSupported` is the same as `ethereum != null`
if (ethereum != null) {
  try {
    // Prompt user to connect to the provider, i.e. confirm the connection modal
    final accs = await ethereum!
        .requestAccount(); // Get all accounts in node disposal
    accs; // [foo,bar]
  } on EthereumUserRejected {
    print('User rejected the modal');
  }
}
                                              },
                                            )
                                    ]))
                          ],
                        ))),
              ],
            ),
          ],
        )
      ],
    ));
  }
}
