import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/AthleteTokenList.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DesktopPool extends StatefulWidget {
  const DesktopPool({Key? key}) : super(key: key);

  @override
  _DesktopPoolState createState() => _DesktopPoolState();
}

class _DesktopPoolState extends State<DesktopPool> {
  SwapController swapController = Get.find();
  bool isAllLiquidity = true;
  List<Token> tokenListFilter = [];
  double fromAmount = 0.0;
  double toAmount = 0.0;
  Token? tkn1;
  Token? tkn2;

  List<Token> tokensList = [
    AXT("AthleteX", "AX", AssetImage('assets/images/x.png')),
    SXT("SportX", "SX", AssetImage('assets/images/sx.png')),
    MATIC("Matic/Polygon", "Matic", AssetImage('assets/images/matic.png')),
  ];

  @override
  void initState() {
    super.initState();

    for (Athlete ath in AthleteList.list)
      tokensList.add(Token(ath.name + " APT", ath.name + " APT",
          AssetImage('assets/images/apt.png')));

    tkn1 = tokensList[0];
    tkn2 = tokensList[3];

    tokenListFilter = tokensList;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    double _height = mediaquery.size.height;
    double _width = mediaquery.size.width;
    double layoutHgt = _height * 0.8;
    double layoutWdt = _width * 0.8;

    print(_width);
    return Container(
        width: _width,
        height: _height - AppBar().preferredSize.height,
        alignment: Alignment.center,
        child: Container(
            width: layoutWdt,
            height: layoutHgt,
            child: (isAllLiquidity)
                ? allLiquidityLayout(layoutHgt, layoutWdt)
                : myLiquidityLayout(layoutHgt, layoutWdt)));
  }

