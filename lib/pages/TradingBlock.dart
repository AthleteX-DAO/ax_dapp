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
    backgroundColor: Colors.grey[900],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: Text('Confirm Swap', textAlign: TextAlign.left, style: confirmText),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //FROM
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('From', style: confirmText)],
              ),
              Column(
                children: [Text('~\$1,300.00', style: confirmText)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('ETH', style: confirmTextCoin)],
              ),
              Column(
                children: [Text('10.0702', style: confirmTextCoin)],
              )
            ],
          ),
        ),
        //DOWN ARROW
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [Icon(Icons.arrow_downward, size: 15)],
              )
            ],
          ),
        ),
        //TO
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text('To', style: confirmText)],
              ),
              Row(children: [
                Column(children: [Text('~\$1,290.00', style: confirmText)]),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Column(children: [
                      Text('(0.079%)', style: confirmTextPercent)
                    ]))
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'AX',
                    style: confirmTextCoin,
                  )
                ],
              ),
              Column(
                children: [Text('9.1000', style: confirmTextCoin)],
              )
            ],
          ),
        ),
        //PRICE
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Price',
                    style: confirmText,
                  )
                ],
              ),
              Column(
                children: [
                  Text('1 AX = .00589 ETH', style: confirmTextOtherBold)
                ],
              )
            ],
          ),
        ),
        //OTHER INFO
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Liquidity Provider Fee',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.000824 ETH', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Price Impact',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('-0.03%', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Maximum sent',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.289529 ETH', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Slippage tolerance',
                    style: confirmTextOther,
                  )
                ],
              ),
              Column(
                children: [Text('0.05%', style: confirmTextOtherBold)],
              )
            ],
          ),
        ),
        //CONFIRMATION BUTTON
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: confirmSwap,
                  child: Text('Confirm Swap'))
            ],
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
    // double txt = 30;
    // double butTx = 20;
    double lgTxSize = 52;

    return Scaffold(
        body: Stack(
      children: <Widget>[
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
            Container(
                width: 500,
                height: 500,
                color: Colors.transparent,
                child: Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text('COMING SOON', style: comingSoon),
                    ))),
            // Column(
            //   children: <Widget>[
            //     Padding(
            //         padding: EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 0.0),
            //         child: Container(
            //             width: 500,
            //             decoration: BoxDecoration(
            //               color: Colors.grey[900],
            //               borderRadius:
            //                   BorderRadius.all(const Radius.circular(10.0)),
            //             ),
            //             child: Column(
            //               children: <Widget>[
            //                 // Align(
            //                 //     alignment: Alignment.centerLeft,
            //                 //     child: Padding(
            //                 //         padding: EdgeInsets.fromLTRB(25, 15, 0, 5),
            //                 //         child: Text("Swap",
            //                 //             style: TextStyle(
            //                 //               fontFamily: 'OpenSans',
            //                 //               fontSize: 20,
            //                 //               fontWeight: FontWeight.w400,
            //                 //             )))),
            //                 Container(
            //                   color: Colors.transparent,
            //                   padding: EdgeInsets.symmetric(horizontal: 5),
            //                   child: Stack(
            //                     alignment: AlignmentDirectional.center,
            //                     children: [
            //                       Container(
            //                         padding: EdgeInsets.all(12.0),
            //                         decoration: BoxDecoration(
            //                           color: Colors.grey[900],
            //                           borderRadius: BorderRadius.all(
            //                               const Radius.circular(10.0)),
            //                         ),
            //                         child: Center(
            //                           child: Column(
            //                             children: <Widget>[
            //                               Container(
            //                                   padding: EdgeInsets.symmetric(
            //                                       horizontal: 10, vertical: 30),
            //                                   decoration: BoxDecoration(
            //                                     borderRadius: BorderRadius.all(
            //                                         const Radius.circular(
            //                                             10.0)),
            //                                     color: Colors.grey[800],
            //                                   ),
            //                                   child: Align(
            //                                       alignment:
            //                                           Alignment.centerLeft,
            //                                       child: DropdownButton(
            //                                         items: [],
            //                                         icon: const Icon(
            //                                             Icons.arrow_downward),
            //                                       ))),
            //                               Container(
            //                                 height: 10,
            //                                 color: Colors.transparent,
            //                               ),
            //                               Container(
            //                                   padding: EdgeInsets.symmetric(
            //                                       horizontal: 10, vertical: 30),
            //                                   decoration: BoxDecoration(
            //                                     borderRadius: BorderRadius.all(
            //                                         const Radius.circular(
            //                                             10.0)),
            //                                     color: Colors.grey[800],
            //                                   ),
            //                                   child: Align(
            //                                       alignment:
            //                                           Alignment.centerLeft,
            //                                       child: DropdownButton(
            //                                         items: [],
            //                                         icon: const Icon(
            //                                             Icons.arrow_downward),
            //                                       ))),
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //                       Container(
            //                         padding: EdgeInsets.symmetric(vertical: 0),
            //                         child: ElevatedButton(
            //                           style: ButtonStyle(
            //                             backgroundColor:
            //                                 MaterialStateProperty.all<Color>(
            //                                     Colors.grey[900]!),
            //                           ),
            //                           child: Icon(
            //                             Icons.arrow_downward_sharp,
            //                           ),
            //                           onPressed: () {},
            //                         ),
            //                         width: 40,
            //                         height: 40,
            //                         decoration: BoxDecoration(
            //                           color: Colors.grey[900],
            //                           borderRadius: BorderRadius.all(
            //                               const Radius.circular(10.0)),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //                 Padding(
            //                     padding: EdgeInsets.symmetric(
            //                         horizontal: 0, vertical: 20),
            //                     child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: <Widget>[
            //                           // boolean is user wallet connected
            //                           // ignore: unrelated_type_equality_checks
            //                           walletConnected
            //                               ? ElevatedButton(
            //                                   style: ElevatedButton.styleFrom(
            //                                       primary: Colors.amber[600],
            //                                       minimumSize: Size(450, 60),
            //                                       shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               BorderRadius.circular(
            //                                                   25))),
            //                                   child: Text("Swap",
            //                                       style: TextStyle(
            //                                           letterSpacing: .5,
            //                                           color: Colors.white,
            //                                           fontSize: 25,
            //                                           fontFamily: 'OpenSans',
            //                                           fontWeight:
            //                                               FontWeight.w600)),
            //                                   onPressed: () {
            //                                     showDialog(
            //                                       context: context,
            //                                       builder:
            //                                           (BuildContext context) =>
            //                                               _tradeConfirmation(
            //                                                   context),
            //                                     );
            //                                   },
            //                                 )
            //                               : ElevatedButton(
            //                                   style: ElevatedButton.styleFrom(
            //                                       primary: Colors.blue
            //                                           .withOpacity(0.3),
            //                                       minimumSize: Size(450, 60),
            //                                       shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               BorderRadius.circular(
            //                                                   25))),
            //                                   child: Text("Connect Wallet",
            //                                       style: TextStyle(
            //                                           color: Colors.blue
            //                                               .withOpacity(0.8),
            //                                           fontSize: 20,
            //                                           fontFamily: 'OpenSans',
            //                                           fontWeight:
            //                                               FontWeight.w400)),
            //                                   onPressed: () {},
            //                                 )
            //                         ]))
            //               ],
            //             ))),
            //   ],
            // ),
          ],
        )
      ],
    ));
  }
}

