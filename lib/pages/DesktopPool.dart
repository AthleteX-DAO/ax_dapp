import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteTokenList.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/service/TokenList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DesktopPool extends StatefulWidget {
  const DesktopPool({Key? key}) : super(key: key);

  @override
  _DesktopPoolState createState() => _DesktopPoolState();
}

class _DesktopPoolState extends State<DesktopPool> {
  SwapController swapController = Get.find();
  bool isAllLiquidity = true;
  double fromAmount = 0.0;
  double toAmount = 0.0;
  Token? tkn1;
  Token? tkn2;
  bool isWeb = true;
  List<Token> tokenListFilter = [];

  @override
  void initState() {
    super.initState();
    try {
      tkn1 = TokenList.tokenList[1];
      tkn2 = TokenList.tokenList[3];
    } catch (e) {
      print("[Console] TokenList is empty?: $e");
    }

    tokenListFilter = TokenList.tokenList;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    double _height = mediaquery.size.height;
    double _width = mediaquery.size.width;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double layoutHgt = _height * 0.8;
    double layoutWdt = isWeb ? _width * 0.8 : _width * 0.9;

    print(_width);
    return Container(
        width: _width,
        height: _height - AppBar().preferredSize.height,
        //Top margin of Pool section is equal to height + 1 of AppBar on mobile only
        margin: isWeb
            ? EdgeInsets.zero
            : EdgeInsets.only(top: AppBar().preferredSize.height + 10),
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
    //Using 87% of layoutHgt at the moment (76) Pool Card + (5) Title + (6) Toggle Button
    bool isAdvDetails = true;
    double allLiquidityCardHgt = isWeb ? 300 : layoutHgt * 0.76;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Liquidity Pool Title
        Container(
          height: isWeb ? 45 : layoutHgt * 0.05,
          alignment: Alignment.bottomLeft,
          child:
              Text("Liquidity Pool", style: textStyle(Colors.white, 24, true)),
        ),
        //Toggle Liquidity Button
        togglePoolButton(layoutHgt, layoutWdt),
        //Liquidity pool grey card
        Container(
          width: layoutWdt,
          height: allLiquidityCardHgt,
          decoration: boxDecoration(
              Colors.grey[800]!.withOpacity(0.25), 30, 1.5, Colors.grey[400]!),
          //if isWeb return a row structure for all liquidity card, else return a column
          child: isWeb
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: allLiquidityCardContents(
                      layoutHgt, layoutWdt, allLiquidityCardHgt, isAdvDetails),
                )
              : Column(
                  children: allLiquidityCardContents(
                      layoutHgt, layoutWdt, allLiquidityCardHgt, isAdvDetails),
                ),
        ),
        //Empty filler space for web
        if (isWeb) Container(height: layoutHgt * 0.5 - 300),
      ],
    );
  }

  List<Widget> allLiquidityCardContents(double layoutHgt, double layoutWdt,
      double allLiquidityCardHgt, bool isAdvDetails) {
    double elementWdt = isWeb ? layoutWdt / 2 : layoutWdt;
    double tokensSectionHgt = isWeb ? 275 : allLiquidityCardHgt * 0.55;
    //Returns the contents of all liquidity pool card
    return <Widget>[
      //Tokens side add liq. -left side of all liquidity pool card in desktop, top of card in mobile-
      Container(
        height: tokensSectionHgt,
        width: elementWdt,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Balance text on top of tokenContainer
            Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(right: 50),
                child: Text("Balance: 0.00",
                    style: textStyle(Colors.grey[600]!, 13, false))),
            //Top Token container
            tokenContainer(1, elementWdt),
            Container(
                child: Text(
              "+",
              style: textStyle(Colors.grey[600]!, 35, true),
            )),
            Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(right: 50),
                child: Text("Balance: 0.00",
                    style: textStyle(Colors.grey[600]!, 13, false))),
            // Bottom Token container
            tokenContainer(2, elementWdt),
          ],
        ),
      ),
      // Pool details side (add liq.) -right side of liquidity pool card, bottom of card in mobile-
      pricePoolShareDetails(elementWdt, isAdvDetails),
    ];
  }

  Widget myLiquidityLayout(double layoutHgt, double layoutWdt) {
    double titleHgt = layoutHgt * 0.05;
    double gridHgt = layoutHgt * 0.75;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          //My Liquidity title
          children: [
            Container(
              height: titleHgt,
              width: layoutWdt * 0.4,
              alignment: Alignment.bottomLeft,
              child: Text("My Liquidity",
                  style: textStyle(Colors.white, 24, true)),
            ),
            //searchbar for mobile (next to title)
            if (!isWeb) createMyLiquiditySearchBar(layoutHgt, layoutWdt),
          ],
        ),
        Row(
          children: [
            togglePoolButton(layoutHgt, layoutWdt),
            //searchbar for desktop (next to toggle button)
            if (isWeb) createMyLiquiditySearchBar(layoutHgt, layoutWdt),
          ],
        ),
        Container(
          height: gridHgt,
          child: myLiquidityLayoutGrid(layoutHgt, layoutWdt),
        )
      ],
    );
  }

  Widget createMyLiquiditySearchBar(double layoutHgt, double layoutWdt) {
    return Container(
      //1 - title width
      width: isWeb ? 300 : layoutWdt * 0.6,
      //same as title
      height: isWeb ? 40 : layoutHgt * 0.05,
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
                    tokenListFilter = TokenList.tokenList
                        .where((token) => token.name
                            .toUpperCase()
                            .contains(value.toUpperCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8.5),
                  hintText: "Search a farm",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myLiquidityLayoutGrid(double layoutHgt, double layoutWdt) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: isWeb
          ? const SliverGridDelegateWithMaxCrossAxisExtent(
              //delegate max width for desktop
              maxCrossAxisExtent: 600,
              mainAxisExtent: 265,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            )
          : SliverGridDelegateWithFixedCrossAxisCount(
              //delegate count of 1 for mobile
              crossAxisCount: 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 265,
            ),
      itemCount: tokenListFilter.length,
      itemBuilder: (BuildContext ctx, index) {
        return myLiquidityPoolGridItem(tokenListFilter[index], layoutWdt);
      },
    );
  }

  Widget myLiquidityPoolGridItem(Token athleteToken, double layoutWdt) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: GridTile(
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: boxDecoration(
              Colors.grey[800]!.withOpacity(0.25), 30, 1.5, Colors.grey[400]!),
          child: Column(
            children: <Widget>[
              //Item's title with icons
              Row(
                children: [
                  //AX icon
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/X_Logo_Black_BR.png"),
                      ),
                    ),
                  ),
                  //Token icon, if token does not have icon use default icon
                  if (athleteToken.icon != null) ...[
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/apt.png"),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(athleteToken.icon as String),
                        ),
                      ),
                    ),
                  ],
                  //title
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "AX / " + athleteToken.name,
                      style: textStyle(Colors.white, 24, true),
                    ),
                  ),
                ],
              ),
              //Pool token information
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Your Pool Tokens:",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$1,000,000",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Pooled AX:",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "1,000",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Pooled " + athleteToken.name + " APT:",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "500",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Your Pool Share:",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "0.12%",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Rewards Accumulated:",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "100 AX",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Item's Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // add button
                  Container(
                      width: (isWeb) ? 155 : (layoutWdt / 2) - 30,
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
                      width: (isWeb) ? 155 : (layoutWdt / 2) - 30,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tokenContainer(int tknNum, double elementWdt) {
    //Returns the tokenContainer containing dropdown menu button with token icon and ticker
    //element width refers to the width of half the all liquidity card (for desktop only)
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
      height: 70,
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
    double toggleWdt = isWeb ? 260 : layoutWdt;
    return Container(
      width: toggleWdt,
      height: isWeb ? 40 : layoutHgt * 0.06,
      margin: EdgeInsets.symmetric(vertical: layoutHgt * 0.04),
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: isWeb ? 120 : (toggleWdt / 2) - 5,
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
              width: isWeb ? 120 : (toggleWdt / 2) - 5,
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

  Widget pricePoolShareDetails(double elementWdt, bool isAdvDetails) {
    //element width refers to the width of the widget that is returned by this method
    elementWdt = isWeb ? elementWdt * 0.85 : elementWdt * 0.9;
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
                    ),
                  ),
                )
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
    //Callback function that is called when token is chosen from AthleteTokenList widget
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
