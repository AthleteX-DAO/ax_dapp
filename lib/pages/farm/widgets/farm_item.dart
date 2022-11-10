import 'package:ax_dapp/pages/farm/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FarmItem extends StatelessWidget {
  const FarmItem({
    super.key,
    required this.farm,
    required this.listHeight,
    required this.layoutWdt,
  });

  final FarmController farm;
  final double listHeight;
  final double layoutWdt;

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    const minCardHeight = 200.0;
    const maxCardHeight = 350.0;
    final cardWidth = isWeb ? 500.0 : layoutWdt;
    var cardHeight = listHeight * 0.4;
    if (cardHeight < minCardHeight) cardHeight = minCardHeight;
    if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

    final txStyle =
        textStyle(Colors.grey[600]!, 14, isBold: false, isUline: false);
    Widget farmTitleWidget;
    farmTitleWidget = SingleLogoFarmTitle(farm: farm, cardWidth: cardWidth);

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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          height: cardHeight,
          width: cardWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              farmTitleWidget,
              // Current Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Balance',
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
        ),
      ),
    );
  }
}
