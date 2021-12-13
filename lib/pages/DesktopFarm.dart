import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/Dialog.dart';
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
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height*0.45+40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.15,
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
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (allFarms)
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
                  if (allFarms)
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
                    ),
                  if (!allFarms)
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
                  if (!allFarms)
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
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.height/4,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  createFarmWidget("AX Farm"),
                  SizedBox(width: 50),
                  createFarmWidget("AX - Tom Brady APT"),
                  SizedBox(width: 50),
                  createFarmWidget("AX - Tom Brady APT"),
                ]
              ),
            )
          )
        ],
      )
    );
  }

  Widget createFarmWidget(String farmName) {
    TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

    return Container(
      height: MediaQuery.of(context).size.height/4,
      width: 500,
      padding: EdgeInsets.symmetric(vertical: 22.5, horizontal: 50),
      decoration: boxDecoration(Color(0x80424242), 20, 1, Colors.grey[300]!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Farm Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                farmName,
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