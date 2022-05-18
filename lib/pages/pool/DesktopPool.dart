import 'package:ax_dapp/pages/pool/AddLiquidity/AddLiquidity.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/MyLiquidity.dart';
import 'package:ax_dapp/pages/pool/bloc/PoolBloc.dart';
import 'package:ax_dapp/repositories/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/Controller/Pool/PoolController.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../repositories/SubGraphRepo.dart';

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

  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    double _height = mediaquery.size.height;
    double _width = mediaquery.size.width;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double layoutHgt = _height * 0.8;
    double layoutWdt = isWeb ? _width * 0.8 : _width * 0.9;

    final double toggleWdt = isWeb ? 260 : layoutWdt;

    //bloc build return widget
    String name = "athleteName";
    var wid = _width;
    PoolController poolController = Get.find();
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
                width: toggleWdt,
                height: isWeb ? 40 : layoutHgt * 0.06,
                margin: EdgeInsets.symmetric(vertical: layoutHgt * 0.01),
                decoration:
                    boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        width: isWeb ? 120 : (toggleWdt / 2) - 5,
                        decoration: currentTabIndex == 0
                            ? boxDecoration(
                                Colors.grey[600]!, 100, 0, Colors.transparent)
                            : boxDecoration(
                                Colors.transparent, 100, 0, Colors.transparent),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentTabIndex = 0;
                              });
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
              IndexedStack(
                index: currentTabIndex,
                children: [
                  Container(
                    height: layoutHgt,
                    child: Container(
                      child: BlocProvider(
                          create: (BuildContext context) => PoolBloc(
                              repo: GetPairInfoUseCase(
                                RepositoryProvider.of<SubGraphRepo>(context),
                              ),
                              walletController: Get.find(),
                              poolController: Get.find()),
                          child: AddLiquidity()),
                    ),
                  ),
                  Container(child: MyLiquidity()),
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
