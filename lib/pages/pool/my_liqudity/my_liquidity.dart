// ignore_for_file: avoid_dynamic_calls

import 'package:ax_dapp/pages/pool/my_liqudity/add_liquidity_token_pair.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/bloc/my_liquidity_bloc.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/components/pool_remove_approve_button.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/format_wallet_address.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MyLiquidity extends StatefulWidget {
  const MyLiquidity({super.key, required this.togglePool});

  final Function togglePool;

  @override
  State<MyLiquidity> createState() => _MyLiquidityState();
}

class BadgeToken extends StatelessWidget {
  const BadgeToken({
    super.key,
    required this.sport,
    required this.symbol,
  });

  final SupportedSport sport;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Badge(
      shape: BadgeShape.square,
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(
        sport.name.toUpperCase(),
        style: textStyle(Colors.white, 12, true),
      ),
      position: BadgePosition.topEnd(top: -14, end: -14),
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
      child: Text(
        symbol,
        style: textStyle(Colors.white, 24, true),
      ),
    );
  }
}

class SimpleToken extends StatelessWidget {
  const SimpleToken({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        symbol,
        style: textStyle(Colors.white, 24, true),
      ),
    );
  }
}

class SportToken extends StatelessWidget {
  const SportToken({
    super.key,
    required this.sport,
    required this.symbol,
  });

  final SupportedSport sport;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    if (sport == SupportedSport.all) return SimpleToken(symbol: symbol);
    return BadgeToken(sport: sport, symbol: symbol);
  }
}

class _MyLiquidityState extends State<MyLiquidity> {
  bool _isWeb = true;
  double _width = 0;
  double _layoutHgt = 0;
  int currentTabIndex = 0;
  PoolController poolController = Get.find();
  Controller controller = Get.find();
  double value = 0;
  LiquidityPositionInfo infoOfSelectedCard = LiquidityPositionInfo.empty();
  AssetImage? token0Icon = const AssetImage('assets/images/apt.png');
  AssetImage? token1Icon = const AssetImage('assets/images/apt.png');

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final _height = mediaquery.size.height;
    _width = mediaquery.size.width;
    _layoutHgt = _height * 0.8;
    _isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _layoutWdt = _isWeb ? _width * 0.8 : _width * 0.9;
    final gridHgt = _layoutHgt * 0.75;
    final userWalletAddress = FormatWalletAddress.getWalletAddress(
        controller.publicAddress.toString(),);
    final tokenOneRemoveAmount =
        double.parse(infoOfSelectedCard.token0LpAmount) * (value / 100);
    final tokenTwoRemoveAmount =
        double.parse(infoOfSelectedCard.token1LpAmount) * (value / 100);
        
    Widget myLiquidityPoolGridItem(
      LiquidityPositionInfo liquidityPositionInfo,
      double layoutWdt,
    ) {
      final tokenPair = AddLiquidityTokenPair.fromTokenPairAddresses(
        liquidityPositionInfo.token0Address,
        liquidityPositionInfo.token1Address,
      );
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GridTile(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: boxDecoration(
              Colors.grey[800]!.withOpacity(0.25),
              30,
              1.5,
              Colors.grey[400]!,
            ),
            child: Column(
              children: [
                //Item's title with icons
                Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          scale: 0.5,
                          image: tokenPair.token0.icon!,
                        ),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          scale: 0.5,
                          image: tokenPair.token1.icon!,
                        ),
                      ),
                    ),
                    SportToken(
                      sport: tokenPair.token0.sport,
                      symbol: liquidityPositionInfo.token0Symbol,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(' - '),
                    ),
                    SportToken(
                      sport: tokenPair.token1.sport,
                      symbol: liquidityPositionInfo.token1Symbol,
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
                        children: [
                          Text(
                            'Your Pool Tokens:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            liquidityPositionInfo.lpTokenPairBalance,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pooled ${liquidityPositionInfo.token0Symbol}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            liquidityPositionInfo.token0LpAmount,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pooled ${liquidityPositionInfo.token1Symbol}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            liquidityPositionInfo.token1LpAmount,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Pool Share:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${liquidityPositionInfo.shareOfPool}%',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'APY:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${liquidityPositionInfo.apy}%',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Item's Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // add button
                    Container(
                      width: _isWeb ? 155 : (layoutWdt / 2) - 30,
                      height: 37.5,
                      decoration: boxDecoration(
                        Colors.amber[400]!,
                        100,
                        0,
                        Colors.amber[400]!,
                      ),
                      child: TextButton(
                        onPressed: () {
                          final tokenPair =
                              AddLiquidityTokenPair.fromTokenPairAddresses(
                            liquidityPositionInfo.token0Address,
                            liquidityPositionInfo.token1Address,
                          );
                          widget.togglePool(
                            token0: tokenPair.token0,
                            token1: tokenPair.token1,
                          );
                        },
                        child: Text(
                          'Add',
                          style: textStyle(Colors.black, 20, true),
                        ),
                      ),
                    ),
                    //remove button
                    Container(
                      width: _isWeb ? 155 : (layoutWdt / 2) - 30,
                      height: 37.5,
                      decoration: boxDecoration(
                        Colors.transparent,
                        100,
                        1,
                        Colors.amber[400]!,
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            currentTabIndex = 1;
                            token0Icon = tokenPair.token0.icon;
                            token1Icon = tokenPair.token1.icon;
                            infoOfSelectedCard = liquidityPositionInfo;
                            poolController
                              ..lpTokenAAddress =
                                  liquidityPositionInfo.token0Address
                              ..lpTokenBAddress =
                                  liquidityPositionInfo.token1Address
                              ..lpTokenPairAddress =
                                  liquidityPositionInfo.lpTokenPairAddress;
                          });
                        },
                        child: Text(
                          'Remove',
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
      return const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        ),
      );
    }

