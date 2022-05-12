import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:ax_dapp/service/Controller/Farms/Farm.dart';
import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';
import 'package:get/get.dart';

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
  void initAsyncState() {
    
  }

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
            itemCount: isAllFarms ? farmController.filteredAllFarms.length : farmController.filteredStakedFarms.length,
            itemBuilder: (context, index) {
              return isAllFarms
                  ? createAllFarmItem(farmController.filteredAllFarms[index], listHeight, layoutWdt)
                  : createMyFarmItem(farmController.filteredStakedFarms[index], listHeight, layoutWdt);
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

  // First card of the my farms page is unique
  Widget createMyFarmItem(Farm farm, double listHeight, double layoutWidth) {
    //TO DO pass list width so that this method knows width of parent - Mauricio
    //Cannot stablish a height for list items for cross axis alignment, in this case for rows
    //So for rows height is stablished in outer container
    double minCardHeight = 450;
    double maxCardHeight = 500;
    double cardWidth = isWeb ? 500 : layoutWidth;
    double cardHeight = listHeight * 0.7;
    if (cardHeight < minCardHeight) cardHeight = minCardHeight;
    if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);
    Widget farmTitleWidget;
    if (farm.athlete == null) {
      farmTitleWidget = farmTitleSingleLogo(farm, cardWidth);
      //Dialog show on stake button press (already inside farmTitleWidget method)
      //participatingDialog = depositDialog(context);
    } else {
      farmTitleWidget = farmTitleDoubleLogo(farm, cardWidth);
      //participatingDialog = dualDepositDialog(context, farm.athlete!);
    }
    return Container(
      margin: isWeb
          ? EdgeInsets.symmetric(horizontal: 10)
          : EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: cardHeight,
      width: cardWidth,
      decoration: boxDecoration(
          Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Farm Title
          farmTitleWidget,
          //Upper information section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Current APR",
                style: txStyle,
              ),
              Text("${farm.dAPR.toStringAsFixed(2)}%", style: txStyle)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("TVL", style: txStyle),
              Text("\$${farm.dTVL.toStringAsFixed(2)}", style: txStyle)
            ],
          ),
          //Divider line
          Divider(
            thickness: 0.35,
            color: Colors.grey[400],
          ),
          //Bottom information section
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Your Position",
                    style: textStyle(Colors.white, 20, false, false)),
              ]),
          //Show different information for AX item card and AX with APT card
          if (farm.athlete == null) ...[
            Container(
              width: cardWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Currently Staked",
                    style: txStyle,
                  ),
                  Obx(() => Text("${farm.dStaked.toStringAsFixed(2)} ${farm.strStakedSymbol}",
                      style: txStyle))
                ],
              ),
            ),
            Container(
              width: cardWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Rewards Earned",
                    style: txStyle,
                  ),
                  Obx(() => Text("${farm.dRewards.toStringAsFixed(2)} ${farm.strRewardSymbol}",
                      style: txStyle))
                ],
              ),
            ),
            Container(
              width: cardWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total AX available (Staked + Earned)", style: txStyle),
                  Obx(() => Text("${(farm.dStaked.value + farm.dRewards.value).toStringAsFixed(2)} ${farm.strRewardSymbol}",
                      style: txStyle))
                ],
              ),
            ),
          ] else ...[
            Container(
              width: cardWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "LP tokens provided",
                    style: txStyle,
                  ),
                  Text("100 LP", style: txStyle)
                ],
              ),
            ),
            Container(
              width: cardWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Rewards Earned", style: txStyle),
                  Obx(() => Text("{farmController.rewardsEarned} ${farm.strRewardSymbol}",
                      style: txStyle))
                ],
              ),
            ),
          ],
          //Claim rewards and Unstake liquidity buttons
          Container(
            width: cardWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    //subtract padding for card's content for mobile
                    width: isWeb ? 215 : (cardWidth / 2) - 25,
                    height: 35,
                    decoration: boxDecoration(
                        Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                    child: TextButton(
                        onPressed: () async => {
                          await farm.claim(),
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => rewardsClaimed(context))
                        },
                        child: Text("Claim Rewards",
                            style: textStyle(Colors.black, 14, true, false)))),
                Container(
                    //width takes into account padding for card's content
                    width: isWeb ? 240 : (cardWidth / 2) - 25,
                    height: 35,
                    decoration: boxDecoration(
                        Colors.transparent, 100, 0, Colors.amber[600]!),
                    child: TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                removeDialog(context, farm, cardWidth, isWeb)),
                        child: Text("Unstake Liquidity",
                            style: textStyle(
                                Colors.amber[600]!, 14, true, false)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createAllFarmItem(Farm farm, double listHeight, double layoutWdt) {
    double minCardHeight = 200;
    double maxCardHeight = 350;
    double cardWidth = isWeb ? 500 : layoutWdt;
    double cardHeight = listHeight * 0.4;
    if (cardHeight < minCardHeight) cardHeight = minCardHeight;
    if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);
    Widget farmTitleWidget;
    if (farm.athlete == null) {
      farmTitleWidget = farmTitleSingleLogo(farm, cardWidth);
    } else {
      farmTitleWidget = farmTitleDoubleLogo(farm, cardWidth);
    }

    return Container(
      height: cardHeight,
      width: cardWidth,
      margin: isWeb
          ? EdgeInsets.symmetric(horizontal: 10)
          : EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: boxDecoration(
          Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          farmTitleWidget,
          // TVL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "TVL",
                style: txStyle,
              ),
              // Obx(() => Text("\$${farm.strTVL}", style: txStyle))
              Text("\$${farm.dTVL.toStringAsFixed(2)}", style: txStyle)
            ],
          ),

          // Total APY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Total APR", style: txStyle),
              // Obx(() => Text("${farm.strAPR}%", style: txStyle))
              Text("${farm.dAPR.toStringAsFixed(2)}%", style: txStyle)
            ],
          ),
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

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold) if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }

  Widget farmTitleSingleLogo(Farm farm, double cardWidth) {
    //Dialog that appears when stake button is pressed
    Dialog participatingDialog;
    if (farm.athlete == null) {
      participatingDialog = depositDialog(context, farm, cardWidth, isWeb);
    } else {
      participatingDialog =
          dualDepositDialog(context, farm, farm.athlete!, cardWidth, isWeb);
    }
    return Container(
        width: cardWidth,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/x.jpg"),
                  ),
                ),
              ),
              Container(width: 15),
              Expanded(
                child: Text(farm.strName,
                    style: textStyle(Colors.white, 20, false, false)),
              ),
              Container(
                  width: 120,
                  height: 35,
                  decoration: boxDecoration(
                      Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                  child: TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              participatingDialog),
                      child: Text("Stake",
                          style: textStyle(Colors.black, 14, true, false)))),
            ]));
  }

  Widget farmTitleDoubleLogo(Farm farm, double cardWidth) {
    Dialog participatingDialog;
    cardWidth = isWeb ? 500 : cardWidth;
    if (farm.athlete == null) {
      participatingDialog = depositDialog(context, farm, cardWidth, isWeb);
    } else {
      participatingDialog =
          dualDepositDialog(context, farm, farm.athlete!, cardWidth, isWeb);
    }
    return Container(
        width: cardWidth,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/x.jpg"),
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
                    image: AssetImage("assets/images/apt.png"),
                  ),
                ),
              ),
              Container(width: 5),
              Expanded(
                child: Text(farm.strName,
                    style: textStyle(Colors.white, 20, false, false)),
              ),
              Container(
                  width: 120,
                  height: 35,
                  decoration: boxDecoration(
                      Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                  child: TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              participatingDialog),
                      child: Text("Stake",
                          style: textStyle(Colors.black, 14, true, false)))),
            ]));
  }
}
