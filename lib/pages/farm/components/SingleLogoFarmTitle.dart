import 'package:flutter/material.dart';

import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';
import 'package:ax_dapp/pages/farm/dialogs/StakeDialog.dart';
import 'package:ax_dapp/pages/farm/dialogs/DualStakeDialog.dart';
import 'package:ax_dapp/pages/farm/modules/PageTextStyle.dart';
import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';

Widget singleLogoFarmTitle(
    BuildContext context, bool isWeb, FarmController farm, double cardWidth) {
  //Dialog that appears when stake button is pressed
  Dialog participatingDialog;
  if (farm.athlete == null) {
    participatingDialog = stakeDialog(context, farm, cardWidth, isWeb);
  } else {
    participatingDialog =
        dualStakeDialog(context, farm, farm.athlete!, cardWidth, isWeb);
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
                        builder: (BuildContext context) => participatingDialog),
                    child: Text("Stake",
                        style: textStyle(Colors.black, 14, true, false)))),
          ]));
}
