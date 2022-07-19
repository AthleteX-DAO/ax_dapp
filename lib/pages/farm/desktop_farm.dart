import 'package:ax_dapp/pages/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/pages/farm/components/farm_item.dart';
import 'package:ax_dapp/pages/farm/components/loading.dart';
import 'package:ax_dapp/pages/farm/components/my_farm_item.dart';
import 'package:ax_dapp/pages/farm/components/no_data.dart';
import 'package:ax_dapp/pages/farm/components/no_wallet.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/page_text_style.dart';
import 'package:ax_dapp/pages/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/controller/usecases/get_wallet_address_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DesktopFarm extends StatefulWidget {
  const DesktopFarm({super.key});

  @override
  State<DesktopFarm> createState() => _DesktopFarmState();
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var layoutHgt = _height * 0.8;
    final layoutWdt = _width * 0.95;
    if (_height < 445) layoutHgt = _height;
    return Container(
      width: _width,
      height: _height - AppBar().preferredSize.height,
      margin: isWeb
          ? EdgeInsets.zero
          : EdgeInsets.only(top: AppBar().preferredSize.height + 10),
      alignment: Alignment.center,
      child: SizedBox(
        //outermost dimensions for farm section
        width: layoutWdt,
        height: layoutHgt,
        // child:  FarmLayout(layoutHgt, layoutWdt),
        child: BlocProvider(
          create: (BuildContext context) => FarmBloc(
            repo: GetFarmDataUseCase(),
            controller: GetWalletAddressUseCase(Get.find()),
          ),
          child: farmLayout(layoutHgt, layoutWdt),
        ),
      ),
    );
  }

  Widget farmLayout(double layoutHgt, double layoutWdt) {
    // Contains Participating farms, search bar, toggle buttons and cards for
    // all farms
    var listHeight = (isWeb && isAllFarms) ? 225.0 : layoutHgt * 0.80;
    //If web and in MyFarms list height 500
    if (isWeb && !isAllFarms) listHeight = 500.0;
    return BlocBuilder<FarmBloc, FarmState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final bloc = context.read<FarmBloc>();
        var widget = loading();
        if (state.status == BlocStatus.initial) {
          if (state.isAllFarms) {
            bloc.add(OnLoadFarms());
          } else {
            bloc.add(OnLoadStakedFarms());
          }
        }

        if (state.status == BlocStatus.error ||
            state.status == BlocStatus.noData) {
          widget = noData();
        }
        if (!state.isAllFarms && state.status == BlocStatus.noWallet) {
          widget = noWallet();
        }
        final Widget toggle = toggleFarmButton(bloc, layoutWdt, layoutHgt);
        return Wrap(
          runSpacing: layoutHgt * 0.02,
          clipBehavior: Clip.hardEdge,
          children: [
            Row(
              mainAxisAlignment: isWeb
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: isWeb ? 300 : layoutWdt / 2,
                  height: isWeb ? 45 : layoutHgt * 0.05,
                  child: Text(
                    isAllFarms ? 'Participating Farms' : 'My Farms',
                    style: textStyle(Colors.white, 24, true, false),
                  ),
                ),
                if (!isWeb) createSearchBar(bloc, layoutWdt, layoutHgt),
              ],
            ),
            if (isWeb)
              Row(
                children: [
                  createSearchBar(bloc, layoutWdt, layoutHgt),
                  const SizedBox(width: 50),
                  toggle
                ],
              ),
            if (!isWeb) toggle,
            SizedBox(
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWeb ? 4 : 1,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: state.isAllFarms ? 1.75 : 1,
                        ),
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
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
                                  layoutWdt,
                                )
                              : myFarmItem(
                                  context,
                                  isWeb,
                                  FarmController(
                                    state.filteredStakedFarms[index],
                                  ),
                                  listHeight,
                                  layoutWdt,
                                );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Container toggleFarmButton(
    FarmBloc bloc,
    double layoutWdt,
    double layoutHgt,
  ) {
    return Container(
      width: isWeb ? 200 : layoutWdt,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: isWeb ? 90 : (layoutWdt / 2) - 5,
            decoration: isAllFarms
                ? boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent)
                : boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  ),
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
              child: Text(
                'All Farms',
                style: textStyle(Colors.white, 16, true, false),
              ),
            ),
          ),
          Container(
            width: isWeb ? 90 : (layoutWdt / 2) - 5,
            decoration: isAllFarms
                ? boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  )
                : boxDecoration(
                    Colors.grey[600]!,
                    100,
                    0,
                    Colors.transparent,
                  ),
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
              child: Text(
                'My Farms',
                style: textStyle(Colors.white, 16, true, false),
              ),
            ),
          )
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
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 50),
          Expanded(
            child: TextFormField(
              controller: myController,
              onChanged: (value) {
                bloc.add(OnSearchFarms(searchedName: value));
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
}
