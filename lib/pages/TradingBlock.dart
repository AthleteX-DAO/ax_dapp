import 'dart:html';

import 'package:flutter/material.dart';

class TradingBlock extends StatefulWidget {
  const TradingBlock({Key? key}) : super(key: key);

  @override
  _TradingBlockState createState() => _TradingBlockState();
}

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
                )
              ),
              Text(
                "TRADING BLOCK",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: lgTxSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                )
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                "Swap",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: txt,
                                  fontWeight: FontWeight.w600,
                                )
                              )
                            )
                          ),
                          Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                                            color: Colors.grey[900],
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: DropdownButton(
                                              items: [],
                                              icon: const Icon(Icons.arrow_downward),
                                            )
                                          )
                                        ),
                                        Container(
                                          height: 15,
                                          color: Colors.transparent,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                                            color: Colors.grey[900],
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: DropdownButton(
                                              items: [],
                                              icon: const Icon(Icons.arrow_downward),
                                            )
                                          )
                                        ),
                                      //   Row(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: <Widget>[
                                      //       GestureDetector(
                                      //         onTap: () {},
                                      //         child: Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.spaceEvenly,
                                      //           children: <Widget>[
                                      //             Container(
                                      //               width: 6.0,
                                      //             ),
                                      //             Container(
                                      //               width: 4.0,
                                      //             ),
                                      //             Icon(
                                      //               Icons.arrow_forward_ios,
                                      //               color: Colors.grey,
                                      //               size: 14.0,
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                        
                                      //   Container(
                                      //     height: 4,
                                      //   ),
                                      // Row(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: <Widget>[
                                      //       Container(
                                      //         // width: 80.0,
                                      //         height: 10,
                                      //         color: Colors.grey[800],
                                      //       ),
                                      //       RawMaterialButton(
                                      //         onPressed: () {},
                                      //         child: Icon(
                                      //           Icons.swap_vert,
                                      //           size: 20.0,
                                      //           color: Colors.white,
                                      //         ),
                                      //         shape: CircleBorder(),
                                      //         elevation: 4.0,
                                      //         fillColor: Colors.grey[800],
                                      //         padding: EdgeInsets.all(8.0),
                                      //       ),
                                      //       Container(
                                      //         width: 80.0,
                                      //         height: 0.5,
                                      //         color: Color.fromARGB(30, 0, 0, 0),
                                      //       )
                                      //     ],
                                      //   ),
                                        
                                      //   Container(
                                      //     height: 4.0,
                                      //   ),
                                      //   Row(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: <Widget>[
                                      //       GestureDetector(
                                      //         onTap: () {},
                                      //         child: Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.spaceEvenly,
                                      //           children: <Widget>[
                                      //             Container(
                                      //               width: 6.0,
                                      //             ),
                                      //             Container(
                                      //               width: 4.0,
                                      //             ),
                                      //             Icon(
                                      //               Icons.arrow_forward_ios,
                                      //               color: Colors.grey,
                                      //               size: 13.0,
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
                                    ),
                                    child: Icon(
                                      Icons.arrow_downward_sharp,
                                    ),
                                    onPressed: () {},
                                  ),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                                  ),
                                  // color: Colors.grey[800],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(width: 250, height: 55),
                                    child: ElevatedButton(
                                    child: Text(
                                      "CONNECT WALLET",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: butTx,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber[400],
                                      )
                                    ),
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.amber[400]!),
                                        )
                                      )
                                    ),
                                  )
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(width: 250, height: 55),
                                    child: ElevatedButton(
                                    child: Text(
                                      "SWAP",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: butTx,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )
                                    ),
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[400]!),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.amber[400]!),
                                        )
                                      )
                                    ),
                                  )
                                ),
                              ]
                            )
                          )
                        ],
                      )
                    )
                  ),
                ],
              ),
            ],
          )
        ],
      )
    );
  }
}