import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DesktopAthlete extends StatelessWidget {
  const DesktopAthlete({
    required this.athlete,
    required this.isLongToken,
    required this.minTeamWidth,
    required this.minViewWidth,
    super.key,
  });

  final AthleteScoutModel athlete;
  final bool isLongToken;
  final double minTeamWidth;
  final double minViewWidth;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          final walletAddress =
              context.read<WalletBloc>().state.formattedWalletAddress;
          context.read<TrackingCubit>().trackAthleteView(
                athleteName: athlete.name,
                walletId: walletAddress,
              );
          context.goNamed(
            'athlete',
            params: {'id': athlete.id.toString() + athlete.name},
          );
        },
        // name, team, market, book, buy, view
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //name, team, market, book
            Row(
              children: <Widget>[
                // name, team
                AthleteDetailsWidget(
                  athlete,
                ).athleteDetailsCardsForWeb(
                  _width >= minTeamWidth,
                  _width,
                ),
                // Market Price / Change
                DesktopMarketPrice(
                  athlete: athlete,
                  isLongToken: isLongToken,
                ),
                // Book Value / Change
                DesktopBookPrice(
                  athlete: athlete,
                  isLongToken: isLongToken,
                ),
              ],
            ),
            // buy, view
            Row(
              children: [
                // Buy
                ScoutBuyButton(
                  athlete: athlete,
                  isLongToken: isLongToken,
                ),
                // view
                if (_width >= minViewWidth) ...[
                  Container(width: 25),
                  Container(
                    width: 100,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.transparent,
                      100,
                      2,
                      Colors.white,
                    ),
                    child: ViewButton(
                      athlete: athlete,
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
