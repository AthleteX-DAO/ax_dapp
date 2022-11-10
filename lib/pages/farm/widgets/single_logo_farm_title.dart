import 'package:ax_dapp/pages/farm/dialogs/dialogs.dart';
import 'package:ax_dapp/pages/farm/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleLogoFarmTitle extends StatelessWidget {
  const SingleLogoFarmTitle({
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
    return SizedBox(
      width: cardWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Expanded(
            child: farm.athlete == null
                ? SportToken(sport: farm.sport, symbol: '${farm.strName} Farm')
                : SportToken(
                    sport: farm.sport,
                    symbol: '${farm.athlete!} Farm',
                  ),
          ),
          Container(width: 10),
          Container(
            width: 110,
            height: 35,
            decoration: boxDecoration(
              Colors.amber[600]!,
              100,
              0,
              Colors.amber[600]!,
            ),
            child: TextButton(
              onPressed: () {
                final isWalletConnected =
                    context.read<WalletBloc>().state.isWalletConnected;
                if (isWalletConnected) {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext builderContext) => StakeDialog(
                      context: builderContext,
                      farm: farm,
                      layoutWdt: cardWidth,
                      isWeb: isWeb,
                    ),
                  );
                } else {
                  context.showWalletWarningToast();
                }
              },
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