  Widget allLiquidityLayout(double layoutHgt, double layoutWdt) {
    //Boolean to show advanced details
    bool isAdvDetails = true;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 45,
          alignment: Alignment.bottomLeft,
          child:
              Text("Liquidity Pool", style: textStyle(Colors.white, 24, true)),
        ),
        togglePoolButton(layoutHgt, layoutWdt),
        //Liquidity pool grey card
        Container(
          width: layoutWdt,
          height: 300,
          decoration: boxDecoration(
              Colors.grey[800]!.withOpacity(0.25), 30, 0.5, Colors.grey[400]!),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Pool tokens side (add liq.) -left side of liquidity pool card-
              Container(
                height: 275,
                width: layoutWdt / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 25),
                    //Balance text on top of tokenContainer
                    Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 50),
                        child: Text("Balance: 0.00",
                            style: textStyle(Colors.grey[600]!, 13, false))),
                    //Top Token container
                    tokenContainer(1, layoutWdt / 2),
                    Container(
                        child: Text(
                      "+",
                      style: textStyle(Colors.grey[600]!, 42, true),
                    )),
                    Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 50),
                        child: Text("Balance: 0.00",
                            style: textStyle(Colors.grey[600]!, 13, false))),
                    // Bottom Token container
                    tokenContainer(2, layoutWdt / 2),
                  ],
                ),
              ),
              // Pool details side (add liq.) -right side of liquidity pool card-
              pricePoolShareDetails(layoutWdt, layoutHgt, isAdvDetails),
            ],
          ),
        ),
        Container(height: layoutHgt * 0.5 - 300)
      ],
    );
  }

  Widget myLiquidityLayout(double layoutHgt, double layoutWdt) {
    double _height = layoutHgt * 0.8;
    double _width = layoutWdt;

    List<Widget> poolRows = [];
    for (int i = 0; i < AthleteList.list.length;) {
      poolRows.add(Container(
          alignment: Alignment.topCenter,
          height: 325,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 1 pool per row
              createPoolCard(AthleteList.list[i++]),
              // 2 pools per row
              if (_width > 818 && i < AthleteList.list.length) ...{
                SizedBox(width: 30),
                createPoolCard(AthleteList.list[i++]),
              },
              // 3 pools per row
              if (_width > 1227 && i < AthleteList.list.length) ...{
                SizedBox(
                  width: 30,
                ),
                createPoolCard(AthleteList.list[i++])
              },
              // 4 pools per row
              if (_width > 1636 && i < AthleteList.list.length) ...{
                SizedBox(
                  width: 30,
                ),
                createPoolCard(AthleteList.list[i++])
              }
            ],
          )));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            height: 45,
            alignment: Alignment.bottomLeft,
            child:
                Text("My Liquidity", style: textStyle(Colors.white, 24, true))),
        togglePoolButton(layoutHgt, layoutWdt),
        Container(
            height: _height,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: BouncingScrollPhysics(),
                itemCount: poolRows.length,
                itemBuilder: (context, index) {
                  return Container(height: 325, child: poolRows[index]);
                }))
      ],
    );
  }

  Widget tokenContainer(int tknNum, double elementWdt) {
    double tokenContainerWdt = elementWdt * 0.9;
    String tkr = "Select a Token";
    AssetImage? tokenImage = AssetImage('assets/images/apt.png');
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
      height: 75,
      width: tokenContainerWdt,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: boxDecoration(Colors.transparent, 20, .5, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // left-half of token box (dropdown menu button containing token)
          Container(
            width: 175,
            height: 40,
            decoration: decor,
            child: TextButton(
              // onPressed: (){},
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AthleteTokenList(context, tknNum, createTokenElement),
              ),
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
                    child: Text(tkr, style: textStyle(Colors.white, 16, true)),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 25)
                ],
              ),
            ),
          ),
          // right-half of token box (max button and input box)
          Container(
              child: Row(
            children: <Widget>[
              Container(
                  height: 24,
                  width: 40,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 0.5, Colors.grey[400]!),
                  child: TextButton(
                      onPressed: () {
                        swapController.activeTkn1.value;
                        print(swapController.amount1);
                      },
                      child: Text("MAX",
                          style: textStyle(Colors.grey[400]!, 8, false)))),
              SizedBox(
                width: tokenContainerWdt * 0.15,
                child: TextFormField(
                  onChanged: (value) {},
                  style: textStyle(Colors.grey[400]!, 22, false),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: textStyle(Colors.grey[400]!, 22, false),
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
          ))
        ],
      ),
    );
  }

  Widget togglePoolButton(double layoutHgt, double layoutWdt) {
    return Container(
      width: 260,
      height: 40,
      margin: EdgeInsets.symmetric(vertical: layoutHgt * 0.04),
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 120,
              decoration: isAllLiquidity
                  ? boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent)
                  : boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent),
              child: TextButton(
                  onPressed: () {
                    if (!isAllLiquidity) {
                      setState(() {
                        isAllLiquidity = true;
                      });
                    }
                  },
                  child: Text("Add Liquidity",
                      style: textStyle(Colors.white, 16, true)))),
          Container(
              width: 115,
              decoration: isAllLiquidity
                  ? boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent)
                  : boxDecoration(
                      Colors.grey[600]!, 100, 0, Colors.transparent),
              child: TextButton(
                  onPressed: () {
                    if (isAllLiquidity) {
                      setState(() {
                        isAllLiquidity = false;
                      });
                    }
                  },
                  child: Text("My Liquidity",
                      style: textStyle(Colors.white, 16, true))))
        ],
      ),
    );
  }

  Widget pricePoolShareDetails(
      double layoutWdt, double layoutHgt, bool isAdvDetails) {
    //element width refers to the width of the widget that is returned by this method
    double elementWdt = layoutWdt / 2 * 0.85;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              (isAdvDetails) ? "Details: Price and Pool Share" : "Details",
              style: textStyle(Colors.white, 21, true),
            ),
          ),
          Container(
            width: elementWdt,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "AX per tkn APT:",
                  style: textStyle(Colors.grey[600]!, 15, false),
                ),
                Text(
                  "2.24",
                  style: textStyle(Colors.white, 15, false),
                ),
                Text(
                  "Share of pool:",
                  style: textStyle(Colors.grey[600]!, 15, false),
                ),
                Text(
                  "0.12%",
                  style: textStyle(Colors.white, 15, false),
                ),
              ],
            ),
          ),
          // pool share / exp. yield
          Container(
            width: elementWdt,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "tkn APT per AX:",
                  style: textStyle(Colors.grey[600]!, 15, false),
                ),
                Text(
                  "1.48",
                  style: textStyle(Colors.white, 15, false),
                ),
                Text(
                  "Expected yield:",
                  style: textStyle(Colors.grey[600]!, 15, false),
                ),
                Text(
                  "24.12%",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            width: elementWdt,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "*Add liquidity to earn 0.25% of all trades on this pair",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                  TextSpan(
                      text:
                          " proportional to your share of the pool and receive LP tokens.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                ],
              ),
            ),
          ),
          (isAdvDetails)
              ? Container(
                  width: elementWdt,
                  height: 45,
                  decoration: boxDecoration(
                      Colors.amber[400]!, 100, 0, Colors.amber[400]!),
                  child: TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              poolAddLiquidity(context, tkn2!.name)),
                      child: Text(
                        "Add Liquidity",
                        style: textStyle(Colors.black, 16, true),
                      )))
              : Container(
                  width: elementWdt,
                  height: 45,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 1, Colors.amber[400]!),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Approve",
                        style: textStyle(Colors.amber[400]!, 16, true),
                      )))
        ],
      ),
    );
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
                              style: textStyle(Colors.white, 14, true),
                            )),
                        Container(
                            width: 125,
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

  Widget createPoolCard(Athlete athlete) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double iwid = 329;

    return Container(
        width: 379,
        height: 275,
        decoration: boxDecoration(Colors.grey[900]!, 30, 1, Colors.grey[400]!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: iwid,
                alignment: Alignment.centerLeft,
                child: Text(
                  "AX / " + athlete.name + " APT",
                  style: textStyle(Colors.white, 24, true),
                )),
            Container(
                width: iwid,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Your Pool Tokens:",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                        Text(
                          "\$1,000,000",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Pooled AX:",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                        Text(
                          "1,000",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Pooled " + athlete.name + " APT:",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                        Text(
                          "500",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Your Pool Share:",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                        Text(
                          "0.12%",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Rewards Accumulated:",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                        Text(
                          "100 AX",
                          style: textStyle(Colors.grey[600]!, 16, true),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
                width: iwid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // add button
                    Container(
                        width: 160,
                        height: 37.5,
                        decoration: boxDecoration(
                            Colors.amber[400]!, 100, 0, Colors.amber[400]!),
                        child: TextButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    poolAddLiquidity(context, tkn2!.name)),
                            child: Text(
                              "Add",
                              style: textStyle(Colors.black, 20, true),
                            ))),
                    //remove button
                    Container(
                        width: 160,
                        height: 37.5,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 1, Colors.amber[400]!),
                        child: TextButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    poolRemoveLiquidity(context, tkn2!.name)),
                            child: Text(
                              "Remove",
                              style: textStyle(Colors.amber[400]!, 18, true),
                            ))),
                  ],
                )),
          ],
        ));
  }

  TextStyle textStyle(Color color, double size, bool isBold) {
    if (isBold)
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w500,
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

class Farm {
  final String name;
  Athlete? athlete;

  Farm(this.name, [this.athlete]);
}
