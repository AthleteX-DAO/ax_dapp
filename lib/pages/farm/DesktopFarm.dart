import 'package:ax_dapp/pages/farm/components/FarmItem.dart';
import 'package:ax_dapp/pages/farm/components/MyFarmItem.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:ax_dapp/service/Controller/Farms/Farm.dart';
import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';
import 'package:ax_dapp/pages/farm/modules/PageTextStyle.dart';
import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';

class DesktopFarm extends StatefulWidget {
  const DesktopFarm({Key? key}) : super(key: key);

  @override
  _DesktopFarmState createState() => _DesktopFarmState();
}

class _DesktopFarmState extends State<DesktopFarm> {
  final farmController = FarmController();
  final myController = TextEditingController();
  bool isWeb = true;
  bool isAllFarms = true;

  /// initialize farms list from the farm controller
  /// will update it as async function
  void initAsyncState() {}

  // ignore: must_call_super
  void initState() {
    initAsyncState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    farmController.dispose();
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double layoutHgt = isWeb ? _height * 0.7 : _height * 0.8;
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
        child: farmLayout(layoutHgt, layoutWdt),
      ),
    );
  }

  Widget farmLayout(double layoutHgt, double layoutWdt) {
    //Contains Participating farms, search bar, toggle buttons and cards for all farms
    double listHeight = (isWeb && isAllFarms) ? 225 : layoutHgt * 0.80;
    //If web and in MyFarms list height 500
    if (isWeb && !isAllFarms) listHeight = 500;

    Widget toggle = toggleFarmButton(layoutWdt, layoutHgt);

    return Wrap(runSpacing: layoutHgt * 0.02, children: <Widget>[
      Row(
        mainAxisAlignment:
            isWeb ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: isWeb ? 300 : layoutWdt / 2,
            height: isWeb ? 45 : layoutHgt * 0.05,
            child: isAllFarms
                ? Text(
                    "Participating Farms",
                    style: textStyle(Colors.white, 24, true, false),
                  )
                : Container(
                    child: Text(
                      "My Farms",
                      style: textStyle(Colors.white, 24, true, false),
                    ),
                  ),
          ),
          if (!isWeb) createSearchBar(layoutWdt, layoutHgt),
        ],
      ),
      if (isWeb)
        Row(
          children: <Widget>[
            createSearchBar(layoutWdt, layoutHgt),
            SizedBox(width: 50),
            toggle
          ],
        ),
      if (!isWeb) toggle,
      Container(
        //contains list of allfarms cards
        width: layoutWdt,
        height: listHeight,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
          ),
          child: Obx(() => ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: isWeb ? Axis.horizontal : Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: isAllFarms
                    ? farmController.filteredAllFarms.length
                    : farmController.filteredStakedFarms.length,
                itemBuilder: (context, index) {
                  return isAllFarms
                      ? FarmItem(
                          context,
                          isWeb,
                          farmController.filteredAllFarms[index],
                          listHeight,
                          layoutWdt)
                      : MyFarmItem(
                          context,
                          isWeb,
                          farmController.filteredStakedFarms[index],
                          listHeight,
                          layoutWdt);
                },
              )),
        ),
      ),
    ]);
  }

  Container toggleFarmButton(double layoutWdt, double layoutHgt) {
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
                        // myFarmsListSearchFilter = myFarmsList;
                        isAllFarms = false;
                      });
                    }
                  },
                  child: Text("My Farms",
                      style: textStyle(Colors.white, 16, true, false))))
        ],
      ),
    );
  }

  Widget createSearchBar(double layoutWdt, double layoutHgt) {
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
                  setState(() {
                    farmController.filterFarms(value);
                  });
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
