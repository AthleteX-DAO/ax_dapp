import 'package:ax_dapp/pages/DesktopTrade.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DesktopPool extends StatefulWidget {
  const DesktopPool({Key? key}) : super(key: key);

  @override
  _DesktopPoolState createState() => _DesktopPoolState();
}

class _DesktopPoolState extends State<DesktopPool> {
  SwapController swapController = Get.find();
  bool allLiq = true;
  List<Token> tokenListFilter = [];

  List<Token> tokens = [
    AXT("AthleteX", "AX", AssetImage('../assets/images/x.jpg')),
    SXT("SportX", "SX", AssetImage('../assets/images/sx.png')),
    MATIC("Matic/Polygon", "Matic", AssetImage('../assets/images/matic.png')),
  ];

  @override
  void initState() {
    super.initState();

    for (Athlete ath in AthleteList.list)
      tokens.add(Token(ath.name + " APT", ath.name + " APT",
          AssetImage('../assets/images/apt.png')));

    tokenListFilter = tokens;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double hgt = _height*0.7;

    return Container(
      width: _width,
      height: _height - 57,
      alignment: Alignment.center,
      child: Container(
        width: _width * 0.8,
        height: hgt,
        child: (allLiq) ? allLiquidity() : myLiquidity()
      )
    );
  }

  Widget allLiquidity() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double wid = _width*0.75;

    Widget toggle = Container(
      width: 260,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 120,
              decoration: boxDecoration(
                  Colors.grey[600]!, 100, 0, Colors.transparent),
              child: TextButton(
                onPressed: () {},
                child: Text("Add Liquidity",
                style: textStyle(Colors.white, 16, true)
              )
            )
          ),
          Container(
            width: 115,
            decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
            child: TextButton(
              onPressed: () {
                setState(() {
                  allLiq = false;
                });
              },
              child: Text(
                "My Liquidity",
                style: textStyle(Colors.white, 16, true)
              )
            )
          )
        ]
      )
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 45,
          alignment: Alignment.bottomLeft,
          child: Text(
            "Liquidity Pool",
            style: textStyle(Colors.white, 24, true)
          )
        ),
        toggle,
        Container(
          width: wid,
          height: 300,
          decoration: boxDecoration(Colors.grey[800]!.withOpacity(0.6), 30, 0.5, Colors.grey[400]!),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Pool tokens side (add liq.)
              Container(
                height: 250,
                width: wid/2-20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // Top balance text 
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 30),
                          child: Text(
                            "Balance: 0.00",
                            style: textStyle(Colors.grey[600]!, 13, false)
                          )
                        ),
                        // Top Token container
                        tokenContainer(1),
                      ],
                    ),
                    Container(
                      child: Text(
                        "+",
                        style: textStyle(Colors.grey[600]!, 42, true),
                      )
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // Bottom balance text 
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 30),
                          child: Text(
                            "Balance: 0.00",
                            style: textStyle(Colors.grey[600]!, 13, false)
                          )
                        ),
                        // Bottom Token container
                        tokenContainer(2),
                      ],
                    ),
                  ],
                ),
              ),
              // Pool details side (add liq.)
              Container(
                width: wid/2-20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Details: Price and Pool Share",
                        style: textStyle(Colors.white, 21, true),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // AX per / APT per
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: (wid/2-20)/2-20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "AX per tkn APT:",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    ),
                                    Text(
                                      "2.24",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    )
                                  ],
                                )
                              ),
                              Container(
                                width: (wid/2-20)/2-20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "tkn APT per AX:",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    ),
                                    Text(
                                      "1.48",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    )
                                  ],
                                )
                              ),
                            ],
                          )
                        ),
                        // pool share / exp. yield
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: (wid/2-20)/2-20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Share of pool:",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    ),
                                    Text(
                                      "0.12%",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    )
                                  ],
                                )
                              ),
                              Container(
                                width: (wid/2-20)/2-20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Expected yield:",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    ),
                                    Text(
                                      "24.12%",
                                      style: textStyle(Colors.grey[600]!, 16, false),
                                    )
                                  ],
                                )
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ],
                )
              ),
            ],
          )
        ),
        Container(
          height: _height*0.5-300
        )
      ],
    );
  }

  Widget myLiquidity() {
    double _height = MediaQuery.of(context).size.height;

    Widget toggle = Container(
      width: 260,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 120,
              decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    allLiq = true;
                  });
                },
                child: Text("Add Liquidity",
                style: textStyle(Colors.white, 16, true)
              )
            )
          ),
          Container(
            width: 115,
            decoration: boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "My Liquidity",
                style: textStyle(Colors.white, 16, true)
              )
            )
          ),
        ]
      )
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 45,
            alignment: Alignment.bottomLeft,
            child: Text(
              "My Liquidity",
              style: textStyle(Colors.white, 24, true)
            )
          ),
          toggle,
          Container(
            height: _height*0.5,
          )
        ],
      ),
    );
  }

  Widget tokenContainer(int which) {
    BoxDecoration decor = boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!);
    
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: boxDecoration(Colors.transparent, 20, .5, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // left-half of token box (token)
          Container(
            width: 175,
            height: 40,
            decoration: decor,
            child: TextButton(
              onPressed: () {},
              // onPressed: () => showDialog(
              //   context: context,
              //   builder: (BuildContext context) => AthleteTokenList(context, tknNum, createTokenElement)),
              // ),
              child: Container(
                width: 145,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // image: DecorationImage(
                        //   image: tokenImage!,
                        //   fit: BoxFit.fill,
                        // ),
                      ),
                    ),
                    Container(width: 10),
                    Expanded(
                      child: Text("todo", style: textStyle(Colors.white, 16, true)),
                    ), 
                    Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 25)
                  ],
                )
              )
            )
          ),
          // right-half of token box
          Container(
            child: Row(
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
                    child: Text(
                      "MAX",
                      style: textStyle(Colors.grey[400]!, 8, false)
                    )
                  )
                ),
                SizedBox(
                  width: 70,
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
                      FilteringTextInputFormatter.allow((RegExp(r'^(\d+)?\.?\d{0,2}'))),
                    ],
                  ),
                ),
              ],
            )
          )
        ],
      )
    );
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

  BoxDecoration boxDecoration(Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}