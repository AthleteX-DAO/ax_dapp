// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/farm/dialogs/dual_stake_dialog.dart';
import 'package:ax_dapp/pages/farm/dialogs/stake_dialog.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

Widget doubleLogoFarmTitle(
  BuildContext context,
  bool isWeb,
  FarmController farm,
  double cardWidth,
) {
  final _cardWidth = isWeb ? 500.0 : cardWidth;
  return SizedBox(
    width: _cardWidth,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/x.jpg'),
            ),
          ),
        ),
        Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              scale: 0.5,
              image: AssetImage('assets/images/apt.png'),
            ),
          ),
        ),
        Container(width: 5),
        Expanded(
          child: Text(
            '${farm.athlete!} Farm',
            style: textStyle(Colors.white, 16, isBold: false),
          ),
        ),
        Container(
          width: 120,
          height: 35,
          decoration: boxDecoration(
            Colors.amber[600]!,
            100,
            0,
            Colors.amber[600]!,
          ),
          child: TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (BuildContext builderContext) {
                if (farm.athlete == null) {
                  return StakeDialog(
                    context: builderContext,
                    farm: farm,
                    layoutWdt: _cardWidth,
                    isWeb: isWeb,
                  );
                } else {
                  return dualStakeDialog(
                    builderContext,
                    farm,
                    farm.athlete!,
                    _cardWidth,
                    isWeb,
                  );
                }
              },
            ),
            child: Text(
              'Stake',
              style: textStyle(Colors.black, 14, isBold: true),
            ),
          ),
        ),
      ],
    ),
  );
}
