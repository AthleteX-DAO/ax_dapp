import 'package:ax_dapp/pages/farm/components/NoData.dart';
import 'package:ax_dapp/pages/farm/components/NoWallet.dart';
import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/pages/farm/bloc/FarmBloc.dart';
import 'package:ax_dapp/pages/farm/bloc/FarmEvent.dart';
import 'package:ax_dapp/pages/farm/bloc/FarmState.dart';
import 'package:ax_dapp/pages/farm/components/Loading.dart';
import 'package:ax_dapp/pages/farm/components/FarmItem.dart';
import 'package:ax_dapp/pages/farm/components/MyFarmItem.dart';
import 'package:ax_dapp/pages/farm/usecases/GetFarmDataUseCase.dart';
import 'package:ax_dapp/pages/farm/modules/PageTextStyle.dart';
import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';
import 'package:ax_dapp/service/Controller/usecases/GetWalletAddressUseCase.dart';

class DesktopFarm extends StatefulWidget {
  const DesktopFarm({Key? key}) : super(key: key);

  @override
  _DesktopFarmState createState() => _DesktopFarmState();
}

class _DesktopFarmState extends State<DesktopFarm> {
  final myController = TextEditingController();
  bool isWeb = true;
  bool isAllFarms = true;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double layoutHgt = _height * 0.8;
    double layoutWdt = _width * 0.95;
    if (_height < 445) layoutHgt = _height;
    return Container(
      width: _width,
      height: _height - AppBar().preferredSize.height,
      margin: isWeb
          ? EdgeInsets.zero
          : EdgeInsets.only(top: AppBar().preferredSize.height + 10),
      alignment: Alignment.center,
      child: Container(
          //outermost dimensions for farm section
          width: layoutWdt,
          height: layoutHgt,
          // child:  FarmLayout(layoutHgt, layoutWdt),
          child: BlocProvider(
              create: (BuildContext context) => FarmBloc(
                  repo: GetFarmDataUseCase(),
                  controller: GetWalletAddressUseCase(Get.find())),
              child: farmLayout(layoutHgt, layoutWdt))),
    );
  }

  Widget farmLayout(double layoutHgt, double layoutWdt) {
    //Contains Participating farms, search bar, toggle buttons and cards for all farms
    double listHeight = (isWeb && isAllFarms) ? 225 : layoutHgt * 0.80;
    //If web and in MyFarms list height 500
    if (isWeb && !isAllFarms) listHeight = 500;
    return BlocBuilder<FarmBloc, FarmState>(
        buildWhen: (((previous, current) => previous != current)),
        builder: (context, state) {
          final bloc = context.read<FarmBloc>();
          Widget widget = loading();
          if (state.status == BlocStatus.initial) {
            print("[initial] ${state.status}");
            if (state.isAllFarms)
              bloc.add(OnLoadFarms());
            else
              bloc.add(OnLoadStakedFarms());
          }

          if (state.status == BlocStatus.error || state.status == BlocStatus.no_data) {
            widget = noData();
          }
          if (!state.isAllFarms && state.status == BlocStatus.no_wallet) {
            widget = noWallet();
          }
          Widget toggle = toggleFarmButton(bloc, layoutWdt, layoutHgt);
          return Wrap(
            runSpacing: layoutHgt * 0.02,
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
            Row(
              mainAxisAlignment: isWeb
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: isWeb ? 300 : layoutWdt / 2,
                  height: isWeb ? 45 : layoutHgt * 0.05,
                  child: Text(
                    isAllFarms ? "Participating Farms" : "My Farms",
                    style: textStyle(Colors.white, 24, true, false),
                  ),
                ),
                if (!isWeb) createSearchBar(bloc, layoutWdt, layoutHgt),
              ],
            ),
            if (isWeb)
              Row(
                children: <Widget>[
                  createSearchBar(bloc, layoutWdt, layoutHgt),
                  SizedBox(width: 50),
                  toggle
                ],
              ),
            if (!isWeb) toggle,
            Container(
              //contains list of allfarms cards
              width: layoutWdt,
              height: layoutHgt,
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                    },
                  ),
                  child: state.status != BlocStatus.success
                      ? widget
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWeb ? 4 : 1,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: state.isAllFarms ? 1.75 : 1,
                          ),
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemCount: isAllFarms
                              ? state.filteredFarms.length
                              : state.filteredStakedFarms.length,
                          itemBuilder: (context, index) {
                            return isAllFarms
                                ? farmItem(
                                    context,
                                    isWeb,
                                    FarmController(state.filteredFarms[index]),
                                    listHeight,
                                    layoutWdt)
                                : myFarmItem(
                                    context,
                                    isWeb,
                                    FarmController(
                                        state.filteredStakedFarms[index]),
                                    listHeight,
                                    layoutWdt);
                          },
                        )),
            ),
          ]);
        });
  }

  Container toggleFarmButton(
      FarmBloc bloc, double layoutWdt, double layoutHgt) {
    return Container(
      width: isWeb ? 200 : layoutWdt,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: isWeb ? 90 : (layoutWdt / 2) - 5,
              decoration: isAllFarms
                  ? boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent)
                  : boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent),
              child: TextButton(
                  onPressed: () {
                    if (!isAllFarms) {
                      myController.clear();
                      setState(() {
                        isAllFarms = true;
                        bloc.add(OnChangeFarmTab(isAllFarms: true));
                      });
                    }
                  },
                  child: Text("All Farms",
                      style: textStyle(Colors.white, 16, true, false)))),
          Container(
              width: isWeb ? 90 : (layoutWdt / 2) - 5,
              decoration: isAllFarms
                  ? boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent)
                  : boxDecoration(
                      Colors.grey[600]!, 100, 0, Colors.transparent),
              child: TextButton(
                  onPressed: () {
                    if (isAllFarms) {
                      myController.clear();
                      setState(() {
                        isAllFarms = false;
                        bloc.add(OnChangeFarmTab(isAllFarms: false));
                      });
                    }
                  },
                  child: Text("My Farms",
                      style: textStyle(Colors.white, 16, true, false))))
        ],
      ),
    );
  }

  Widget createSearchBar(FarmBloc bloc, double layoutWdt, double layoutHgt) {
    return Container(
      width: isWeb ? 250 : layoutWdt / 2,
      height: isWeb ? 40 : layoutHgt * 0.05,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(width: 8),
          Container(
            child: Icon(Icons.search, color: Colors.white),
          ),
          Container(width: 50),
          Expanded(
            child: Container(
              child: TextFormField(
                controller: myController,
                onChanged: (value) {
                  bloc.add(OnSearchFarms(searchedName: value));
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