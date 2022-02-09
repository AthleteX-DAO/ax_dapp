import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:get/get.dart';

class AthleteTokenList extends StatefulWidget {
  final BuildContext context;
  final int tknNum;
  final Widget Function(Token, int) createTokenElement;
  AthleteTokenList(this.context, this.tknNum, this.createTokenElement);

  @override
  _AthleteTokenListState createState() => _AthleteTokenListState();
}

class _AthleteTokenListState extends State<AthleteTokenList> {
  SwapController swapController = Get.find();
  double fromAmount = 0.0;
  double toAmount = 0.0;
  bool allFarms = true;
  Token? tkn1;
  Token? tkn2;
  List<Token> tokenListFilter = [];
  int tokenNumber = 0;

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

    tokenNumber = widget.tknNum;

    for (Athlete ath in AthleteList.list)
      tokens.add(Token(ath.name + " APT", ath.name + " APT",
          AssetImage('../assets/images/apt.png')));

    tokenListFilter = tokens;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
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
                                      style: textStyle(
                                          Colors.grey[400]!, 16, false))),
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
                                  return widget.createTokenElement(
                                      tokenListFilter[index], tokenNumber);
                                }))
                      ],
                    ))
              ],
            )));
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
                    tokenListFilter = tokens
                        .where((token) => token.ticker
                            .toUpperCase()
                            .contains(value.toUpperCase()))
                        .toList();
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
