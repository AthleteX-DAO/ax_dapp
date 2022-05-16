import 'package:ax_dapp/pages/pool/AddLiquidity/AddLiquidity.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/MyLiquidity.dart';
import 'package:ax_dapp/pages/pool/bloc/PoolBloc.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPoolInfoUseCase.dart';
import 'package:ax_dapp/service/Athlete.dart';
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
  bool isWeb = true;

  @override
  void initState() {
    super.initState();
  }

  onTokenAmountChange() {
    // //if from amount changed, autocomplete to amount
    // if (_tokenAmountOneFocusNode.hasFocus) {
    //   final tokenOne = double.tryParse(_tokenAmountOneController.text);
    //
    //   if (tokenOne != null) {
    //     //Update amount 1
    //     token1Amount = double.parse(_tokenAmountOneController.text);
    //     poolController.updateTopAmount(token1Amount);
    //   }
    // }
    // //if to amount changed, autocomplete from amount
    // if (_tokenAmountTwoFocusNode.hasFocus) {
    //   final tokenTwo = double.tryParse(_tokenAmountTwoController.text);
    //
    //   if (tokenTwo != null) {
    //     //Autocomplete and update amount 1
    //     //Update amount 2
    //     token2Amount = double.parse(_tokenAmountTwoController.text);
    //     poolController.updateBottomAmount(token2Amount);
    //   }
    // }
  }

  @override
  void dispose() {
    super.dispose();
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

    Widget togglePoolButton(double layoutHgt, double layoutWdt) {
      double toggleWdt = isWeb ? 260 : layoutWdt;
      return Container(
        width: toggleWdt,
        height: isWeb ? 40 : layoutHgt * 0.06,
        margin: EdgeInsets.symmetric(vertical: layoutHgt * 0.01),
        decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                width: isWeb ? 120 : (toggleWdt / 2) - 5,
                decoration: isAllLiquidity
                    ? boxDecoration(
                        Colors.grey[600]!, 100, 0, Colors.transparent)
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
                child: Text(
                  "My Liquidity",
                  style: textStyle(Colors.white, 16, true),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget addLiquidityTitle() {
      //Liquidity Pool Title
      return Container(
        height: isWeb ? 45 : layoutHgt * 0.05,
        alignment: Alignment.bottomLeft,
        child: Text("Liquidity Pool", style: textStyle(Colors.white, 24, true)),
      );
    }

    Widget myLiquidityTitle() {
      return Row(
        //My Liquidity title
        children: [
          Container(
            height: isWeb ? 45 : layoutHgt * 0.05,
            width: layoutWdt * 0.4,
            alignment: Alignment.bottomLeft,
            child:
                Text("My Liquidity", style: textStyle(Colors.white, 24, true)),
          ),
        ],
      );
    }

    //bloc build return widget
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
          width: layoutWdt,
          height: _height - AppBar().preferredSize.height - 10,
          //Top margin of Pool section is equal to height + 1 of AppBar on mobile only
          margin: EdgeInsets.only(top: AppBar().preferredSize.height + 10),
          child: Column(
            children: [
              isAllLiquidity ? addLiquidityTitle() : myLiquidityTitle(),
              Container(
                child: togglePoolButton(layoutHgt, layoutWdt),
                alignment: Alignment.centerLeft,
              ),
              Container(
                height: layoutHgt,
                child: (isAllLiquidity)
                    ? BlocProvider(
                        create: (BuildContext context) => PoolBloc(
                            repo: GetPoolInfoUseCase(
                              RepositoryProvider.of<GetPairInfoUseCase>(context),
                            ),
                            walletController: Get.find(),
                            poolController: Get.find()),
                        child: AddLiquidity())
                    : MyLiquidity(),
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
