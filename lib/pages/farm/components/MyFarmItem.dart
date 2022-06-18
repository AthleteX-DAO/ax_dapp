import 'package:ax_dapp/pages/farm/dialogs/RewardClaimDialog.dart';
import 'package:ax_dapp/pages/farm/dialogs/UnstakeDialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';
import 'package:ax_dapp/pages/farm/components/SingleLogoFarmTitle.dart';
import 'package:ax_dapp/pages/farm/components/DoubleLogoFarmTitle.dart';
import 'package:ax_dapp/pages/farm/modules/PageTextStyle.dart';
import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';

// First card of the my farms page is unique
Widget myFarmItem(BuildContext context, bool isWeb, FarmController farm,
    double listHeight, double layoutWidth) {
  double minCardHeight = 450;
  double maxCardHeight = 500;
  double cardWidth = isWeb ? (layoutWidth / 4) - 50 : layoutWidth;
  double cardHeight = listHeight * 0.7;
  if (cardHeight < minCardHeight) cardHeight = minCardHeight;
  if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

  TextStyle txStyle = textStyle(Colors.grey[600]!, 14, false, false);

  Widget farmTitleWidget;
  if (farm.athlete == null)
    farmTitleWidget = singleLogoFarmTitle(context, isWeb, farm, cardWidth);
  else
    farmTitleWidget = doubleLogoFarmTitle(context, isWeb, farm, cardWidth);

  return Container(
    margin: isWeb
        ? EdgeInsets.symmetric(horizontal: 5, vertical: 5)
        : EdgeInsets.symmetric(vertical: 5),
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
        // Current Balance
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Current Balance",
              style: txStyle,
            ),
            Obx(() => Text(
                "${farm.stakingInfo.value.viewAmount} ${farm.strStakedSymbol}",
                style: txStyle))
          ],
        ),
        //Upper information section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Current APR",
              style: txStyle,
            ),
            Text("${farm.strAPR}%", style: txStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("TVL", style: txStyle),
            Text("\$${farm.strTVL}", style: txStyle)
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
                Obx(() => Text(
                    "${double.parse(farm.stakedInfo.value.viewAmount).toStringAsFixed(4)} ${farm.strStakedSymbol}",
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
                Obx(() => Text("${farm.strRewards} ${farm.strRewardSymbol}",
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
                Obx(() => Text(
                    "${(double.parse(farm.stakedInfo.value.viewAmount) + double.parse(farm.strRewards.value)).toStringAsFixed(2)} ${farm.strRewardSymbol}",
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
                Obx(() => Text(
                    "{farmController.rewardsEarned} ${farm.strRewardSymbol}",
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
                  width: (cardWidth / 2) - 25,
                  height: 35,
                  decoration: boxDecoration(
                      Colors.amber[600]!, 100, 0, Colors.amber[600]!),
                  child: TextButton(
                      onPressed: () async => {
                            await farm.claim(),
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    rewardClaimDialog(context))
                          },
                      child: Text("Claim Rewards",
                          style: textStyle(Colors.black, 14, true, false)))),
              Container(
                  //width takes into account padding for card's content
                  width: (cardWidth / 2) - 25,
                  height: 35,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 0, Colors.amber[600]!),
                  child: TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              unstakeDialog(context, farm, cardWidth, isWeb)),
                      child: Text("Unstake Liquidity",
                          style:
                              textStyle(Colors.amber[600]!, 14, true, false)))),
            ],
          ),
        ),
      ],
    ),
  );
}
