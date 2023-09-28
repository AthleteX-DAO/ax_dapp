import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewButton extends StatelessWidget {
  const ViewButton({
    required this.sports,
    super.key,
  });

  final SportsMarketsModel sports;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final walletAddress =
            context.read<WalletBloc>().state.formattedWalletAddress;
        context.read<TrackingCubit>().trackAthleteView(
              athleteName: sports.name,
              walletId: walletAddress,
            );
        context.goNamed(
          'sport',
          params: {'id': sports.id.toString() + sports.name},
        );
      },
      child: SizedBox(
        width: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'View',
              style: textStyle(
                Colors.white,
                16,
                isBold: false,
                isUline: false,
              ),
            ),
            const Icon(
              Icons.arrow_right,
              size: 25,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}