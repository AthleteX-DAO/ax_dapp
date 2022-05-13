import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/service/TokenList.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class MyLiquidity extends StatefulWidget {
  MyLiquidity({Key? key}) : super(key: key);

  @override
  State<MyLiquidity> createState() => _MyLiquidityState();
}

class _MyLiquidityState extends State<MyLiquidity> {
  bool _isWeb = true;
  List<Token> tokenListFilter = [];
  double _width = 0;
  double _layoutHgt = 0;
  @override
  void initState() {
    super.initState();
    //Delete this
    tokenListFilter = TokenList.tokenList;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    final double _height = mediaquery.size.height;
    _width = mediaquery.size.width;
    _layoutHgt = _height * 0.8;
    _isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final double _layoutWdt = _isWeb ? _width * 0.8 : _width * 0.9;

    return myLiquidityLayout(_layoutHgt, _layoutWdt);
  }

  // Delete this
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
                      "AX / " + (athleteToken.ticker + " " + athleteToken.name),
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
                          "Pooled " +
                              (athleteToken.ticker + " " + athleteToken.name) +
                              " APT:",
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
                      width: (_isWeb) ? 155 : (layoutWdt / 2) - 30,
                      height: 37.5,
                      decoration: boxDecoration(
                          Colors.amber[400]!, 100, 0, Colors.amber[400]!),
                      child: TextButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  poolAddLiquidity(
                                      context,
                                      (TokenList.tokenList[0].ticker +
                                          " " +
                                          TokenList.tokenList[0].name))),
                          child: Text(
                            "Add",
                            style: textStyle(Colors.black, 20, true),
                          ))),
                  //remove button
                  Container(
                    width: (_isWeb) ? 155 : (layoutWdt / 2) - 30,
                    height: 37.5,
                    decoration: boxDecoration(
                        Colors.transparent, 100, 1, Colors.amber[400]!),
                    child: TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              poolRemoveLiquidity(
                                  context, TokenList.tokenList[0].name)),
                      child: Text(
                        "Remove",
                        style: textStyle(Colors.amber[400]!, 18, true),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Delete this
  Widget myLiquidityLayoutGrid(double layoutHgt, double layoutWdt) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: _isWeb
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

  //Delete this
  Widget myLiquidityLayout(double layoutHgt, double layoutWdt) {
    double gridHgt = layoutHgt * 0.75;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            //searchbar for desktop (next to toggle button)
            if (_isWeb) createMyLiquiditySearchBar(layoutHgt, layoutWdt),
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
      margin: EdgeInsets.only(bottom: layoutHgt * 0.01),
      //1 - title width
      width: _isWeb ? 300 : layoutWdt * 0.6,
      //same as title
      height: _isWeb ? 40 : layoutHgt * 0.05,
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
                        .where((token) => (token.ticker + " " + token.name)
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
}
