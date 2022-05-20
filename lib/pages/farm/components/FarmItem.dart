import 'package:flutter/material.dart';

import 'package:ax_dapp/service/Controller/Farms/Farm.dart';
import 'package:ax_dapp/pages/farm/components/SingleLogoFarmTitle.dart';
import 'package:ax_dapp/pages/farm/components/DoubleLogoFarmTitle.dart';
import 'package:ax_dapp/pages/farm/modules/PageTextStyle.dart';
import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';

Widget FarmItem(BuildContext context, bool isWeb, Farm farm, double listHeight,
    double layoutWdt) {
  double minCardHeight = 200;
  double maxCardHeight = 350;
  double cardWidth = isWeb ? 500 : layoutWdt;
  double cardHeight = listHeight * 0.4;
  if (cardHeight < minCardHeight) cardHeight = minCardHeight;
  if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

  TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);
  Widget farmTitleWidget;
  if (farm.athlete == null) {
    farmTitleWidget = SingleLogoFarmTitle(context, isWeb, farm, cardWidth);
  } else {
    farmTitleWidget = DoubleLogoFarmTitle(context, isWeb, farm, cardWidth);
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