// content: new Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(children: [
//               Padding(
//                   padding: EdgeInsets.fromLTRB(15, 0, 200, 5),
//                   child: Text(
//                     'From',
//                     style: confirmText,
//                     textAlign: TextAlign.start,
//                   )),
//               Padding(
//                   padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                   child: Text(
//                     '~\$1,134,280.89',
//                     style: confirmText,
//                     textAlign: TextAlign.right,
//                   )),
//             ]),
//             Row(children: [
//               Padding(
//                   padding: EdgeInsets.fromLTRB(15, 0, 185, 5),
//                   child: Text(
//                     'ETH',
//                     style: confirmTextCoin,
//                     textAlign: TextAlign.start,
//                   )),
//               Padding(
//                   padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
//                   child: Text(
//                     '1.0034',
//                     style: confirmTextCoin,
//                     textAlign: TextAlign.end,
//                   )),
//             ]),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                     child: Icon(
//                       Icons.arrow_downward,
//                       color: Colors.grey[500],
//                       size: 15,
//                     ),
//                   ),
//                 ]),
//             Row(children: [
//               Padding(
//                   padding: EdgeInsets.fromLTRB(15, 25, 150, 5),
//                   child: Text(
//                     'To',
//                     style: confirmText,
//                     textAlign: TextAlign.start,
//                   )),
//               Padding(
//                   padding: EdgeInsets.fromLTRB(15, 25, 0, 5),
//                   child: Text(
//                     '~\$1,100,345.14',
//                     style: confirmText,
//                     textAlign: TextAlign.start,
//                   )),
//               Padding(
//                   padding: EdgeInsets.fromLTRB(5, 25, 0, 5),
//                   child: Text(
//                     '(0.476%)',
//                     style: confirmTextPercent,
//                     textAlign: TextAlign.start,
//                   )),
//             ]),
//             Row(children: [
//               Padding(
//                   padding: EdgeInsets.fromLTRB(15, 0, 200, 5),
//                   child: Text(
//                     'AX',
//                     style: confirmTextCoin,
//                     textAlign: TextAlign.start,
//                   )),
//               Padding(
//                   padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
//                   child: Text(
//                     '2.3809',
//                     style: confirmTextCoin,
//                     textAlign: TextAlign.end,
//                   )),
//             ]),
//             Row(children: [
//               Padding(
//                   padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
//                   child: ElevatedButton(
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//                         child: Text('Confirm Swap'),
//                       ),
//                     ),
//                     onPressed: () {},
//                     style: confirmSwap,
//                   ))
//             ]),
//           ])
