// ignore_for_file: avoid_dynamic_calls

import 'package:ax_dapp/my_liquidity/bloc/my_liquidity_bloc.dart';
import 'package:ax_dapp/my_liquidity/models/models.dart';
import 'package:ax_dapp/my_liquidity/view/view.dart';
import 'package:ax_dapp/my_liquidity/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MyLiquidityPage extends StatefulWidget {
  const MyLiquidityPage({super.key, required this.togglePool});

  final Function togglePool;

  @override
  State<MyLiquidityPage> createState() => _MyLiquidityPageState();
}

class _MyLiquidityPageState extends State<MyLiquidityPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isWeb = true;
  double _layoutHgt = 0;
  PoolController poolController = Get.find();
  Controller controller = Get.find();
  LiquidityPositionInfo infoOfSelectedCard = LiquidityPositionInfo.empty();
  AssetImage? token0Icon = const AssetImage('assets/images/apt.png');
  AssetImage? token1Icon = const AssetImage('assets/images/apt.png');

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    _layoutHgt = _height * 0.8;
    _isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _layoutWdt = _isWeb ? _width * 0.8 : _width * 0.9;
    final gridHgt = _layoutHgt * 0.75;

    Widget myLiquidityPoolGridItem(
      LiquidityPositionInfo liquidityPositionInfo,
      double layoutWdt,
    ) {
      final tokensRepository = context.read<TokensRepository>();
      final tokens = tokensRepository.currentTokens;
      final token0 = tokens.byAddress(liquidityPositionInfo.token0Address);
      final token1 = tokens.byAddress(liquidityPositionInfo.token1Address);
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GridTile(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey[400]!, width: 1.5),
            ),
            child: Column(
              children: [
                //Item's title with icons
                MyLiquidityCardTitle(
                  token0: token0,
                  token1: token1,
                  liquidityPositionInfo: liquidityPositionInfo,
                ),
                //Pool token information
                MyLiquidityCardInformation(
                  liquidityPositionInfo: liquidityPositionInfo,
                ),
                //Item's Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // add button
                    SizedBox(
                      width: _isWeb ? 155 : (layoutWdt * 0.4) - 30,
                      height: 37.5,
                      child: TextButton(
                        onPressed: () {
                          widget.togglePool(
                            token0: token0,
                            token1: token1,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber[400]!,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Colors.amber[400]!),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                    //remove button
                    SizedBox(
                      width: _isWeb ? 155 : (layoutWdt * 0.4) - 30,
                      height: 37.5,
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Colors.amber[400]!),
                            ),
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<MyLiquidityBloc>()
                              .add(const FetchAllLiquidityPositionsRequested());
                          setState(() {
                            _tabController.index = 1;
                            token0Icon = tokenImage(token0);
                            token1Icon = tokenImage(token1);
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
                          style: TextStyle(
                            color: Colors.amber[400],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'OpenSans',
                          ),
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

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.isWalletConnected) {
          context
              .read<MyLiquidityBloc>()
              .add(const WatchAppDataChangesStarted());
        }
        if (state.isWalletDisconnected) {
          const NoWallet();
        }
        if (state.isWalletUnavailable) {
          debugPrint('Wallet is unavailable -> ${state.isWalletUnavailable}');
        }
        if (state.isWalletUnsupported) {
          debugPrint('wallet is not supported -> ${state.isWalletUnsupported}');
        }
      },
      child: BlocBuilder<MyLiquidityBloc, MyLiquidityState>(
        builder: (context, state) {
          final filteredCards = state.filteredCards;
          if (state.status == BlocStatus.loading) {
            return const Loader();
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

          final isResultFound =
              state.status == BlocStatus.success && filteredCards.isNotEmpty;

          return SizedBox(
            width: _width * 0.88,
            height: _height * 0.7,
            child: DefaultTabController(
              length: 2,
              child: TabBarView(
                controller: _tabController,
                children: [
                  SizedBox(
                    width: _width * 0.7,
                    height: _height * 0.2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            //searchbar for desktop (next to toggle button)
                            if (_isWeb)
                              Container(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: MyLiquiditySearchBar(
                                  layoutHgt: _layoutHgt,
                                  isWeb: _isWeb,
                                  layoutWdt: _layoutWdt,
                                ),
                              ),
                          ],
                        ),
                        if (!isResultFound)
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 150),
                            height: gridHgt,
                            child: const NoResultFound(),
                          )
                        else
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
                  ),
                  RemoveLiquidityPage(
                    infoOfSelectedCard: infoOfSelectedCard,
                    token0Icon: token0Icon,
                    token1Icon: token1Icon,
                    tabController: _tabController,
                    poolController: poolController,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
