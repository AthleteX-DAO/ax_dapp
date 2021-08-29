import 'package:flutter/material.dart';
import 'package:ae_dapp/style/Style.dart';

class TradingBlock extends StatefulWidget {
  const TradingBlock({Key? key}) : super(key: key);

  @override
  _TradingBlockState createState() => _TradingBlockState();
}

Future<bool> getIsWalletConnected() async {
  return true;
}


Widget _tradeConfirmation(BuildContext context) {
  return new AlertDialog(
    backgroundColor: Colors.white,
    title: Text('Confirm Swap',
    textAlign: TextAlign.left,
    style: TextStyle(
      color: Colors.grey[900],
      fontSize: 15,
      fontWeight: FontWeight.w400,
    fontFamily: 'OpenSans',
    )
    ),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Text('')
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Text('')
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text('Confirm Swap'),
                  ),
              ),
            onPressed: () {},
            style: confirmSwap,
          ),
        ),


      ],
    ),
    
  );
}

var walletConnected = true;

class _TradingBlockState extends State<TradingBlock> {
  @override
  Widget build(BuildContext context) {
    double txt = 30;
    double butTx = 20;
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
            Text("SWAP",
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
                            // Align(
                            //     alignment: Alignment.centerLeft,
                            //     child: Padding(
                            //         padding: EdgeInsets.fromLTRB(25, 15, 0, 5),
                            //         child: Text("Swap",
                            //             style: TextStyle(
                            //               fontFamily: 'OpenSans',
                            //               fontSize: 20,
                            //               fontWeight: FontWeight.w400,
                            //             )))),
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 5),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: <Widget>[
                                      // boolean is user wallet connected
                                      // ignore: unrelated_type_equality_checks
                                      walletConnected
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.amber[600],
                                              fixedSize: Size(450, 60),
                                              shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25))
                                            ),
                                          child: Text("Swap", 
                                            style: TextStyle(
                                              letterSpacing: .5,
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w600)),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => _tradeConfirmation(context),
                                            );
                                          },
                                        )
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue.withOpacity(0.3),
                                              fixedSize: Size(450, 60),
                                              shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25))
                                            ),
                                          child: Text("Connect Wallet", 
                                            style: TextStyle(
                                              color: Colors.blue.withOpacity(0.8),
                                              fontSize: 20,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w400)),
                                          onPressed: () {},
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
