import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/colors.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DesktopTrade extends StatefulWidget {
  const DesktopTrade({Key? key}) : super(key: key);

  @override
  _DesktopTradeState createState() => _DesktopTradeState();
}

class _DesktopTradeState extends State<DesktopTrade> {
  SwapController swapController = Get.find();
  double fromAmount = 0.0;
  double toAmount = 0.0;
  bool allFarms = true;
  Token? tkn1;
  Token? tkn2;
  List<Token> tokenListFilter = [];

  List<Token> tokens = [
    AXT("AthleteX", "AX", AssetImage('../assets/images/x.jpg')),
    SXT("SportX", "SX", AssetImage('../assets/images/sx.png')),
    MATIC("Matic/Polygon", "Matic", AssetImage('../assets/images/matic.png')),
  ];

  @override
  void initState() {
    super.initState();
    tkn1 = tokens[0];
    tkn2 = tokens[1];

    for (Athlete ath in AthleteList.list)
      tokens.add(Token(ath.name + " APT", ath.name + " APT",
          AssetImage('../assets/images/apt.png')));

    tokenListFilter = tokens;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double fromAmount = 0, toAmount = 0;
    double wid = 550;
    double hgt = 380;
    if (_height < 480) hgt = _height;

    Widget swapButton = Container(
        height: 50,
        width: wid - 50,
        decoration: boxDecoration(Colors.transparent, 100, 4, Colors.blue),
        child: TextButton(
            onPressed: () {},
            child: Text(
              "Select token to swap with",
              style: textStyle(Colors.blue, 16, true, false),
            )));

    if (tkn1 != null && tkn2 != null)
      swapButton = Container(
          height: 50,
          width: wid - 50,
          decoration:
              boxDecoration(Colors.amber[400]!, 100, 4, Colors.amber[400]!),
          child: TextButton(
              onPressed: () {
                if (tkn1 != null && tkn2 != null)
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
              child: Text(
                "Swap",
                style: textStyle(Colors.black, 16, true, false),
              )));

    return Container(
        height: _height - 57,
        alignment: Alignment.center,
        child: Container(
            // color: Colors.blue,
            height: hgt,
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
                    child: Text("From",
                        style: textStyle(Colors.grey[400]!, 12, false, false)),
                  ),
                  // From-dropdown
                  Container(
                      width: wid - 50,
                      height: _height * 0.1,
                      alignment: Alignment.center,
                      decoration: boxDecoration(
                          Colors.transparent, 20, 0.5, Colors.grey[400]!),
                      child: Container(
                          width: wid - 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // to-dropdown
                              createTokenButton(1),
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
                                                  swapController
                                                      .activeTkn1.value;
                                                  print(swapController.amount1);
                                                },
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
                                                  (RegExp(
                                                      r'^(\d+)?\.?\d{0,2}'))),
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
                  //To text
                  Container(
                    width: wid - 75,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "To",
                      style: textStyle(Colors.grey[400]!, 12, false, false),
                    ),
                  ),
                  // To-dropdown
                  Container(
                      width: wid - 50,
                      height: _height * 0.1,
                      alignment: Alignment.center,
                      decoration: boxDecoration(
                          Colors.transparent, 20, 0.5, Colors.grey[400]!),
                      child: Container(
                          width: wid - 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // dropdown
                              createTokenButton(2),
                              // Amount box
                              SizedBox(
                                width: 70,
                                child: TextFormField(
                                  onChanged: (value) {
                                    toAmount = double.parse(value);
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
                        /*Row(
                          children: <Widget>[
                            Container(
                              width: wid - 75,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Slippage tolerance:",
                                style: textStyle(
                                    Colors.grey[400]!, 12, false, false),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "2%",
                                style: textStyle(
                                    Colors.grey[400]!, 12, false, false),
                              ),
                            ),
                          ],
                        ),*/
                        // Swap Button
                        swapButton,
                      ],
                    ))
              ],
            )));
  }

  Dialog createTokenList(BuildContext context, int tknNum) {
    double _height = MediaQuery.of(context).size.height;

    /*for (Athlete ath in AthleteList.list)
      tokens.add(Token(ath.name + " APT", ath.name + " APT",
          AssetImage('../assets/images/apt.png')));*/

    return Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
            width: 400,
            height: _height * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // column of elements
                Container(
                    height: _height * .625,
                    width: 350,
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
                        createSearchBar(),
                        Container(
                            height: _height * .625 - 100,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: tokenListFilter.length,
                                itemBuilder: (context, index) {
                                  return createTokenElement(
                                      tokenListFilter[index], tknNum);
                                }))
                      ],
                    ))
              ],
            )));
  }

  Widget createTokenElement(Token token, int tknNum) {
    return Container(
        height: 50,
        child: TextButton(
            onPressed: () {
              setState(() {
                if (tknNum == 1)
                  tkn1 = token;
                else
                  tkn2 = token;
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
                            width: 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.ticker,
                              style: textStyle(Colors.white, 14, true, false),
                            )),
                        Container(
                            width: 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.name,
                              style:
                                  textStyle(Colors.grey[100]!, 9, false, false),
                            )),
                      ],
                    ))
              ],
            ))));
  }

  Widget createTokenButton(int tknNum) {
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
        width: 175,
        height: 40,
        decoration: decor,
        child: TextButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    createTokenList(context, tknNum)),
            child: Container(
                //width: 90,
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
                  child: Text(tkr, style: textStyle(Colors.white, 16, true, false)),
                ), 
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 25)
              ],
            ))));
  }

  Widget createSearchBar() {
    return Container(
      width: 300,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(width: 8),
          Container(
            child: Icon(Icons.search, color: Colors.white),
          ),
          Container(width: 10),
          Expanded(
            child: Container(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    tokenListFilter = tokens.where((token) => token.name.toUpperCase().contains(value.toUpperCase())).toList();
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8.5),
                  hintText: "Search a name or paste an address",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
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
