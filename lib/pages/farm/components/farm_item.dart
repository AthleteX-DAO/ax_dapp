// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/farm/components/single_logo_farm_title.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/page_text_style.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget farmItem(
  BuildContext context,
  bool isWeb,
  FarmController farm,
  double listHeight,
  double layoutWdt,
) {
  const minCardHeight = 200.0;
  const maxCardHeight = 350.0;
  final cardWidth = isWeb ? 500.0 : layoutWdt;
  var cardHeight = listHeight * 0.4;
  if (cardHeight < minCardHeight) cardHeight = minCardHeight;
  if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

  final txStyle = textStyle(Colors.grey[600]!, 14, false, false);
  Widget farmTitleWidget;
  farmTitleWidget = singleLogoFarmTitle(context, isWeb, farm, cardWidth);

  return Container(
    height: cardHeight,
    width: cardWidth,
    margin: isWeb
        ? const EdgeInsets.symmetric(horizontal: 5, vertical: 5)
        : const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: boxDecoration(
      const Color(0x80424242).withOpacity(0.25),
      20,
      1,
      Colors.grey[600]!,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        // TVL
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TVL',
              style: txStyle,
            ),
            Text('\$${farm.strTVL}', style: txStyle)
          ],
        ),
        // Total APY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total APR', style: txStyle),
            Text('${farm.strAPR}%', style: txStyle)
          ],
        ),
      ],
    ),
  );
}
