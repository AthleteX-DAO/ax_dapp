import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/widgets/widgets.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MobileAthleteContents extends StatefulWidget {
  const MobileAthleteContents({
    required this.athlete,
    required this.marketVsBookPriceIndex,
    required this.isLongToken,
    super.key,
  });

  final AthleteScoutModel athlete;
  final int marketVsBookPriceIndex;
  final bool isLongToken;

  @override
  State<MobileAthleteContents> createState() => _MobileAthleteContentsState();
}

class _MobileAthleteContentsState extends State<MobileAthleteContents> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: 70,
          child: OutlinedButton(
            onPressed: () {
              context.goNamed(
                'athlete',
                params: {
                  'id': widget.athlete.id.toString() + widget.athlete.name
                },
              );
            },
            // contents of each list item
            // name, market/book, buy
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // name, market/book
                Row(
                  children: [
                    //name
                    AthleteDetailsWidget(
                      widget.athlete,
                    ).athleteDetailsCardsForMobile(
                      _width > 290,
                      _width,
                      107,
                    ),
                    SizedBox(width: (constraints.maxWidth >= 320) ? 20 : 5),
                    // Market Price / Change
                    MobileMarketBookPrice(
                      marketVsBookPriceIndex: widget.marketVsBookPriceIndex,
                      athlete: widget.athlete,
                      isLongToken: widget.isLongToken,
                    ),
                  ],
                ),
                // Buy button
                if (constraints.maxWidth > 435)
                  Row(
                    children: <Widget>[
                      Container(
                        width: _width * 0.20,
                        height: 36,
                        decoration: boxDecoration(
                          const Color.fromRGBO(
                            254,
                            197,
                            0,
                            0.2,
                          ),
                          100,
                          0,
                          const Color.fromRGBO(
                            254,
                            197,
                            0,
                            0.2,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            final isWalletDisconnected = context
                                .read<WalletBloc>()
                                .state
                                .isWalletDisconnected;
                            if (isWalletDisconnected) {
                              context.showWalletWarningToast();
                              return;
                            }
                            context.goNamed(
                              'athlete',
                              params: {
                                'id': widget.athlete.id.toString() +
                                    widget.athlete.name
                              },
                            );
                          },
                          child: const BuyText(),
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
