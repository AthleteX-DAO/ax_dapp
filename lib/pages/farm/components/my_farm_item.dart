// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/farm/components/single_logo_farm_title.dart';
import 'package:ax_dapp/pages/farm/dialogs/reward_claim_dialog.dart';
import 'package:ax_dapp/pages/farm/dialogs/unstake_dialog.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/page_text_style.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// First card of the my farms page is unique
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

  final customTextStyle = textStyle(Colors.grey[600]!, 14, false, false);
  final farmTitleWidget = singleLogoFarmTitle(context, isWeb, farm, cardWidth);

  final parsedView = double.parse(farm.stakedInfo.value.viewAmount);
  final parsedReward = double.parse(farm.strRewards.value);
  final parsedTotal = parsedView + parsedReward;
  final rewardSymbol = farm.strRewardSymbol;

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
              style: customTextStyle,
            ),
            Obx(
              () => Text(
                '${farm.stakingInfo.value.viewAmount} ${farm.strStakedSymbol}',
                style: customTextStyle,
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
              style: customTextStyle,
            ),
            Text('${farm.strAPR}%', style: customTextStyle)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TVL', style: customTextStyle),
            Text('\$${farm.strTVL}', style: customTextStyle)
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
        SizedBox(
          width: cardWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Currently Staked',
                style: customTextStyle,
              ),
              Obx(
                () => Text(
                  '${parsedView.toStringAsFixed(4)} ${farm.strStakedSymbol}',
                  style: customTextStyle,
                ),
              ),
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
                style: customTextStyle,
              ),
              Obx(
                () => Text(
                  '${farm.strRewards} $rewardSymbol',
                  style: customTextStyle,
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
                'Total AX available (Staked + Earned)',
                style: customTextStyle,
              ),
              Obx(
                () => Text(
                  '${parsedTotal.toStringAsFixed(2)} $rewardSymbol',
                  style: customTextStyle,
                ),
              )
            ],
          ),
        ),
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