    Widget createMyLiquiditySearchBar(
      double layoutHgt,
      double layoutWdt,
      MyLiquidityBloc bloc,
    ) {
      return Container(
        margin: EdgeInsets.only(bottom: layoutHgt * 0.01),
        //1 - title width
        width: _isWeb ? 300 : layoutWdt * 0.6,
        //same as title
        height: _isWeb ? 40 : layoutHgt * 0.05,
        decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
        child: Row(
          children: [
            Container(width: 8),
            const Icon(Icons.search, color: Colors.white),
            Container(width: 10),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  bloc.add(SearchBarInputEvent(searchBarInput: value));
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8.5),
                  hintText: 'Search a farm',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<MyLiquidityBloc, MyLiquidityState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final bloc = context.read<MyLiquidityBloc>();
        final filteredCards = state.filteredCards;
        if (state.status == BlocStatus.initial) {
          bloc.add(LoadEvent());
        }
        if (state.status == BlocStatus.loading) {
          return loading();
        }
        if (state.status == BlocStatus.noData ||
            (state.status == BlocStatus.success && state.cards.isEmpty)) {
          return EmptyWallet(
            width: _layoutWdt,
            height: _layoutHgt,
          );
        }
        if (state.status == BlocStatus.noWallet) {
          return const NoWallet();
        }
        if (state.status == BlocStatus.error) {
          return const LoadingError();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IndexedStack(
              index: currentTabIndex,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        //searchbar for desktop (next to toggle button)
                        if (_isWeb)
                          createMyLiquiditySearchBar(gridHgt, _layoutWdt, bloc),
                      ],
                    ),
                    SizedBox(
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
                            : const SliverGridDelegateWithFixedCrossAxisCount(
                                //delegate count of 1 for mobile
                                crossAxisCount: 1,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 265,
                              ),
                        itemCount: filteredCards.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return myLiquidityPoolGridItem(
                            filteredCards[index],
                            _layoutWdt,
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _width * 0.5,
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 30,
                      ),
                      decoration: boxDecoration(
                        Colors.grey[900]!,
                        30,
                        0,
                        Colors.black,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Remove Liquidity',
                                  style: textStyle(Colors.white, 20, false),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text('Amount'),
                                Row(
                                  children: [
                                    Text(
                                      '$value%',
                                      style: textStyle(Colors.white, 36, true),
                                    ),
                                    const Spacer(),
                                    DecoratedBox(
                                      decoration: boxDecoration(
                                        Colors.grey[600]!,
                                        4,
                                        0.5,
                                        Colors.grey[600]!,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            value = 25;
                                            poolController.removePercentage =
                                                value;
                                          });
                                        },
                                        child: Text(
                                          '25%',
                                          style: textStyle(
                                            Colors.white,
                                            12,
                                            true,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: boxDecoration(
                                        Colors.grey[600]!,
                                        4,
                                        0.5,
                                        Colors.grey[600]!,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            value = 50;
                                            poolController.removePercentage =
                                                value;
                                          });
                                        },
                                        child: Text(
                                          '50%',
                                          style: textStyle(
                                            Colors.white,
                                            12,
                                            true,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: boxDecoration(
                                        Colors.grey[600]!,
                                        4,
                                        0.5,
                                        Colors.grey[600]!,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            value = 75;
                                            poolController.removePercentage =
                                                value;
                                          });
                                        },
                                        child: Text(
                                          '75%',
                                          style: textStyle(
                                            Colors.white,
                                            12,
                                            true,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: boxDecoration(
                                        Colors.grey[600]!,
                                        4,
                                        0.5,
                                        Colors.grey[600]!,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            value = 100;
                                            poolController.removePercentage =
                                                value;
                                          });
                                        },
                                        child: Text(
                                          '100%',
                                          style: textStyle(
                                            Colors.white,
                                            12,
                                            true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  thumbColor: Colors.amber.withOpacity(0.88),
                                  inactiveColor: Colors.amber.withOpacity(0.5),
                                  activeColor: Colors.amber,
                                  value: value,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      value = newValue.roundToDouble();
                                      poolController.removePercentage = value;
                                    });
                                  },
                                  max: 100,
                                  divisions: 100,
                                  label: '$value',
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Your position:',
                                style: textStyle(
                                  Colors.grey[600]!,
                                  16,
                                  false,
                                ),
                              ),
                            ),
                            // ax per apt & share of pool
                            SizedBox(
                              height: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${infoOfSelectedCard.token0Symbol}/${infoOfSelectedCard.token1Symbol}'
                                        ' LP Tokens:',
                                        style: textStyle(
                                          Colors.white,
                                          16,
                                          false,
                                        ),
                                      ),
                                      Text(
                                        infoOfSelectedCard.lpTokenPairBalance,
                                        style: textStyle(
                                          Colors.white,
                                          16,
                                          false,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Share of pool:',
                                        style: textStyle(
                                          Colors.grey[600]!,
                                          16,
                                          false,
                                        ),
                                      ),
                                      Text(
                                        '${infoOfSelectedCard.shareOfPool}%',
                                        style: textStyle(
                                          Colors.white,
                                          16,
                                          false,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '''${infoOfSelectedCard.token0Symbol} deposited:''',
                                        style: textStyle(
                                          Colors.grey[600]!,
                                          16,
                                          false,
                                        ),
                                      ),
                                      Text(
                                        infoOfSelectedCard.token0LpAmount,
                                        style: textStyle(
                                          Colors.white,
                                          16,
                                          false,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '''${infoOfSelectedCard.token1Symbol} deposited:''',
                                        style: textStyle(
                                          Colors.grey[600]!,
                                          16,
                                          false,
                                        ),
                                      ),
                                      Text(
                                        infoOfSelectedCard.token1LpAmount,
                                        style: textStyle(
                                          Colors.white,
                                          16,
                                          false,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(thickness: 1, color: Colors.grey[600]),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Remove:',
                                style: textStyle(
                                  Colors.grey[600]!,
                                  16,
                                  false,
                                ),
                              ),
                            ),
                            Container(
                              width: _width,
                              height: _height * 0.1,
                              decoration: boxDecoration(
                                Colors.transparent,
                                15,
                                0.5,
                                Colors.grey[600]!,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: _width - 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 30),
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              scale: 0.25,
                                              image: token0Icon!,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          infoOfSelectedCard.token0Symbol,
                                          style: textStyle(
                                            Colors.white,
                                            16,
                                            false,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 30),
                                          width: _width * .20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  tokenOneRemoveAmount
                                                      .toStringAsFixed(6),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width - 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 30),
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              scale: 0.25,
                                              image: token1Icon!,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          infoOfSelectedCard.token1Symbol,
                                          style: textStyle(
                                            Colors.white,
                                            16,
                                            false,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 30),
                                          width: _width * .20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  tokenTwoRemoveAmount
                                                      .toStringAsFixed(6),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: _height * 0.03),
                            Row(
                              children: [
                                PoolRemoveApproveButton(
                                  width: 175,
                                  height: 40,
                                  text: 'Approve',
                                  approveCallback: poolController.approveRemove,
                                  confirmCallback:
                                      poolController.removeLiquidity,
                                  confirmDialog: removalConfirmed,
                                  currencyOne: infoOfSelectedCard.token0Symbol,
                                  currencyTwo: infoOfSelectedCard.token1Symbol,
                                  valueOne: tokenOneRemoveAmount,
                                  valueTwo: tokenTwoRemoveAmount,
                                  lpTokens:
                                      infoOfSelectedCard.lpTokenPairBalance,
                                  shareOfPool: infoOfSelectedCard.shareOfPool,
                                  percentRemoval: value,
                                  walletId: userWalletAddress.walletAddress,
                                ),
                                const Spacer(),
                                Container(
                                  width: 175,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.amber),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        currentTabIndex = 0;
                                        value = 0;
                                        poolController.removePercentage = value;
                                      });
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class EmptyWallet extends StatelessWidget {
  const EmptyWallet({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: const Text(
          '''Connected wallet does not contain any Liquidity Tokens. You can get your positions on Add Liquidity page.''',
          style: TextStyle(color: Colors.amber, fontSize: 30),
        ),
      ),
    );
  }
}

class NoWallet extends StatelessWidget {
  const NoWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 70,
        width: 400,
        child: Text(
          'Please connect your wallet.',
          style: TextStyle(color: Colors.amber, fontSize: 30),
        ),
      ),
    );
  }
}

class LoadingError extends StatelessWidget {
  const LoadingError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 70,
        width: 400,
        child: Text(
          'Failed to load list of liquidity positions',
          style: TextStyle(color: Colors.red, fontSize: 30),
        ),
      ),
    );
  }
}
