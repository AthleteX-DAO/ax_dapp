import 'package:ax_dapp/pages/pool/add_liquidity/add_liquidity.dart';
import 'package:ax_dapp/pages/pool/add_liquidity/bloc/pool_bloc.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/bloc/my_liquidity_bloc.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/my_liquidity.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pair_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/service/athlete.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/service/controller/usecases/get_wallet_address_use_case.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DesktopPool extends StatefulWidget {
  const DesktopPool({super.key});

  @override
  State<StatefulWidget> createState() => _DesktopPoolState();
}

class _DesktopPoolState extends State<DesktopPool> {
  bool isAllLiquidity = true;
  bool isMylLiquidity = true;
  bool isRemoveLiquidity = true;
  bool isWeb = true;
  Token? token0;
  Token? token1;
  int currentTabIndex = 0;

  void togglePool({Token? token0, Token? token1}) {
    setState(() {
      if (token0 != null && token1 != null) {
        this.token0 = token0;
        this.token1 = token1;
      }
      currentTabIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final _height = mediaquery.size.height;
    final _width = mediaquery.size.width;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final layoutHgt = _height * 0.85;
    final layoutWdt = isWeb ? _width * 0.8 : _width * 0.9;

    final toggleWdt = isWeb ? 260.0 : layoutWdt;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: layoutWdt,
        height: _height - AppBar().preferredSize.height - 10,
        // Top margin of Pool section is equal to height + 1 of AppBar on
        // mobile only
        margin: EdgeInsets.only(top: AppBar().preferredSize.height + 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                width: toggleWdt,
                height: isWeb ? 40 : layoutHgt * 0.06,
                margin: EdgeInsets.symmetric(vertical: layoutHgt * 0.01),
                decoration:
                    boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: isWeb ? 120 : (toggleWdt / 2) - 5,
                      decoration: currentTabIndex == 0
                          ? boxDecoration(
                              Colors.grey[600]!,
                              100,
                              0,
                              Colors.transparent,
                            )
                          : boxDecoration(
                              Colors.transparent,
                              100,
                              0,
                              Colors.transparent,
                            ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            currentTabIndex = 0;
                          });
                          if (!isAllLiquidity) {
                            togglePool();
                          }
                        },
                        child: Text(
                          'Add Liquidity',
                          style: textStyle(Colors.white, 16, true),
                        ),
                      ),
                    ),
                    Container(
                      width: isWeb ? 120 : (toggleWdt / 2) - 5,
                      decoration: (currentTabIndex == 1)
                          ? boxDecoration(
                              Colors.grey[600]!,
                              100,
                              0,
                              Colors.transparent,
                            )
                          : boxDecoration(
                              Colors.transparent,
                              100,
                              0,
                              Colors.transparent,
                            ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            currentTabIndex = 1;
                          });
                        },
                        child: Text(
                          'My Liquidity',
                          style: textStyle(Colors.white, 16, true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IndexedStack(
              alignment: AlignmentDirectional.center,
              index: currentTabIndex,
              children: [
                SizedBox(
                  height: layoutHgt,
                  child: BlocProvider(
                    create: (BuildContext context) => PoolBloc(
                      repo: GetPoolInfoUseCase(
                        RepositoryProvider.of<GetPairInfoUseCase>(
                          context,
                        ),
                      ),
                      walletController: Get.find(),
                      poolController: Get.find(),
                    ),
                    child: (token0 != null && token1 != null)
                        ? AddLiquidity(
                            token0: token0,
                            token1: token1,
                          )
                        : AddLiquidity(),
                  ),
                ),
                BlocProvider(
                  create: (BuildContext context) => MyLiquidityBloc(
                    repo: RepositoryProvider.of<GetAllLiquidityInfoUseCase>(
                      context,
                    ),
                    controller: GetWalletAddressUseCase(Get.find()),
                  ),
                  child: MyLiquidity(
                    togglePool: togglePool,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Farm {
  Farm(this.name, [this.athlete]);

  final String name;

  Athlete? athlete;
}
