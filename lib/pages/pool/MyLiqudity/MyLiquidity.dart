import 'package:ax_dapp/pages/pool/MyLiqudity/bloc/MyLiquidityBloc.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/models/MyLiquidityItemInfo.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/service/TokenList.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyLiquidity extends StatefulWidget {
  MyLiquidity({Key? key}) : super(key: key);

  @override
  State<MyLiquidity> createState() => _MyLiquidityState();
}

class _MyLiquidityState extends State<MyLiquidity> {
  bool _isWeb = true;
  double _width = 0;
  double _layoutHgt = 0;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    final double _height = mediaquery.size.height;
    _width = mediaquery.size.width;
    _layoutHgt = _height * 0.8;
    _isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final double _layoutWdt = _isWeb ? _width * 0.8 : _width * 0.9;
    double gridHgt = _layoutHgt * 0.75;

    Widget myLiquidityPoolGridItem(
        LiquidityPositionInfo liquidityPositionInfo, double layoutWdt) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GridTile(
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: boxDecoration(Colors.grey[800]!.withOpacity(0.25), 30,
                1.5, Colors.grey[400]!),
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
                          image: AssetImage(liquidityPositionInfo.token0Symbol),
                        ),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(liquidityPositionInfo.token1Symbol),
                        ),
                      ),
                    ),
                    //title
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (liquidityPositionInfo.token0Symbol) +
                            " - " +
                            (liquidityPositionInfo.token1Symbol),
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
                            (liquidityPositionInfo.lpTokenPairBalance),
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
                            "Pooled " + (liquidityPositionInfo.token0Symbol),
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            (liquidityPositionInfo.token0LpAmount),
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
                            "Pooled " + (liquidityPositionInfo.token1Symbol),
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            (liquidityPositionInfo.token1LpAmount),
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
                            (liquidityPositionInfo.shareOfPool) + "%",
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
                            "APY:",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            (liquidityPositionInfo.apy) + "%",
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

    Widget loading() {
      return Center(
        child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: Colors.amber,
            )),
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
                    setState(() {});
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

    return BlocBuilder<MyLiquidityBloc, MyLiquidityState>(
      buildWhen: ((previous, current) => previous != current),
      builder: (context, state) {
        final bloc = context.read<MyLiquidityBloc>();
        final cards = state.cards;
        if (state.status == BlocStatus.initial) {
            bloc.add(LoadEvent());
        }
        if (state.status == BlocStatus.loading) {
          return loading();
        }
        if (state.status == BlocStatus.no_data || (state.status == BlocStatus.success && state.cards.isEmpty)) {
          return emptyWallet(_layoutWdt, _layoutHgt);
        }
        if (state.status == BlocStatus.no_wallet) {
          return noWallet();
        }
        if (state.status == BlocStatus.error) {
          return loadingError();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                //searchbar for desktop (next to toggle button)
                if (_isWeb) createMyLiquiditySearchBar(gridHgt, _layoutWdt),
              ],
            ),
            Container(
              height: gridHgt,
              child: GridView.builder(
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
                itemCount: cards.length,
                itemBuilder: (BuildContext ctx, index) {
                  return myLiquidityPoolGridItem(cards[index], _layoutWdt);
                },
              ),
            )
          ],
        );
      },
    );
  }
  
  Widget emptyWallet(height, width) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: Text("Connected wallet does not contain any Liquidity Tokens. You can get your positions on Add Liquidity page.",
            style: TextStyle(color: Colors.amber, fontSize: 30)),
      ),
    );
  }
  Widget loadingError() {
    return Center(
      child: SizedBox(
        height: 70,
        width: 400,
        child: Text("Failed to load list of liquidity positions",
            style: TextStyle(color: Colors.red, fontSize: 30)),
      ),
    );
  }
  
  Widget noWallet() {
    return Center(
      child: SizedBox(
        height: 70,
        width: 400,
        child: Text("Please connect your wallet.",
            style: TextStyle(color: Colors.amber, fontSize: 30)),
      ),
    );
  }
}
