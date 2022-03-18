import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/AthleteTokenList.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DesktopTrade extends StatefulWidget {
  const DesktopTrade({Key? key}) : super(key: key);

  @override
  _DesktopTradeState createState() => _DesktopTradeState();
}

class _DesktopTradeState extends State<DesktopTrade> {
  SwapController swapController = Get.find();
  double fromAmount = 0.0;
  double toAmount = 0.0;
  Token? tkn1;
  Token? tkn2;
  List<Token> tokenListFilter = [];
  bool isWeb = true;

  List<Token> tokens = [
    AXT("AthleteX", "AX", AssetImage('assets/images/X_Logo_Black_BR.png')),
    SXT("SportX", "SX", AssetImage('assets/images/SX_Small.png')),
    MATIC("Matic/Polygon", "Matic", AssetImage('assets/images/Polygon_Small.png')),
  ];

  @override
  void initState() {
    super.initState();
    tkn1 = tokens[0];
    tkn2 = tokens[1];

    for (Athlete ath in AthleteList.list) {
      tokens.add(Token(ath.name + " Long", ath.name + " Long",
          AssetImage('assets/images/apt.png')));
      tokens.add(Token(ath.name + " Short", ath.name + " Short",
          AssetImage('assets/images/apt.png')));
    }
    tokenListFilter = tokens;
  }

  @override
  Widget build(BuildContext context) {
    isWeb = kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _height = MediaQuery.of(context).size.height;
    double fromAmount = 0, toAmount = 0;
    double wid = 550;

    Widget swapButton = Container(
        height: _height * 0.05,
        width: wid - 50,
        decoration: boxDecoration(Colors.transparent, 100, 4, Colors.blue),
        child: TextButton(
            onPressed: () {},
            child: Text(
              "Select token to swap with",
              style: textStyle(Colors.blue, 16, true),
            )));

    if (tkn1 != null && tkn2 != null)
      swapButton = Container(
          margin: isWeb ? EdgeInsets.only(top: 30.0) :EdgeInsets.only(top: 20.0),
          height: isWeb? _height * 0.05 : _height * 0.06,
          width: wid - 50,
          decoration: isWeb? boxDecoration(Colors.transparent, 500, 1, Colors.amber[600]!) : boxDecoration(Colors.amber[500]!.withOpacity(0.20), 500, 1, Colors.transparent),
          child: TextButton(
              onPressed: () {
                swapController.updateToken1(tkn1!);
                swapController.updateAmount1(fromAmount);
                swapController.updateAmount2(toAmount);
                swapController.updateAddress1(tkn1!.address.value);
                swapController.updateAddress2(tkn2!.address.value);
                swapController.updateToken2(tkn2!);

                showDialog(
                    context: context,
                    builder: (BuildContext context) => swapDialog(context));
              },
              child: Text(isWeb ? "Approve" : "Swap", style: isWeb ? textStyle(Colors.amber[500]!, 16, true) : textStyle(Colors.amber[500]!, 16, true))));

    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
          height: _height - 114,
          alignment: Alignment.center,
          child: Container(
              height: _height * 0.475,
              width: wid,
              decoration: boxDecoration(Colors.grey[800]!.withOpacity(0.6), 30, 0.5, Colors.grey[400]!),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[  
                    Container(
                      padding: isWeb ? EdgeInsets.only(left: 20) : EdgeInsets.all(0),
                      width: wid - 50,
                      alignment: isWeb ? Alignment.centerLeft : Alignment.center,
                      child: Text(isWeb ? "Swap" : "Token Swap", style: textStyle(Colors.white, 16, false))), 
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      width: wid - 50,
                      alignment: Alignment.centerLeft,
                      child: Text("From", style: textStyle(Colors.grey[400]!, 12, false)),
                    ),
                    Container(
                        width: wid - 50,
                        height: _height * 0.1,
                        alignment: Alignment.center,
                        decoration: boxDecoration(Colors.transparent, 20, 0.5, Colors.grey[400]!),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: wid - 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // to-dropdown
                              //tknNum = 1 (this is a comment)
                              createTokenButton(1),
                              // Amount box
                              Container(
                                  width: 110,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            height: 24,
                                            width: 40,
                                            decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                                            child: TextButton(
                                              onPressed: () {
                                                swapController.activeTkn1.value;
                                                print(swapController.amount1);
                                              },
                                              child: Text("MAX",style: textStyle(Colors.grey[400]!, 8, false)))),
                                        SizedBox(
                                          width: 70,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              fromAmount = double.parse(value);
                                            },
                                            style: textStyle(Colors.grey[400]!, 22, false),
                                            decoration: InputDecoration(
                                              hintText: '0.00',
                                              hintStyle: textStyle(Colors.grey[400]!, 22, false),
                                              contentPadding:const EdgeInsets.all(9),
                                              border: InputBorder.none,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow((RegExp(r'^(\d+)?\.?\d{0,2}'))),
                                            ],
                                          ),
                                        ),
                                      ]))
                            ],
                          ))),
                  ]),
                  Column(children: <Widget>[
                    Container(
                      child: TextButton(
                          onPressed: () {
                            if (tkn2 != null) {
                              Token tmpTkn = tkn1!;
                              setState(() {
                                tkn1 = tkn2;
                                tkn2 = tmpTkn;
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
                      child: Text("To", style: textStyle(Colors.grey[400]!, 12, false),
                      ),
                    ),
                    Container(
                      width: wid - 50,
                      height: _height * 0.1,
                      alignment: Alignment.center,
                      decoration: boxDecoration(Colors.transparent, 20, 0.5, Colors.grey[400]!),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                          width: wid - 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // dropdown
                              //tknNum = 2 (this is a comment)
                              createTokenButton(2),
                              // Amount box
                              Container(
                                width: 110,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          height: 24,
                                          width: 40,
                                          decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                                          child: TextButton(
                                            onPressed: () {
                                              swapController.activeTkn2.value;
                                              print(swapController.amount2);
                                            },
                                            child: Text("MAX", style: textStyle(Colors.grey[400]!, 8, false)))),
                                      SizedBox(
                                        width: 70,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            fromAmount = double.parse(value);
                                          },
                                          style: textStyle(Colors.grey[400]!, 22, false),
                                          decoration: InputDecoration(
                                            hintText: '0.00',
                                            hintStyle: textStyle(Colors.grey[400]!, 22, false),
                                            contentPadding: const EdgeInsets.all(9),
                                            border: InputBorder.none,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow((RegExp(r'^(\d+)?\.?\d{0,2}'))),
                                          ],
                                        ),
                                      ),
                                    ]))
                            ],
                          ))),
                  ]),
                  swapButton 
                ],
              ))),
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
                  tkn1 = token;
                } else {
                  tkn2 = token;
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
      if (tkn1 == null) decor = boxDecoration(Colors.blue, 100, 0, Colors.blue);

      if (tkn1 != null) {
        tkr = tkn1!.ticker;
        tokenImage = tkn1!.icon;
      }
    } else {
      if (tkn2 == null) decor = boxDecoration(Colors.blue, 100, 0, Colors.blue);

      if (tkn2 != null) {
        tkr = tkn2!.ticker;
        tokenImage = tkn2!.icon;
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
                child: Text(tkr, overflow: TextOverflow.ellipsis, style: textStyle(Colors.white, tkrTextSize, true)),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 25)
            ],
          )
        )
      )
    );
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
}