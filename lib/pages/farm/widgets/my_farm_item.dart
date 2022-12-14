import 'package:ax_dapp/pages/farm/dialogs/dialogs.dart';
import 'package:ax_dapp/pages/farm/widgets/widgets.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MyFarmItem extends StatelessWidget {
  const MyFarmItem({
    super.key,
    required this.farm,
    required this.listHeight,
    required this.layoutWidth,
  });

  final FarmController farm;
  final double listHeight;
  final double layoutWidth;

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    const minCardHeight = 450.0;
    const maxCardHeight = 500.0;
    final cardWidth = isWeb ? (layoutWidth / 4) - 50 : layoutWidth;
    var cardHeight = listHeight * 0.7;
    if (cardHeight < minCardHeight) cardHeight = minCardHeight;
    if (cardHeight > maxCardHeight) cardHeight = maxCardHeight;

    final customTextStyle =
        textStyle(Colors.grey[600]!, 14, isBold: false, isUline: false);
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
          SingleLogoFarmTitle(farm: farm, cardWidth: cardWidth),
          // Current Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
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
                style:
                    textStyle(Colors.white, 20, isBold: false, isUline: false),
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
                    '${farm.stakedInfo.value.viewAmount} ${farm.strStakedSymbol}',
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
                  'Claimable Rewards',
                  style: customTextStyle,
                ),
                Obx(
                  () => Text(
                    '${farm.rewardInfo.value.viewAmount} $rewardSymbol',
                    style: customTextStyle,
                  ),
                )
              ],
            ),
          ),
          // we will add this feature in the future
          // SizedBox(
          //   width: cardWidth,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Total AX available (Staked + Earned)',
          //         style: customTextStyle,
          //       ),
          //       Obx(
          //         () => Text(
          //           '${parsedTotal.toStringAsFixed(2)} $rewardSymbol',
          //           style: customTextStyle,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
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
                    onPressed: () async {
                      final walletAddress = context
                          .read<WalletBloc>()
                          .state
                          .formattedWalletAddress;
                      context.read<TrackingCubit>().onPressedClaimRewards(
                            tickerPair: farm.athlete == null
                                ? farm.strName
                                : farm.athlete!,
                            tickerPairName: farm.strStakedAlias.value.isNotEmpty
                                ? farm.strStakedAlias.value
                                : farm.strStakedSymbol.value,
                            walletId: walletAddress,
                          );
                      await farm.claim().then((value) {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              const TransactionStatusDialog(
                            title: 'Rewards Claimed',
                            icons: Icons.check_circle_outline,
                          ),
                        );
                        context.read<TrackingCubit>().onClaimRewardsSuccess(
                              tickerPair: farm.athlete == null
                                  ? farm.strName
                                  : farm.athlete!,
                              tickerPairName:
                                  farm.strStakedAlias.value.isNotEmpty
                                      ? farm.strStakedAlias.value
                                      : farm.strStakedSymbol.value,
                              walletId: walletAddress,
                            );
                      }).catchError((error) {
                        showDialog<void>(
                          context: context,
                          builder: (context) => const FailedDialog(),
                        );
                      });
                    },
                    child: Text(
                      'Claim Rewards',
                      style: textStyle(
                        Colors.black,
                        14,
                        isBold: true,
                        isUline: false,
                      ),
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
                      builder: (BuildContext builderContext) => UnstakeDialog(
                        farm: farm,
                        layoutWdt: cardWidth,
                      ),
                    ),
                    child: Text(
                      'Unstake Liquidity',
                      style: textStyle(
                        Colors.amber[600]!,
                        14,
                        isBold: true,
                        isUline: false,
                      ),
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
}
