import 'package:ax_dapp/athlete_markets/widgets/athlete_view_button.dart';
import 'package:ax_dapp/athlete_markets/widgets/desktop_book_value.dart';
import 'package:ax_dapp/athlete_markets/widgets/desktop_market_value.dart';
import 'package:ax_dapp/athlete_markets/widgets/widget_factories/athlete_details_widget.dart';
import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DesktopAthleteCard extends StatelessWidget {
  const DesktopAthleteCard({
    required this.athlete,
    required this.isLongToken,
    super.key,
  });

  final AthleteScoutModel athlete;
  final bool isLongToken;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                AthleteDetailsWidget(
                  athlete,
                ).athleteDetailsCardsForWeb(
                  _width >= 875,
                  _width,
                ),
                DesktopMarketPrice(
                  athlete: athlete,
                  isLongToken: isLongToken,
                ),
                DesktopBookPrice(
                  athlete: athlete,
                  isLongToken: isLongToken,
                ),
              ],
            ),
            Row(
              children: [
                ScoutBuyButton(
                  athlete: athlete,
                  isLongToken: isLongToken,
                ),
                if (_width >= 1090) ...[
                  const SizedBox(width: 25),
                  Container(
                    width: 100,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.transparent,
                      100,
                      2,
                      Colors.white,
                    ),
                    child: AthleteViewButton(
                      athlete: athlete,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
