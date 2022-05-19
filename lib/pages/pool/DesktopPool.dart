import 'package:ax_dapp/pages/pool/AddLiquidity/AddLiquidity.dart';
import 'package:ax_dapp/pages/pool/AddLiquidity/bloc/PoolBloc.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/MyLiquidity.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/bloc/MyLiquidityBloc.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPoolInfoUseCase.dart';
import 'package:ax_dapp/repositories/usecases/GetAllLiquidityInfoUseCase.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/usecases/GetWalletAddressUseCase.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DesktopPool extends StatefulWidget {
  const DesktopPool({Key? key}) : super(key: key);

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
    MediaQueryData mediaquery = MediaQuery.of(context);
    double _height = mediaquery.size.height;
    double _width = mediaquery.size.width;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double layoutHgt = _height * 0.8;
    double layoutWdt = isWeb ? _width * 0.8 : _width * 0.9;

    //bloc build return widget
    if (this.token0 != null)
      print("Inside Desktop Pool: ${this.token0!.ticker}");
    if (this.token1 != null)
      print("Inside Desktop Pool: ${this.token1!.ticker}");
    final double toggleWdt = isWeb ? 260 : layoutWdt;

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
          width: layoutWdt,
          height: _height - AppBar().preferredSize.height - 10,
          //Top margin of Pool section is equal to height + 1 of AppBar on mobile only
          margin: EdgeInsets.only(top: AppBar().preferredSize.height + 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Container(
                  width: toggleWdt,
                  height: isWeb ? 40 : layoutHgt * 0.06,
                  margin: EdgeInsets.symmetric(vertical: layoutHgt * 0.01),
                  decoration: boxDecoration(
                      Colors.grey[900]!, 100, 1, Colors.grey[400]!),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          width: isWeb ? 120 : (toggleWdt / 2) - 5,
                          decoration: currentTabIndex == 0
                              ? boxDecoration(
                                  Colors.grey[600]!, 100, 0, Colors.transparent)
                              : boxDecoration(Colors.transparent, 100, 0,
                                  Colors.transparent),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  currentTabIndex = 0;
                                });
                                if (!isAllLiquidity) {
                                  togglePool();
                                }
                              },
                              child: Text("Add Liquidity",
                                  style: textStyle(Colors.white, 16, true)))),
                      Container(
                        width: isWeb ? 120 : (toggleWdt / 2) - 5,
                        decoration: (currentTabIndex == 1)
                            ? boxDecoration(
                                Colors.grey[600]!, 100, 0, Colors.transparent)
                            : boxDecoration(
                                Colors.transparent, 100, 0, Colors.transparent),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              currentTabIndex = 1;
                            });
                          },
                          child: Text(
                            "My Liquidity",
                            style: textStyle(Colors.white, 16, true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                alignment: Alignment.center,
              ),
              IndexedStack(
                index: currentTabIndex,
                children: [
                  Container(
                      height: layoutHgt,
                      child: BlocProvider(
                          create: (BuildContext context) => PoolBloc(
                                repo: GetPoolInfoUseCase(
                                  RepositoryProvider.of<GetPairInfoUseCase>(
                                      context),
                                ),
                                walletController: Get.find(),
                                poolController: Get.find(),
                                token0: this.token0 ?? null,
                                token1: this.token1 ?? null,
                              ),
                          child: (this.token0 != null && this.token1 != null)
                              ? AddLiquidity(
                                  token0: this.token0,
                                  token1: this.token1,
                                )
                              : AddLiquidity())),
                  Container(
                    child: BlocProvider(
                        create: (BuildContext context) => MyLiquidityBloc(
                              repo: RepositoryProvider.of<
                                  GetAllLiquidityInfoUseCase>(context),
                              controller: GetWalletAddressUseCase(Get.find()),
                            ),
                        child: MyLiquidity(
                          togglePool: togglePool,
                        )),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class Farm {
  final String name;
  Athlete? athlete;

  Farm(this.name, [this.athlete]);
}
