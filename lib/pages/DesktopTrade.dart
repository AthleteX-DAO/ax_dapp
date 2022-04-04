import 'package:ax_dapp/service/AthleteTokenList.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../service/TokenList.dart';

class DesktopTrade extends StatefulWidget {
  const DesktopTrade({Key? key}) : super(key: key);

  @override
  _DesktopTradeState createState() => _DesktopTradeState();
}

class _DesktopTradeState extends State<DesktopTrade> {
  SwapController swapController = Get.find();
  WalletController walletController = Get.find();
  double fromAmount = 0.0;
  double toAmount = 0.0;
  Token? tknFrom;
  Token? tknTo;
  bool isWeb = true;

  // List<Token> tokens = [
  //   AXT("AthleteX", "AX", AssetImage('assets/images/X_Logo_Black_BR.png')),
  //   SXT("SportX", "SX", AssetImage('assets/images/SX_Small.png')),
  //   MATIC("Matic/Polygon", "Matic",
  //       AssetImage('assets/images/Polygon_Small.png')),
  // ];

  @override
  void initState() {
    super.initState();
    try {
      tknFrom = TokenList.tokenList[0];
      tknTo = TokenList.tokenList[1];
    } catch (error) {
      print("[Console] TokenList is empty?: $error");
    }

    // print("Inside initState");
    // for (Athlete ath in AthleteList.list) {
    //   print("Inside for loop");
    //   print(AXT.idToAddress[ath.id]![1]);
    //   tokens.add(APT(
    //       ath.name + " Long",
    //       ath.name + " Long",
    //       AssetImage('../assets/images/apt.png'),
    //       AXT.idToAddress[ath.id]![1])); // Long
    //   print(AXT.idToAddress[ath.id]![2]);
    //   tokens.add(APT(
    //       ath.name + " Short",
    //       ath.name + " Short",
    //       AssetImage('../assets/images/apt.png'),
    //       AXT.idToAddress[ath.id]![2])); // Short
    // }
    // tokenListFilter = tokens;
    // print("Finished intState");
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _height = MediaQuery.of(context).size.height;
    double fromAmount = 0, toAmount = 0;
    double wid = 550;

    Widget swapButton = Container(
        //Approve button on desktop / Confirm button on mobile (might need to change later)
        height: _height * 0.05,
        width: wid - 50,
        decoration: boxDecoration(Colors.transparent, 100, 4, Colors.blue),
        child: TextButton(
            onPressed: () {},
            child: Text(
              "Select token to swap with",
              style: textStyle(Colors.blue, 16, true),
            )));

    if (tknFrom != null && tknTo != null)
      swapButton = Container(
          margin:
              isWeb ? EdgeInsets.only(top: 30.0) : EdgeInsets.only(top: 20.0),
          height: isWeb ? _height * 0.05 : _height * 0.06,
          width: wid - 50,
          decoration: isWeb
              ? boxDecoration(Colors.transparent, 500, 1, Colors.amber[600]!)
              : boxDecoration(Colors.amber[500]!.withOpacity(0.20), 500, 1,
                  Colors.transparent),
          child: TextButton(
              onPressed: () {
                swapController.updateFromToken(tknFrom!);
                swapController.updateFromAddress(tknFrom!.address.value);
                swapController.updateFromAmount(fromAmount);
                swapController.updateToToken(tknTo!);
                swapController.updateToAddress(tknTo!.address.value);
                swapController.updateToAmount(toAmount);
                swapController.approve().then((value) => null);
                showDialog(
                    context: context,
                    builder: (BuildContext context) => swapDialog(context));
              },
              child: Text(isWeb ? "Approve" : "Swap",
                  style: isWeb
                      ? textStyle(Colors.amber[500]!, 16, true)
                      : textStyle(Colors.amber[500]!, 16, true))));

    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: _height - 114,
        alignment: Alignment.center,
        child: Container(
          height: _height * 0.475,
          width: wid,
          decoration: boxDecoration(
              Colors.grey[800]!.withOpacity(0.6), 30, 0.5, Colors.grey[400]!),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                    padding:
                        isWeb ? EdgeInsets.only(left: 20) : EdgeInsets.all(0),
                    width: wid - 50,
                    alignment: isWeb ? Alignment.centerLeft : Alignment.center,
                    child: Text(isWeb ? "Swap" : "Token Swap",
                        style: textStyle(Colors.white, 16, false))),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  width: wid - 50,
                  alignment: Alignment.centerLeft,
                  child: Text("From",
                      style: textStyle(Colors.grey[400]!, 12, false)),
                ),
                Container(
                  width: wid - 50,
                  height: _height * 0.1,
                  alignment: Alignment.center,
                  decoration: boxDecoration(
                      Colors.transparent, 20, 0.5, Colors.grey[400]!),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: wid - 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // to-dropdown
                            //tknNum = 1 (this is a comment)
                            createTokenButton(1),
                            // Amount box
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
                                          onPressed: () {
                                            swapController.activeTkn1.value;
                                            print(swapController.amount1);
                                          },
                                          child: Text("MAX",
                                              style: textStyle(
                                                  Colors.grey[400]!,
                                                  8,
                                                  false)))),
                                  SizedBox(
                                    width: 70,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        fromAmount = double.parse(value);
                                        swapController
                                            .updateFromAmount(fromAmount);
                                      },
                                      style: textStyle(
                                          Colors.grey[400]!, 22, false),
                                      decoration: InputDecoration(
                                        hintText: '0.00',
                                        hintStyle: textStyle(
                                            Colors.grey[400]!, 22, false),
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
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FutureBuilder<String>(
                              future: walletController.getTokenBalance(
                                  swapController.address1.value),
                              builder: (context, snapshot) {
                                //Check API response data
                                if (snapshot.hasError) {
                                  // can't get balance
                                  return showBalance('---');
                                } else if (snapshot.hasData) {
                                  // got the balance
                                  return showBalance(snapshot.data!);
                                } else {
                                  // loading
                                  return Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(
                                          color: Colors.amber),
                                      height: 10.0,
                                      width: 10.0,
                                    ),
                                  );
                                }
                              },
                            ),
                            //showBalance(await walletController.getTokenBalance(swapController.address1)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              Column(
                children: <Widget>[
                  Container(
                    child: TextButton(
                        onPressed: () {
                          if (tknTo != null) {
                            Token tmpTkn = tknFrom!;
                            setState(() {
                              tknFrom = tknTo;
                              tknTo = tmpTkn;
                            });
                          }
                        },
                        child: Icon(
                          Icons.arrow_downward,
                          size: _height * 0.05,
                          color: Colors.grey[400],
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    width: wid - 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "To",
                      style: textStyle(Colors.grey[400]!, 12, false),
                    ),
                  ),
                  Container(
                    width: wid - 50,
                    height: _height * 0.1,
                    alignment: Alignment.center,
                    decoration: boxDecoration(
                        Colors.transparent, 20, 0.5, Colors.grey[400]!),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: wid - 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //TO DO: make this and the input box above a single function
                          // dropdown
                          //tknNum = 2 (this is a comment)
                          createTokenButton(2),
                          // Amount box
                          Container(
                            width: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
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
                                            onPressed: () {
                                              swapController.activeTkn2.value;
                                              print(swapController.amount2);
                                            },
                                            child: Text("MAX",
                                                style: textStyle(
                                                    Colors.grey[400]!,
                                                    8,
                                                    false)))),
                                    SizedBox(
                                      width: 70,
                                      child: TextFormField(
                                        onChanged: (value) {
                                          toAmount = double.parse(value);
                                          swapController
                                              .updateToAmount(toAmount);
                                        },
                                        style: textStyle(
                                            Colors.grey[400]!, 22, false),
                                        decoration: InputDecoration(
                                          hintText: '0.00',
                                          hintStyle: textStyle(
                                              Colors.grey[400]!, 22, false),
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
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FutureBuilder<String>(
                                      future: walletController.getTokenBalance(
                                          swapController.address2.value),
                                      builder: (context, snapshot) {
                                        //Check API response data
                                        if (snapshot.hasError) {
                                          // can't get balance
                                          return showBalance('---');
                                        } else if (snapshot.hasData) {
                                          // got the balance
                                          return showBalance(snapshot.data!);
                                        } else {
                                          // loading
                                          return Center(
                                            child: SizedBox(
                                              child: CircularProgressIndicator(
                                                  color: Colors.amber),
                                              height: 10.0,
                                              width: 10.0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              swapButton
            ],
          ),
        ),
      ),
    );
  }

  Widget createTokenElement(Token token, int tknNum) {
    //Creates a token item for AthleteTokenList widget
    double _width = MediaQuery.of(context).size.width;
    return Container(
        height: 50,
        child: TextButton(
            onPressed: () {
              setState(() {
                if (tknNum == 1) {
                  tknFrom = token;
                  print("tkn1: ${token.address.value}");
                  swapController.updateFromAddress(token.address.value);
                } else {
                  tknTo = token;
                  swapController.updateToAddress(token.address.value);
                }
                Navigator.pop(context);
              });
            },
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
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        scale: 0.5,
                        image: token.icon!,
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
                            width: (_width < 350.0) ? 110 : 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.ticker,
                              style: textStyle(Colors.white, 14, true),
                            )),
                        Container(
                            width: (_width < 350.0) ? 110 : 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.name,
                              style: textStyle(Colors.grey[100]!, 9, false),
                            )),
                      ],
                    ))
              ],
            ))));
  }

  Widget createTokenButton(int tknNum) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double textSize = _height * 0.05;
    double tkrTextSize = textSize * 0.25;
    if (!isWeb) tkrTextSize = textSize * 0.35;
    String tkr = "Select a Token";
    AssetImage? tokenImage = AssetImage('../assets/images/apt.png');
    BoxDecoration decor =
        boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!);
    if (tknNum == 1) {
      if (tknFrom == null)
        decor = boxDecoration(Colors.blue, 100, 0, Colors.blue);

      if (tknFrom != null) {
        tkr = tknFrom!.ticker;
        tokenImage = tknFrom!.icon;
      }
    } else {
      if (tknTo == null)
        decor = boxDecoration(Colors.blue, 100, 0, Colors.blue);

      if (tknTo != null) {
        tkr = tknTo!.ticker;
        tokenImage = tknTo!.icon;
      }
    }

    return Container(
        constraints: BoxConstraints(
          maxWidth: (_width < 350.0) ? 115 : 150,
          maxHeight: 100,
        ),
        height: 40,
        decoration: decor,
        child: TextButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AthleteTokenList(context, tknNum, createTokenElement)),
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: tokenImage!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(
                  child: Text(tkr,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle(Colors.white, tkrTextSize, true)),
                ),
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

  TextStyle textStyle(Color color, double size, bool isBold) {
    if (isBold)
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
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

  Widget showBalance(String balance) {
    //Returns widget that shows balance underneath input box
    return Flexible(
      child: Text(
        "Balance: $balance",
        style: textStyle(Colors.grey[400]!, 14, false),
      ),
      // padding: EdgeInsets.only(right: 14),
    );
  }
}
