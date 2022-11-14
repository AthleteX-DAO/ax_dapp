import 'package:ax_dapp/pages/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleFarmButton extends StatelessWidget {
  const ToggleFarmButton({
    super.key,
    required this.layoutWidth,
    required this.layoutHeight,
    required TextEditingController myController,
  }) : _farmTextController = myController;

  final double layoutWidth;
  final double layoutHeight;
  final TextEditingController _farmTextController;

  @override
  Widget build(BuildContext context) {
    final isAllFarmsSelection =
        context.select((FarmBloc bloc) => bloc.state.isAllFarms);
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return Container(
      width: isWeb ? 200 : layoutWidth,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: isWeb ? 90 : (layoutWidth / 2) - 5,
            decoration: isAllFarmsSelection
                ? boxDecoration(
                    Colors.grey[600]!,
                    100,
                    0,
                    Colors.transparent,
                  )
                : boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  ),
            child: TextButton(
              onPressed: () {
                if (!isAllFarmsSelection) {
                  _farmTextController.clear();
                  context
                      .read<FarmBloc>()
                      .add(OnChangeFarmTab(isAllFarms: true));
                }
              },
              child: Text(
                'All Farms',
                style: textStyle(
                  Colors.white,
                  16,
                  isBold: true,
                  isUline: false,
                ),
              ),
            ),
          ),
          Container(
            width: isWeb ? 90 : (layoutWidth / 2) - 5,
            decoration: isAllFarmsSelection
                ? boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  )
                : boxDecoration(
                    Colors.grey[600]!,
                    100,
                    0,
                    Colors.transparent,
                  ),
            child: TextButton(
              onPressed: () {
                final isWalletConnected =
                    context.read<WalletBloc>().state.isWalletConnected;
                if (isWalletConnected) {
                  if (isAllFarmsSelection) {
                    _farmTextController.clear();
                    context
                        .read<FarmBloc>()
                        .add(OnChangeFarmTab(isAllFarms: false));
                  }
                } else {
                  context.showWalletWarningToast();
                }
              },
              child: Text(
                'My Farms',
                style:
                    textStyle(Colors.white, 16, isBold: true, isUline: false),
              ),
            ),
          )
        ],
      ),
    );
  }
}