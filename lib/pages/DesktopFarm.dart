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
  bool isWeb = true;
  bool allFarms = true;
  List<Farm> everyFarm = [];
  List<Farm> workingFarm = [];
  List<Farm> farmList = [];
  List<Farm> farmListFilter = [];

  // ignore: must_call_super
  void initState() {
    everyFarm.add(Farm("AX Farm"));
    farmList.add(Farm("AX Farm"));

    for (Athlete ath in AthleteList.list) {
      everyFarm.add(Farm("AX - " + ath.name + " APT", ath));
      farmList.add(Farm("AX - " + ath.name + " APT", ath));
    }

    workingFarm = everyFarm;
    farmListFilter = farmList;
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double hgt = _height * 0.7;
    if (_height < 445) hgt = _height;

    return Container(
        width: _width,
        height: _height - 57,
        alignment: Alignment.center,
        child: Container(
            //outermost dimensions for farm section
            width: _width * 0.95,
            height: hgt,
            child: (allFarms) ? allFarmLayout() : myFarmLayout()));
  }

  Widget allFarmLayout() {
    //Contains Participating farms, search bar, toggle buttons and cards for all farms
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    bool vertical = true;

    if (_height < 445) vertical = false;

    Widget toggle = Container(
        width: 200,
        height: 40,
        decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                  width: 85,
                  decoration: boxDecoration(
                      Colors.grey[600]!, 100, 0, Colors.transparent),
                  child: TextButton(
                      onPressed: () {},
                      child: Text("All Farms",
                          style: textStyle(Colors.white, 16, true, false)))),
              Container(
                  width: 90,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          allFarms = false;
                        });
                      },
                      child: Text("My Farms",
                          style: textStyle(Colors.white, 16, true, false))))
            ]));

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 45,
                  alignment: Alignment.bottomLeft,
                  child: Text("Participating Farms",
                      style: textStyle(Colors.white, 24, true, false))),
              if (!vertical) toggle,
            ],
          ),
          if (vertical)
            Row(
              children: <Widget>[
                createSearchBar(),
                SizedBox(width: 50),
                toggle
              ],
            ),
          Container(
              //contains list of allfarms cards
              width: _width * 1,
              height: _height * 0.5,
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                    },
                  ),
                  child: ListView.builder(
                      scrollDirection: isWeb ? Axis.horizontal : Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: workingFarm.length,
                      itemBuilder: (context, index) {
                        return Container(
                            height: _height * 0.55,
                            alignment: Alignment.topLeft,
                            child: createAllFarmItem(workingFarm[index]));
                      })))
        ]);
  }

  Widget myFarmLayout() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double cardHeight = _height * 0.5;
    if (cardHeight < 225) cardHeight = 225;

    bool vertical = true;
    if (_height < 445) vertical = false;

    /*List<Farm> farmList = [
      Farm("AX Farm"),
    ];

    for (Athlete ath in AthleteList.list)
      farmList.add(Farm("AX - " + ath.name + " APT", ath));*/

    //List<Farm> farmListFilter = farmList;

    Widget toggle = Container(
        width: 200,
        height: 40,
        decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                  width: 85,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          allFarms = true;
                        });
                      },
                      child: Text("All Farms",
                          style: textStyle(Colors.white, 16, true, false)))),
              Container(
                  width: 90,
                  decoration: boxDecoration(
                      Colors.grey[600]!, 100, 0, Colors.transparent),
                  child: TextButton(
                      onPressed: () {},
                      child: Text("My Farms",
                          style: textStyle(Colors.white, 16, true, false))))
            ]));

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    height: 45,
                    alignment: Alignment.bottomLeft,
                    child: Text("My Farms",
                        style: textStyle(Colors.white, 24, true, false))),
                if (!vertical) toggle,
              ]),
          //if (vertical) toggle,
          if (vertical)
            Row(
              children: <Widget>[
                createSearchBar(),
                SizedBox(width: 50),
                toggle
              ],
            ),
          Container(
              width: _width * 0.8,
              height: cardHeight,
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                    },
                  ),
                  child: ListView.builder(
                      scrollDirection: isWeb ? Axis.horizontal : Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: farmListFilter.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return createMyFarmAXItem(farmListFilter[index]);
                        }
                        return createMyFarmAPTItem(farmListFilter[index]);
                      })))
        ]);
  }

  // First card of the my farms page is unique
  Widget createMyFarmAXItem(Farm farm) {
    double _height = MediaQuery.of(context).size.height;
    double cardWidth = 600;
    double cardHeight = _height * 0.5;
    if (cardHeight < 225) cardHeight = 225;
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Row(children: <Widget>[
      Container(
        height: cardHeight,
        width: cardWidth,
        decoration: boxDecoration(
            Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Farm Title
            Container(
              width: cardWidth - 100,
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
                    Container(width: 10),
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
                                    depositDialog(context)),
                            child: Text("Stake",
                                style:
                                    textStyle(Colors.black, 14, true, false)))),
                  ]),
            ),
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
            Container(
              width: cardWidth - 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 240,
                      height: 35,
                      decoration: boxDecoration(
                          Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                      child: TextButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  rewardsClaimed(context)),
                          child: Text("Claim Rewards",
                              style:
                                  textStyle(Colors.black, 14, true, false)))),
                  Container(
                      width: 240,
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
      ),
      SizedBox(width: 50),
    ]);
  }

  Widget createAllFarmItem(Farm farm) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    double cardWidth = isWeb ? 500 : mediaquery.size.width * 0.9;
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
      height: 200,
      width: cardWidth,
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

  // Returning a Row (This one works. Need to fix container size and padding)
  Widget createMyFarmAPTItem(Farm farm) {
    double _height = MediaQuery.of(context).size.height;
    double cardWidth = 600;
    double cardHeight = _height * 0.5;
    if (cardHeight < 225) cardHeight = 225;
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Row(children: <Widget>[
      Container(
        height: cardHeight,
        width: cardWidth,
        decoration: boxDecoration(
            Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Farm Title
            Container(
              width: cardWidth - 100,
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
                          image: AssetImage("../assets/images/apt.png"),
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
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      dualDepositDialog(
                                          context, farm.athlete!));
                            },
                            child: Text("Stake",
                                style:
                                    textStyle(Colors.black, 14, true, false)))),
                  ]),
            ),
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
            Container(
              width: cardWidth - 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 240,
                      height: 35,
                      decoration: boxDecoration(
                          Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                      child: TextButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  depositDialog(context)),
                          child: Text("Claim Rewards",
                              style:
                                  textStyle(Colors.black, 14, true, false)))),
                  Container(
                      width: 240,
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
      ),
      SizedBox(width: 50),
    ]);
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
                onChanged: (value) {
                  setState(() {
                    if (!allFarms) {
                      farmListFilter = farmList
                          .where((farm) => farm.name
                              .toUpperCase()
                              .contains(value.toUpperCase()))
                          .toList();
                    } else {
                      workingFarm = everyFarm
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
                    image: AssetImage("../assets/images/apt.png"),
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
