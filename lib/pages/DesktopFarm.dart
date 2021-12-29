import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/AthleteApi.dart';
import 'package:ax_dapp/service/AthleteList.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DesktopFarm extends StatefulWidget {
  const DesktopFarm({Key? key}) : super(key: key);

  @override
  _DesktopFarmState createState() => _DesktopFarmState();
}

class _DesktopFarmState extends State<DesktopFarm> {
  bool allFarms = true;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container( 
        width: MediaQuery.of(context).size.width*0.8,
        height: MediaQuery.of(context).size.height*0.8,
        child: (allFarms) ? allFarmLayout() : myFarmLayout()
      )
    );
  }

  Widget allFarmLayout() {
    List<Farm> farmList = [
      Farm("AX Farm"),
    ];

    for (Athlete ath in AthleteList.list)
      farmList.add(Farm(
        "AX - " + ath.name + " APT"
      )
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: MediaQuery.of(context).size.height*0.1,),
        Container(
          height: 45,
          alignment: Alignment.bottomLeft,
          child: Text(
            "Participating Farms",
            style: textStyle(Colors.white, 24, true, false)
          )
        ),
        Container(
          width: 200,
          height: 40,
          decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 85,
                decoration: boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "All Farms",
                    style: textStyle(Colors.white, 16, true, false)
                  )
                )
              ),
              Container(
                width: 90,
                decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
                child: TextButton(
                  onPressed: () {setState(() {allFarms = false;});},
                  child: Text(
                    "My Farms",
                    style: textStyle(Colors.white, 16, true, false)
                  )
                )
              )
            ]
          )
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.5,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: AthleteList.list.length,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height*0.55,
                  alignment: Alignment.topLeft,
                  child: createFarmWidget(farmList[index]));
              }
            )
          )
        )
      ]
    );
  }

  Widget myFarmLayout() {
    List<Farm> farmList = [
      Farm("AX Farm"),
    ];

    for (Athlete ath in AthleteList.list)
      farmList.add(Farm(
        "AX - " + ath.name + " APT"
      )
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: MediaQuery.of(context).size.height*0.1,),
        Container(
          height: 45,
          alignment: Alignment.bottomLeft,
          child: Text(
            "My Farms",
            style: textStyle(Colors.white, 24, true, false)
          )
        ),
        Container(
          width: 200,
          height: 40,
          decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 85,
                decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
                child: TextButton(
                  onPressed: () {setState(() {allFarms = true;});},
                  child: Text(
                    "All Farms",
                    style: textStyle(Colors.white, 16, true, false)
                  )
                )
              ),
              Container(
                width: 90,
                decoration: boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "My Farms",
                    style: textStyle(Colors.white, 16, true, false)
                  )
                )
              ),
            ],
          )
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.height*0.5,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: AthleteList.list.length+1,
              itemBuilder: (context, index) {
                if(index == 0){
                  return createAXFarmCard(farmList[index]);
                }
                return createMyFarmWidget(farmList[index]);
              }
            )
          )
        )
      ]
    );
  }

  // First card of the my farms page is unique
  Widget createAXFarmCard(Farm farm){
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Row(
      children: <Widget> [
        Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: 600,
          decoration: boxDecoration(Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Farm Title
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      farm.name,
                      style: textStyle(Colors.white, 20, false, false)
                    ),
                  ]
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total APY",
                      style: txStyle,
                    ),
                    Text(
                      "12%",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "TVL",
                      style: txStyle
                    ),
                    Text(
                      "\$1,000,000",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "LP APY",
                      style: txStyle
                    ),
                    Text(
                      "5%",
                      style: txStyle
                    )
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
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Your Position",
                      style: textStyle(Colors.white, 20, false, false)
                    ),
                  ]
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "AX provided",
                      style: txStyle,
                    ),
                    Text(
                      "1,000 AX",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Rewards Earned",
                      style: txStyle,
                    ),
                    Text(
                      "100 AX",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total AX available (Staked + Earned)",
                      style: txStyle
                    ),
                    Text(
                      "1,100 AX",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 35,
                      decoration: boxDecoration(Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                      child: TextButton(
                        onPressed: () => showDialog(context: context, builder: (BuildContext context) => depositDialog(context)),
                        child: Text(
                          "Deposit",
                          style: textStyle(Colors.black, 14, true, false)
                        )
                      )
                    ),
                    Container(
                      width: 120,
                      height: 35,
                      decoration: boxDecoration(Colors.transparent, 100, 0, Colors.amber[600]!),
                      child: TextButton(
                        onPressed: () => showDialog(context: context, builder: (BuildContext context) => removeDialog(context)),
                        child: Text(
                          "Remove",
                          style: textStyle(Colors.amber[600]!, 14, true, false)
                        )
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 50),
      ]
    );
  }

  Widget createFarmWidget(Farm farm) {
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Row(
      children: <Widget> [
        Container(
          height: 200,
          width: 500,
          padding: EdgeInsets.symmetric(vertical: 22.5, horizontal: 50),
          decoration: boxDecoration(Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Farm Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    farm.name,
                    style: textStyle(Colors.white, 20, false, false)
                  ),
                  Container(
                    width: 120,
                    height: 35,
                    decoration: boxDecoration(Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                    child: TextButton(
                      onPressed: () => showDialog(context: context, builder: (BuildContext context) => depositDialog(context)),
                      child: Text(
                        "Deposit",
                        style: textStyle(Colors.black, 14, true, false)
                      )
                    )
                  ),
                ]
              ),
              // TVL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "TVL",
                    style: txStyle,
                  ),
                  Text(
                    "\$1,000,000",
                    style: txStyle
                  )
                ],
              ),
              // Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Swap Fee APY",
                    style: txStyle
                  ),
                  Text(
                    "20%",
                    style: txStyle
                  )
                ],
              ),
              // Rewards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "AX Rewards APY",
                    style: txStyle
                  ),
                  Text(
                    "10%",
                    style: txStyle
                  )
                ],
              ),
              // Total APY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total APY",
                    style: txStyle
                  ),
                  Text(
                    "30%",
                    style: txStyle
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 50),
      ]
    );
  }

  // Returning a Row (This one works. Need to fix container size and padding)
  Widget createMyFarmWidget(Farm farm) {
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Row(
      children: <Widget> [
        Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: 600,
          decoration: boxDecoration(Color(0x80424242).withOpacity(0.25), 20, 1, Colors.grey[600]!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Farm Title
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      farm.name,
                      style: textStyle(Colors.white, 20, false, false)
                    ),
                  ]
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total APY",
                      style: txStyle,
                    ),
                    Text(
                      "12%",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "TVL",
                      style: txStyle
                    ),
                    Text(
                      "\$1,000,000",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "LP APY",
                      style: txStyle
                    ),
                    Text(
                      "5%",
                      style: txStyle
                    )
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
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Your Position",
                      style: textStyle(Colors.white, 20, false, false)
                    ),
                  ]
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "LP tokens provided",
                      style: txStyle,
                    ),
                    Text(
                      "100 LP",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Rewards Earned",
                      style: txStyle
                    ),
                    Text(
                      "100 AX",
                      style: txStyle
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 35,
                      decoration: boxDecoration(Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                      child: TextButton(
                        onPressed: () => showDialog(context: context, builder: (BuildContext context) => depositDialog(context)),
                        child: Text(
                          "Deposit",
                          style: textStyle(Colors.black, 14, true, false)
                        )
                      )
                    ),
                    Container(
                      width: 120,
                      height: 35,
                      decoration: boxDecoration(Colors.transparent, 100, 0, Colors.amber[600]!),
                      child: TextButton(
                        onPressed: () => showDialog(context: context, builder: (BuildContext context) => removeDialog(context)),
                        child: Text(
                          "Remove",
                          style: textStyle(Colors.amber[600]!, 14, true, false)
                        )
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 50),
      ]
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold)
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
        );
    else
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
        );
  }
  
  BoxDecoration boxDecoration(Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(
        color: borCol,
        width: borWid
      )
    );
  }
}

class Farm {
  final String name;

  Farm(this.name);
}