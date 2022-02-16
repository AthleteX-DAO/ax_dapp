import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DesktopFarm extends StatefulWidget {
  const DesktopFarm({Key? key}) : super(key: key);

  @override
  _DesktopFarmState createState() => _DesktopFarmState();
}

class _DesktopFarmState extends State<DesktopFarm> {
  final myController = TextEditingController();
  bool isWeb = true;
  bool isAllFarms = true;
  List<Farm> allFarmsList = [];
  List<Farm> allFarmsListSearchFilter = [];
  List<Farm> myFarmsList = [];
  List<Farm> myFarmsListSearchFilter = [];

  // ignore: must_call_super
  void initState() {
    allFarmsList.add(Farm("AX Farm"));
    myFarmsList.add(Farm("AX Farm"));

    for (Athlete ath in AthleteList.list) {
      allFarmsList.add(Farm("AX - " + ath.name + " APT", ath));
      myFarmsList.add(Farm("AX - " + ath.name + " APT", ath));
    }

    allFarmsListSearchFilter = allFarmsList;
    myFarmsListSearchFilter = myFarmsList;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double sectionHgt = isWeb ? _height * 0.7 : _height * 0.75;
    if (_height < 445) sectionHgt = _height;

    return Container(
        width: _width,
        height: _height - 57,
        alignment: Alignment.center,
        child: Container(
            //outermost dimensions for farm section
            width: _width * 0.95,
            height: sectionHgt,
            child: farmLayout()));
  }

