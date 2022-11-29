import 'package:ax_dapp/pages/farm/dialogs/dialogs.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DoubleLogoFarmTitle extends StatelessWidget {
  const DoubleLogoFarmTitle({
    super.key,
    required this.farm,
    required this.cardWidth,
  });

  final FarmController farm;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
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
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              '${farm.athlete!} Farm',
              style: textStyle(
                Colors.white,
                16,
                isBold: false,
                isUline: false,
              ),
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
                      farm: farm,
                      layoutWdt: _cardWidth,
                    );
                  } else {
                    return DualStakeDialog(
                      selectedFarm: farm,
                      athlete: farm.athlete!,
                      layoutWdt: _cardWidth,
                    );
                  }
                },
              ),
              child: Text(
                'Stake',
                style: textStyle(
                  Colors.black,
                  14,
                  isBold: true,
                  isUline: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
