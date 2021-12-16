import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/AthleteApi.dart';
import 'package:ae_dapp/service/AthleteList.dart';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Dialog.dart';
import 'package:flutter/services.dart';

class DesktopTrade extends StatefulWidget {
  const DesktopTrade({Key? key}) : super(key: key);

  @override
  _DesktopTradeState createState() => _DesktopTradeState();
}

class _DesktopTradeState extends State<DesktopTrade> {
  double fromAmount = 0.0;
  double toAmount = 0.0;
  bool allFarms = true;
  Coin topCoin = Coin("AthleteX", "AX", AssetImage('../assets/images/x.png'));
  Coin bottomCoin = Coin(
      "Select a Token", "Select a Token", AssetImage('../assets/images/x.png'));
  List<Coin> coins = [
    Coin("AthleteX", "AX", AssetImage('../assets/images/x.png')),
    Coin("SportX", "SX", AssetImage('../assets/images/x.png')),
    Coin("Matic/Polygon", "Matic", AssetImage('../assets/images/x.png')),
  ];

  @override
  Widget build(BuildContext context) {
    double wid = 550;

    return Column(children: <Widget>[
      Container(height: MediaQuery.of(context).size.height * 0.15),
      Container(
          height: 350,
          width: wid,
          decoration: boxDecoration(
              Colors.grey[800]!.withOpacity(0.6), 30, 0.5, Colors.grey[400]!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  width: wid - 50,
                  alignment: Alignment.centerLeft,
                  child: Text("Swap",
                      style: textStyle(Colors.white, 16, false, false))),
              Column(children: <Widget>[
                //From text
                Container(
                  width: wid - 75,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text("From",
                      style: textStyle(Colors.grey[400]!, 12, false, false)),
                ),
                // From-dropdown
                Container(
                    width: wid - 50,
                    height: 75,
                    alignment: Alignment.center,
                    decoration: boxDecoration(
                        Colors.transparent, 20, 0.5, Colors.grey[400]!),
                    child: Container(
                        width: wid - 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // to-dropdown
                            createTokenButton(topCoin),
                            Container(
                                width: 110,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          height: 24,
                                          width: 40,
                                          decoration: boxDecoration(
                                              Colors.transparent,
                                              100,
                                              0.5,
                                              Colors.grey[400]!),
                                          child: TextButton(
                                              onPressed: () {},
                                              child: Text("MAX",
                                                  style: textStyle(
                                                      Colors.grey[400]!,
                                                      8,
                                                      false,
                                                      false)))),
                                      SizedBox(
                                        width: 70,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            fromAmount = double.parse(value);
                                            print(fromAmount);
                                          },
                                          style: textStyle(Colors.grey[400]!,
                                              22, false, false),
                                          decoration: InputDecoration(
                                            hintText: '0.00',
                                            hintStyle: textStyle(
                                                Colors.grey[400]!,
                                                22,
                                                false,
                                                false),
                                            contentPadding:
                                                const EdgeInsets.all(9),
                                            border: InputBorder.none,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                                          ],
                                        ),
                                      ),
                                    ]))
                          ],
                        ))),
              ]),
              Column(children: <Widget>[
                //Down arrow
                Container(
                  child: Icon(
                    Icons.arrow_downward,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ),
                //To text
                Container(
                  width: wid - 75,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "To",
                    style: textStyle(Colors.grey[400]!, 12, false, false),
                  ),
                ),
                // To-dropdown
                Container(
                    width: wid - 50,
                    height: 75,
                    alignment: Alignment.center,
                    decoration: boxDecoration(
                        Colors.transparent, 20, 0.5, Colors.grey[400]!),
                    child: Container(
                        width: wid - 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // dropdown
                            createTokenButton(bottomCoin),
                            // Amount box
                            SizedBox(
                              width: 70,
                              child: TextFormField(
                                onChanged: (value) {
                                  toAmount = double.parse(value);
                                  print(toAmount);
                                },
                                style: textStyle(
                                    Colors.grey[400]!, 22, false, false),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: textStyle(
                                      Colors.grey[400]!, 22, false, false),
                                  contentPadding: const EdgeInsets.all(9),
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                                ],
                              ),
                            ),
                          ],
                        ))),
              ]),
              //Swap button container
              Container(
                  width: wid - 50,
                  child: Column(
                    children: <Widget>[
                      //Slippage tolerance text
                      Row(
                        children: <Widget>[
                          Container(
                            width: wid - 75,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Slippage tolerance:",
                              style: textStyle(
                                  Colors.grey[400]!, 12, false, false),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "2%",
                              style: textStyle(
                                  Colors.grey[400]!, 12, false, false),
                            ),
                          ),
                        ],
                      ),
                      // Swap Button
                      Container(
                          height: 50,
                          width: wid - 50,
                          decoration: boxDecoration(
                              Colors.amber[400]!, 100, 4, Colors.amber[400]!),
                          child: TextButton(
                              onPressed: () => dialog(
                                    context,
                                    MediaQuery.of(context).size.height * .55,
                                    MediaQuery.of(context).size.width * .25,
                                    boxDecoration(
                                        Colors.grey[900]!, 30, 0, Colors.black),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      // Confirm Swap
                                      children: <Widget>[
                                        Container(
                                          //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .22,
                                          height: 50,
                                          //color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Confirm Swap",
                                                style: textStyle(Colors.white,
                                                    20, false, false),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .22,
                                          height: 50,
                                          //color: Colors.red,
                                          child: Column(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "From",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "-\$1.600",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "Tom Brady APT",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "10.24",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .22,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.arrow_downward,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .22,
                                          height: 50,
                                          //color: Colors.red,
                                          child: Column(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "To",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "-\$1.580",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "Lebron James APT",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "8.48",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Horizontal Linebreak
                                        Container(
                                          child: Divider(
                                            thickness: 0.35,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        // Price Information and Confirm Swap Button
                                        Container(
                                          //margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .22,
                                          height: 125,
                                          //color: Colors.red,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "Price",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "1.2 T.B.APT per L.J.APT",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "LP Fee",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "0.5 AX",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "Market Price Impact",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "-0.04%",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "Minimum Recieved",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "8.2 L.J.APT",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "Estimated Slippage",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "~5%",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .22,
                                          height: 30,
                                          //color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 15.0),
                                                child: Text(
                                                  "You recieve:",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 15.0),
                                                child: Text(
                                                  "7.98 Lebron James APT",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .22,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 30.0, bottom: 10.0),
                                                width: 210,
                                                height: 55,
                                                decoration: BoxDecoration(
                                                  color: Colors.amber[400],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: TextButton(
                                                  //onPressed: () => showDialog(context: context, builder: (BuildContext context) => confirmTransaction(context)),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            confirmTransaction(
                                                                context));
                                                  },
                                                  child: const Text(
                                                    "Confirm Swap",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              child: Text(
                                "Swap",
                                style: textStyle(Colors.black, 16, true, false),
                              ))),
                    ],
                  ))
            ],
          )),
    ]);
  }

  Dialog createTokenList(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
            width: 350,
            height: MediaQuery.of(context).size.height * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // column of elements
                Container(
                    height: MediaQuery.of(context).size.height * .625,
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Token Name",
                                      style: textStyle(Colors.grey[400]!, 16,
                                          false, false))),
                              Container(
                                  child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Icon(Icons.close,
                                    color: Colors.grey[400], size: 30),
                              ))
                            ]),
                        Container(
                          child: Divider(thickness: 1, color: Colors.grey[400]),
                        ),
                        Container(
                            height:
                                MediaQuery.of(context).size.height * .625 - 100,
                            child: FutureBuilder<dynamic>(
                                future: AthleteApi.getAthletesLocally(context),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      // return circle indicator for progress
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    default:
                                      AthleteList.list = snapshot.data;
                                      for (Athlete ath in AthleteList.list)
                                        coins.add(Coin(
                                            ath.name + " APT",
                                            ath.name + " APT",
                                            AssetImage(
                                                '../assets/images/apt.png')));

                                      return ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: coins.length,
                                          itemBuilder: (context, index) {
                                            return createTokenElement(
                                                coins[index]);
                                          });
                                  }
                                }))
                      ],
                    ))
              ],
            )));
  }

  Widget createTokenElement(Coin coin) {
    return Container(
        height: 50,
        child: TextButton(
            onPressed: () {},
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 60,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: coin.icon,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 45,
                    // ticker/name column "AX/AthleteX"
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            width: 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              coin.ticker,
                              style: textStyle(Colors.white, 14, true, false),
                            )),
                        Container(
                            width: 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              coin.name,
                              style:
                                  textStyle(Colors.grey[100]!, 9, false, false),
                            )),
                      ],
                    ))
              ],
            ))));
  }

  Widget createTokenButton(Coin coin) {
    BoxDecoration decor =
        boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!);
    if (coin.ticker == "Select a Token")
      decor = boxDecoration(Colors.blue, 100, 0, Colors.blue);

    return Container(
        width: 175,
        height: 40,
        decoration: decor,
        child: TextButton(
            onPressed: () =>
                showDialog(context: context, builder: createTokenList),
            child: Container(
                //width: 90,
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(coin.ticker,
                    style: textStyle(Colors.white, 16, true, false)),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 25)
              ],
            ))));
  }

  void dialog(BuildContext context, double _height, double _width,
      BoxDecoration _decoration, Widget _child) {
    Dialog fancyDialog = Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
            height: _height,
            width: _width,
            decoration: _decoration,
            child: _child));

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold) if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}

class Coin {
  String name;
  String ticker;
  AssetImage icon;

  Coin(this.name, this.ticker, this.icon);
}