  Widget farmLayout() {
    //Contains Participating farms, search bar, toggle buttons and cards for all farms
    MediaQueryData mediaquery = MediaQuery.of(context);
    double _width = mediaquery.size.width;
    double _height = mediaquery.size.height;
    double listHeight = (isWeb && isAllFarms) ? 225 : _height * 0.65;
    //If web and in MyFarms list height 500
    if (isWeb && !isAllFarms) listHeight = 500;
    double listWidth = _width * 0.95;

    Widget toggle = toggleFarmButton();

    return Wrap(runSpacing: _height * 0.02, children: <Widget>[
      FittedBox(
        fit: BoxFit.fill,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 45,
              alignment: Alignment.bottomLeft,
              child: isAllFarms
                  ? Text(
                      "Participating Farms",
                      style: textStyle(Colors.white, 24, true, false),
                    )
                  : Container(
                      height: 45,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "My Farms",
                        style: textStyle(Colors.white, 24, true, false),
                      ),
                    ),
            ),
            if (!isWeb) createSearchBar(),
          ],
        ),
      ),
      if (isWeb)
        Row(
          children: <Widget>[createSearchBar(), SizedBox(width: 50), toggle],
        ),
      if (!isWeb) toggle,
      Container(
          //contains list of allfarms cards
          width: listWidth,
          height: listHeight,
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
              ),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: isWeb ? Axis.horizontal : Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  //TO DO change this based on allfarms or myfarms is selected - Mauricio
                  itemCount: isAllFarms
                      ? allFarmsListSearchFilter.length
                      : myFarmsListSearchFilter.length,
                  itemBuilder: (context, index) {
                    return isAllFarms
                        ? createAllFarmItem(
                            allFarmsListSearchFilter[index], listHeight)
                        : createMyFarmItem(myFarmsListSearchFilter[index],
                            listHeight, listWidth);
                  })))
    ]);
  }

  Container toggleFarmButton() {
    return Container(
      width: 200,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 85,
              decoration: isAllFarms
                  ? boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent)
                  : boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent),
              child: TextButton(
                  onPressed: () {
                    if (!isAllFarms) {
                      myController.clear();
                      setState(() {
                        allFarmsListSearchFilter = allFarmsList;
                        isAllFarms = true;
                      });
                    }
                  },
                  child: Text("All Farms",
                      style: textStyle(Colors.white, 16, true, false)))),
          Container(
              width: 90,
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
                        myFarmsListSearchFilter = myFarmsList;
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
  Widget createMyFarmItem(Farm farm, double listHeight, double listWidth) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    //TO DO pass list width so that this method knows width of parent - Mauricio
    //Cannot stablish a height for list items for cross axis alignment, in this case for rows
    //So for rows height is stablished in outer container
    double minCardHeight = 450;
    double maxCardHeight = 500;
    double cardWidth = isWeb ? 500 : mediaquery.size.width * 0.9;
    double cardHeight = listHeight * 0.7;
    if (cardHeight < minCardHeight) cardHeight = minCardHeight;
    if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);
    Dialog participatingDialog;
    Widget farmTitleWidget;
    if (farm.athlete == null) {
      farmTitleWidget = farmTitleSingleLogo(farm, cardWidth);
      //Dialog show on stake button press (already inside farmTitleWidget method)
      //participatingDialog = depositDialog(context);
    } else {
      farmTitleWidget = farmTitleDoubleLogo(farm);
      //participatingDialog = dualDepositDialog(context, farm.athlete!);
    }
    return Container(
      margin: isWeb
          ? EdgeInsets.symmetric(horizontal: 10)
          : EdgeInsets.symmetric(vertical: 10),
      height: cardHeight,
      width: cardWidth,
      decoration: boxDecoration(
          Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Farm Title
          farmTitleWidget,
          Container(
            width: cardWidth - 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total APY",
                  style: txStyle,
                ),
                Text("12%", style: txStyle)
              ],
            ),
          ),
          Container(
            width: cardWidth - 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("TVL", style: txStyle),
                Text("\$1,000,000", style: txStyle)
              ],
            ),
          ),
          Container(
            width: cardWidth - 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("LP APY", style: txStyle),
                Text("5%", style: txStyle)
              ],
            ),
          ),
          Container(
            child: Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
          ),
          Container(
            width: cardWidth - 100,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Your Position",
                      style: textStyle(Colors.white, 20, false, false)),
                ]),
          ),
          //Show different information for AX item card and AX with APT card
          if (farm.athlete == null) ...[
            Container(
              width: cardWidth - 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "AX provided",
                    style: txStyle,
                  ),
                  Text("1,000 AX", style: txStyle)
                ],
              ),
            ),
            Container(
              width: cardWidth - 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Rewards Earned",
                    style: txStyle,
                  ),
                  Text("100 AX", style: txStyle)
                ],
              ),
            ),
            Container(
              width: cardWidth - 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total AX available (Staked + Earned)", style: txStyle),
                  Text("1,100 AX", style: txStyle)
                ],
              ),
            ),
          ] else ...[
            Container(
              width: cardWidth - 100,
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
              width: cardWidth - 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Rewards Earned", style: txStyle),
                  Text("100 AX", style: txStyle)
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
                    width: isWeb ? 240 : cardWidth / 2,
                    height: 35,
                    decoration: boxDecoration(
                        Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                    child: TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                rewardsClaimed(context)),
                        child: Text("Claim Rewards",
                            style: textStyle(Colors.black, 14, true, false)))),
                Container(
                    width: isWeb ? 240 : cardWidth / 2,
                    height: 35,
                    decoration: boxDecoration(
                        Colors.transparent, 100, 0, Colors.amber[600]!),
                    child: TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                removeDialog(context)),
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

  Widget createAllFarmItem(Farm farm, double listHeight) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    double minCardHeight = 200;
    double maxCardHeight = 350;
    double cardWidth = isWeb ? 500 : mediaquery.size.width * 0.9;
    double cardHeight = listHeight * 0.4;
    if (cardHeight < minCardHeight) cardHeight = minCardHeight;
    if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);
    Dialog participatingDialog;
    Widget farmTitleWidget;
    if (farm.athlete == null) {
      farmTitleWidget = farmTitleSingleLogo(farm, cardWidth);
      participatingDialog = depositDialog(context);
    } else {
      farmTitleWidget = farmTitleDoubleLogo(farm);
      participatingDialog = dualDepositDialog(context, farm.athlete!);
    }

    return Container(
      height: cardHeight,
      width: cardWidth,
      margin: isWeb
          ? EdgeInsets.symmetric(horizontal: 10)
          : EdgeInsets.symmetric(vertical: 10),
      decoration: boxDecoration(
          Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          farmTitleWidget,
          // Farm Title
          /*Container(
                width: cardWidth - 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(farm.name,
                          style: textStyle(Colors.white, 20, false, false)),
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
                                  style: textStyle(
                                      Colors.black, 14, true, false)))),
                    ])),*/
          // TVL
          Container(
              width: cardWidth - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "TVL",
                    style: txStyle,
                  ),
                  Text("\$1,000,000", style: txStyle)
                ],
              )),
          // Fee
          Container(
              width: cardWidth - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Swap Fee APY", style: txStyle),
                  Text("20%", style: txStyle)
                ],
              )),
          // Rewards
          Container(
              width: cardWidth - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("AX Rewards APY", style: txStyle),
                  Text("10%", style: txStyle)
                ],
              )),
          // Total APY
          Container(
            width: cardWidth - 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total APY", style: txStyle),
                Text("30%", style: txStyle)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createSearchBar() {
    return Container(
      width: 250,
      height: 40,
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
                    if (!isAllFarms) {
                      myFarmsListSearchFilter = myFarmsList
                          .where((farm) => farm.name
                              .toUpperCase()
                              .contains(value.toUpperCase()))
                          .toList();
                    } else {
                      allFarmsListSearchFilter = allFarmsList
                          .where((farm) => farm.name
                              .toUpperCase()
                              .contains(value.toUpperCase()))
                          .toList();
                    }
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
    Dialog participatingDialog;
    if (farm.athlete == null) {
      participatingDialog = depositDialog(context);
    } else {
      participatingDialog = dualDepositDialog(context, farm.athlete!);
    }
    return Container(
        width: cardWidth - 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("../assets/images/x.jpg"),
                  ),
                ),
              ),
              Container(width: 15),
              Expanded(
                child: Text(farm.name,
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

  Widget farmTitleDoubleLogo(Farm farm) {
    Dialog participatingDialog;
    if (farm.athlete == null) {
      participatingDialog = depositDialog(context);
    } else {
      participatingDialog = dualDepositDialog(context, farm.athlete!);
    }
    double cardWidth = 500;
    return Container(
        width: cardWidth - 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("../assets/images/x.jpg"),
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
                child: Text(farm.name,
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

class Farm {
  final String name;
  Athlete? athlete;

  Farm(this.name, [this.athlete]);
}
