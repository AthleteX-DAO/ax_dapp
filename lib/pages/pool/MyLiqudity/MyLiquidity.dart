import 'package:ax_dapp/pages/pool/MyLiqudity/AddLiquidityTokenPair.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/bloc/MyLiquidityBloc.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/models/MyLiquidityItemInfo.dart';
import 'package:ax_dapp/service/ApproveButton.dart';
import 'package:ax_dapp/service/Controller/Pool/PoolController.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MyLiquidity extends StatefulWidget {
  final Function togglePool;

  MyLiquidity({Key? key, required this.togglePool}) : super(key: key);

  @override
  State<MyLiquidity> createState() => _MyLiquidityState();
}

class _MyLiquidityState extends State<MyLiquidity> {
  bool _isWeb = true;
  double _width = 0;
  double _layoutHgt = 0;
  int currentTabIndex = 0;
  PoolController poolController = Get.find();
  double value = 0;

  double originalTokenAmount = 1124.4752;
  double tokenAmount = 1124.4752;

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
                            onPressed: () {
                              AddLiquidityTokenPair tokenPair =
                                  AddLiquidityTokenPair.fromTokenPairAddresses(
                                      liquidityPositionInfo.token0Address,
                                      liquidityPositionInfo.token1Address);
                              print("Calling togglePool from MyLiquidity:");
                              widget.togglePool(
                                  token0: tokenPair.token0,
                                  token1: tokenPair.token1);
                            },
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
                        onPressed: () {
                          setState(() {
                            currentTabIndex = 1;
                          });
                        },
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
        if (state.status == BlocStatus.no_data ||
            (state.status == BlocStatus.success && state.cards.isEmpty)) {
          return emptyWallet(_layoutWdt, _layoutHgt);
        }
        if (state.status == BlocStatus.no_wallet) {
          return noWallet();
        }
        if (state.status == BlocStatus.error) {
          return loadingError();
        }
        String athleteName = "athleteName";

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IndexedStack(
              index: currentTabIndex,
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //searchbar for desktop (next to toggle button)
                        if (_isWeb)
                          createMyLiquiditySearchBar(gridHgt, _layoutWdt),
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
                          return myLiquidityPoolGridItem(
                              cards[index], _layoutWdt);
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: _layoutWdt * 0.42,
                        width: _width * 0.5,
                        padding:
                            EdgeInsets.symmetric(vertical: 22, horizontal: 30),
                        decoration: boxDecoration(
                            Colors.grey[900]!, 30, 0, Colors.black),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Remove Liquidity",
                                        style:
                                            textStyle(Colors.white, 20, false),
                                      ),
                                    ]),
                                Column(
                                  children: [
                                    Text("Amount"),
                                    Row(
                                      children: [
                                        Container(
                                            child: Text(
                                          "$value%",
                                          style:
                                              textStyle(Colors.white, 36, true),
                                        )),
                                        Spacer(),
                                        Container(
                                          decoration: boxDecoration(
                                              Colors.grey[600]!,
                                              4,
                                              0.5,
                                              Colors.grey[600]!),
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  value = 25;
                                                  tokenAmount =
                                                      originalTokenAmount * .25;
                                                });
                                              },
                                              child: Text(
                                                "25%",
                                                style: textStyle(
                                                    Colors.white, 12, true),
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          decoration: boxDecoration(
                                              Colors.grey[600]!,
                                              4,
                                              0.5,
                                              Colors.grey[600]!),
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  value = 50;
                                                  tokenAmount =
                                                      originalTokenAmount * .50;
                                                });
                                              },
                                              child: Text(
                                                "50%",
                                                style: textStyle(
                                                    Colors.white, 12, true),
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          decoration: boxDecoration(
                                              Colors.grey[600]!,
                                              4,
                                              0.5,
                                              Colors.grey[600]!),
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  value = 75;
                                                  tokenAmount =
                                                      originalTokenAmount * .75;
                                                });
                                              },
                                              child: Text(
                                                "75%",
                                                style: textStyle(
                                                    Colors.white, 12, true),
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          decoration: boxDecoration(
                                              Colors.grey[600]!,
                                              4,
                                              0.5,
                                              Colors.grey[600]!),
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  value = 100;
                                                  tokenAmount =
                                                      (originalTokenAmount *
                                                          1.0);
                                                });
                                              },
                                              child: Text(
                                                "100%",
                                                style: textStyle(
                                                    Colors.white, 12, true),
                                              )),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      thumbColor:
                                          Colors.amber.withOpacity(0.88),
                                      inactiveColor:
                                          Colors.amber.withOpacity(0.5),
                                      activeColor: Colors.amber,
                                      value: value,
                                      onChanged: (double newValue) {
                                        setState(() {
                                          value = newValue.roundToDouble();
                                          var amountPercent = value / 100;
                                          tokenAmount = (originalTokenAmount *
                                              amountPercent);
                                        });
                                      },
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                      label: "$value",
                                    ),
                                  ],
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Your position:",
                                      style: textStyle(
                                          Colors.grey[600]!, 16, false),
                                    )),
                                // ax per apt & share of pool
                                Container(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "AX/" +
                                                  athleteName +
                                                  " LP Tokens:",
                                              style: textStyle(
                                                  Colors.white, 16, false),
                                            ),
                                            Text("20.24",
                                                style: textStyle(
                                                    Colors.white, 16, false))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Share of pool:",
                                              style: textStyle(
                                                  Colors.grey[600]!, 16, false),
                                            ),
                                            Text("0.12%",
                                                style: textStyle(
                                                    Colors.white, 16, false))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "AX deposited:",
                                              style: textStyle(
                                                  Colors.grey[600]!, 16, false),
                                            ),
                                            Text("1,000",
                                                style: textStyle(
                                                    Colors.white, 16, false))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              athleteName + " deposited:",
                                              style: textStyle(
                                                  Colors.grey[600]!, 16, false),
                                            ),
                                            Text("500",
                                                style: textStyle(
                                                    Colors.white, 16, false))
                                          ],
                                        )
                                      ],
                                    )),
                                Divider(thickness: 1, color: Colors.grey[600]),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Remove:",
                                      style: textStyle(
                                          Colors.grey[600]!, 16, false),
                                    )),
                                Container(
                                    width: _width,
                                    decoration: boxDecoration(
                                        Colors.transparent,
                                        5,
                                        0.5,
                                        Colors.grey[600]!),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: _width - 50,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                // LP Tokens
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "LP Token",
                                                          style: textStyle(
                                                              Colors.white,
                                                              16,
                                                              false),
                                                        )
                                                      ],
                                                    )),
                                                Spacer(),
                                                Container(
                                                  width: _width * .20,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          "$tokenAmount",
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                        Container(
                                            width: _width - 50,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                // LP Tokens
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "LP Token",
                                                          style: textStyle(
                                                              Colors.white,
                                                              16,
                                                              false),
                                                        )
                                                      ],
                                                    )),
                                                Spacer(),
                                                Container(
                                                  width: _width * .20,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          "$tokenAmount",
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    )),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "You will receive:",
                                    style:
                                        textStyle(Colors.grey[600]!, 16, false),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "AX per " + athleteName,
                                            style: textStyle(
                                                Colors.grey[600]!, 16, false),
                                          ),
                                          Text(
                                            "1,000",
                                            style: textStyle(
                                                Colors.white, 16, false),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            athleteName + " per AX",
                                            style: textStyle(
                                                Colors.grey[600]!, 16, false),
                                          ),
                                          Text(
                                            "500",
                                            style: textStyle(
                                                Colors.white, 16, false),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    ApproveButton(
                                        175,
                                        40,
                                        "Approve",
                                        poolController.approve,
                                        poolController.removeLiquidity,
                                        removalConfirmed),
                                    Spacer(),
                                    Container(
                                      // margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                                      width: 175,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.amber),
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            currentTabIndex = 0;
                                          });
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        )),
                  ],
                ),
              ],
            ),
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
        child: Text(
            "Connected wallet does not contain any Liquidity Tokens. You can get your positions on Add Liquidity page.",
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
