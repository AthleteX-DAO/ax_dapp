import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  Token? tkn1;
  Token? tkn2;
  List<Token> tokenListFilter = [];
  int tokenNumber = 0;
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

    tokenNumber = widget.tknNum;

    for (Athlete ath in AthleteList.list) {
      tokens.add(Token(ath.name + " APT", ath.name + " APT", AssetImage('assets/images/apt.png')));
    }    

    tokenListFilter = tokens;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    isWeb = kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        // SingleChildScrollView prevents bottom overflow when keyboard pops up
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              width: isWeb ? _width * 0.20 : _width * 0.55,
              height: _height * .65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // column of elements
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    height: _height * .625,
                    width: _width * 0.45 + 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                height: 30,
                                alignment: Alignment.centerLeft,
                                child: Text("Select a Token",style: textStyle(Colors.grey[400]!, 16, false))),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Icon(Icons.close,color: Colors.grey[400], size: 30),
                            ))
                          ]),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: createSearchBar(),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Token Name", style: textStyle(Colors.grey[400]!, 12, false),),
                        ),   
                        Container(
                          child: Divider(thickness: 1, color: Colors.grey[400]),
                        ),
                        Container(
                            height: _height * .625 - 125,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: tokenListFilter.length,
                                itemBuilder: (context, index) {
                                  return widget.createTokenElement(
                                      tokenListFilter[index], tokenNumber);
                                }
                            )
                          ),
                      ],
                    )
                  )
                ],
              )),
        ));
  }

  Widget createSearchBar() {
    double _height = MediaQuery.of(context).size.height;
    double textSize = _height * 0.05;
    double searchBarHintTextSize = textSize * 0.30;
    if (!isWeb) searchBarHintTextSize = textSize * 0.40;
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
                  contentPadding: EdgeInsets.only(bottom: 10),
                  hintText: "Search a name or paste an address",
                  hintStyle: TextStyle(color: Colors.white, fontSize: searchBarHintTextSize, height: 1.5),
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
