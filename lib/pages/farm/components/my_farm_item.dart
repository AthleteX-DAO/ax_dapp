// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/farm/components/double_logo_farm_title.dart';
import 'package:ax_dapp/pages/farm/components/single_logo_farm_title.dart';
import 'package:ax_dapp/pages/farm/dialogs/reward_claim_dialog.dart';
import 'package:ax_dapp/pages/farm/dialogs/unstake_dialog.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/page_text_style.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// First card of the my farms page is unique
Widget myFarmItem(
  BuildContext context,
  bool isWeb,
  FarmController farm,
  double listHeight,
  double layoutWidth,
) {
  const minCardHeight = 450.0;
  const maxCardHeight = 500.0;
  final cardWidth = isWeb ? (layoutWidth / 4) - 50 : layoutWidth;
  var cardHeight = listHeight * 0.7;
  if (cardHeight < minCardHeight) cardHeight = minCardHeight;
  if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

  final txStyle = textStyle(Colors.grey[600]!, 14, false, false);

  Widget farmTitleWidget;
  if (farm.athlete == null) {
    farmTitleWidget = singleLogoFarmTitle(context, isWeb, farm, cardWidth);
  } else {
    farmTitleWidget = doubleLogoFarmTitle(context, isWeb, farm, cardWidth);
  }

  return Container(
    margin: isWeb
        ? const EdgeInsets.symmetric(horizontal: 5, vertical: 5)
        : const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    height: cardHeight,
    width: cardWidth,
    decoration: boxDecoration(
      const Color(0x80424242).withOpacity(0.25),
      20,
      1,
      Colors.grey[600]!,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Farm Title
        farmTitleWidget,
        // Current Balance
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Balance',
              style: txStyle,
            ),
            Obx(
              () => Text(
                '${farm.stakingInfo.value.viewAmount} ${farm.strStakedSymbol}',
                style: txStyle,
              ),
            )
          ],
        ),
        //Upper information section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current APR',
              style: txStyle,
            ),
            Text('${farm.strAPR}%', style: txStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TVL', style: txStyle),
            Text('\$${farm.strTVL}', style: txStyle)
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
          children: [
            Text(
              'Your Position',
              style: textStyle(Colors.white, 20, false, false),
            ),
          ],
        ),
        //Show different information for AX item card and AX with APT card
        if (farm.athlete == null) ...[
          SizedBox(
            width: cardWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Currently Staked',
                  style: txStyle,
                ),
                Obx(
                  () => Text(
                    '''${double.parse(farm.stakedInfo.value.viewAmount).toStringAsFixed(4)} ${farm.strStakedSymbol}''',
                    style: txStyle,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rewards Earned',
                  style: txStyle,
                ),
                Obx(
                  () => Text(
                    '${farm.strRewards} ${farm.strRewardSymbol}',
                    style: txStyle,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total AX available (Staked + Earned)', style: txStyle),
                Obx(
                  () => Text(
                    '''${(double.parse(farm.stakedInfo.value.viewAmount) + double.parse(farm.strRewards.value)).toStringAsFixed(2)} ${farm.strRewardSymbol}''',
                    style: txStyle,
                  ),
                )
              ],
            ),
          ),
        ] else ...[
          SizedBox(
            width: cardWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LP tokens provided',
                  style: txStyle,
                ),
                Text('100 LP', style: txStyle)
              ],
            ),
          ),
          SizedBox(
            width: cardWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rewards Earned', style: txStyle),
                Obx(
                  () => Text(
                    '{farmController.rewardsEarned} ${farm.strRewardSymbol}',
                    style: txStyle,
                  ),
                )
              ],
            ),
          ),
        ],
        //Claim rewards and Unstake liquidity buttons
        SizedBox(
          width: cardWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                //subtract padding for card's content for mobile
                width: (cardWidth / 2) - 25,
                height: 35,
                decoration: boxDecoration(
                  Colors.amber[600]!,
                  100,
                  0,
                  Colors.amber[600]!,
                ),
                child: TextButton(
                  onPressed: () async => {
                    await farm.claim(),
                    showDialog<void>(
                      context: context,
                      builder: rewardClaimDialog,
                    )
                  },
                  child: Text(
                    'Claim Rewards',
                    style: textStyle(Colors.black, 14, true, false),
                  ),
                ),
              ),
              Container(
                //width takes into account padding for card's content
                width: (cardWidth / 2) - 25,
                height: 35,
                decoration: boxDecoration(
                  Colors.transparent,
                  100,
                  0,
                  Colors.amber[600]!,
                ),
                child: TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) =>
                        unstakeDialog(context, farm, cardWidth, isWeb),
                  ),
                  child: Text(
                    'Unstake Liquidity',
                    style: textStyle(Colors.amber[600]!, 14, true, false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
