import 'package:ax_dapp/add_liquidity/add_liquidity.dart';
import 'package:ax_dapp/my_liquidity/my_liquidity.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class DesktopPool extends StatefulWidget {
  const DesktopPool({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DesktopPoolState();
}

class _DesktopPoolState extends State<DesktopPool> {
  Global global = Global();
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
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    var layoutHeight = _height * 0.85;
    if (_width < 600) layoutHeight = _height * 0.75;
    if (_width >= 600 && _width < 1024) layoutHeight = _height * 0.8;
    final layoutWidth = isWeb ? _width * 0.8 : _width * 0.9;
    final toggleWidth = isWeb ? 260.0 : layoutWidth;

    return global.buildPage(
      context,
      SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: layoutWidth,
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
                  width: toggleWidth,
                  height: isWeb ? 40 : layoutHeight * 0.06,
                  margin: EdgeInsets.symmetric(vertical: layoutHeight * 0.01),
                  decoration: boxDecoration(
                    Colors.grey[900]!,
                    100,
                    1,
                    Colors.grey[400]!,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: isWeb ? 120 : (toggleWidth / 2) - 5,
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
                          },
                          child: FittedBox(
                            child: SizedBox(
                              child: Text(
                                'Add Liquidity',
                                style: textStyle(
                                  Colors.white,
                                  16,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: isWeb ? 120 : (toggleWidth / 2) - 5,
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
                          child: FittedBox(
                            child: SizedBox(
                              child: Text(
                                'My Liquidity',
                                style: textStyle(
                                  Colors.white,
                                  16,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                            ),
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
                    height: layoutHeight,
                    child: BlocProvider(
                      create: (BuildContext context) => AddLiquidityBloc(
                        walletRepository: context.read<WalletRepository>(),
                        tokensRepository: context.read<TokensRepository>(),
                        streamAppDataChanges:
                            context.read<StreamAppDataChangesUseCase>(),
                        repo:
                            RepositoryProvider.of<GetPoolInfoUseCase>(context),
                        getAllLiquidityInfoUseCase: RepositoryProvider.of<GetAllLiquidityInfoUseCase>(context),
                        poolController: Get.find(),
                      ),
                      child: AddLiquidityPage(
                        token0: token0,
                        token1: token1,
                      ),
                    ),
                  ),
                  BlocProvider(
                    create: (_) => MyLiquidityBloc(
                      walletRepository: context.read<WalletRepository>(),
                      streamAppDataChanges:
                          context.read<StreamAppDataChangesUseCase>(),
                      repo: RepositoryProvider.of<GetAllLiquidityInfoUseCase>(
                        context,
                      ),
                    ),
                    child: MyLiquidityPage(
                      togglePool: togglePool,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
