import 'package:ax_dapp/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/athlete/widgets/widgets.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/widgets/widget_factories/widget_factories.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/util/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class StatsSide extends StatelessWidget {
  const StatsSide({super.key, required this.athlete});

  final AthleteScoutModel athlete;

  @override
  Widget build(BuildContext context) {
    var longCurrentBookValueRatio =
        (athlete.longTokenPrice! / athlete.longTokenBookPrice!) * 100;
    var shortCurrentBookValueRatio =
        (athlete.shortTokenPrice! / athlete.shortTokenBookPrice!) * 100;
    if (longCurrentBookValueRatio.isNaN ||
        longCurrentBookValueRatio.isInfinite) {
      longCurrentBookValueRatio = 0;
    }
    if (shortCurrentBookValueRatio.isNaN ||
        shortCurrentBookValueRatio.isInfinite) {
      shortCurrentBookValueRatio = 0;
    }
    final _width = MediaQuery.of(context).size.width;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    return Container(
      width: wid,
      height: 580,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price Overview section
          SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price Overview',
                      style: textStyle(
                        Colors.white,
                        24,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      height: 20,
                      child: BlocSelector<AthletePageBloc, AthletePageState,
                          String>(
                        selector: (state) => state.selectedAptAddress,
                        builder: (context, selectedAptAddress) {
                          return FutureBuilder<String>(
                            future:
                                context.read<TokensRepository>().getTokenSymbol(
                                      selectedAptAddress,
                                    ),
                            builder: (context, snapshot) {
                              //Check API response data
                              if (snapshot.hasError) {
                                // can't get symbol
                                return const TickerSymbol(symbol: '---');
                              } else if (snapshot.hasData) {
                                // got the balance
                                return TickerSymbol(symbol: snapshot.data!);
                              } else {
                                // loading
                                return const Loader(dimension: 10);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Current',
                        style: textStyle(
                          greyTextColor,
                          14,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    // TODO(anyone): get the all time high book value and \
                    // market value prices
                    // Container(
                    //     alignment: Alignment.bottomRight,
                    //     child: Text("All-Time High",
                    //         style: textStyle(greyTextColor,
                    //             14, false, false)))
                  ],
                ),
                Divider(thickness: 1, color: greyTextColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Market Price',
                      style: textStyle(
                        greyTextColor,
                        20,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: BlocSelector<AthletePageBloc, AthletePageState,
                          AptType>(
                        selector: (state) => state.aptTypeSelection,
                        builder: (context, aptTypeSelection) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                aptTypeSelection.isLong
                                    ? '''${athlete.longTokenPrice!.toStringAsFixed(2)} AX'''
                                    : '''${athlete.shortTokenPrice!.toStringAsFixed(2)} AX''',
                                style: textStyle(
                                  Colors.white,
                                  14,
                                  isBold: false,
                                  isUline: false,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 2),
                                child: Text(
                                  aptTypeSelection.isLong
                                      ? getPercentageDesc(
                                          athlete.longTokenPercentage!,
                                        )
                                      : getPercentageDesc(
                                          athlete.shortTokenPercentage!,
                                        ),
                                  style: aptTypeSelection.isLong
                                      ? textStyle(
                                          getPercentageColor(
                                            athlete.longTokenPercentage!,
                                          ),
                                          12,
                                          isBold: false,
                                          isUline: false,
                                        )
                                      : textStyle(
                                          getPercentageColor(
                                            athlete.shortTokenPercentage!,
                                          ),
                                          12,
                                          isBold: false,
                                          isUline: false,
                                        ),
                                ),
                              ),
                              // TODO(anyone): get the all time high book value
                              // and
                              // market value prices
                              // Text("4.24 AX",
                              //     style: textStyle(greyTextColor, 14,
                              //         false, false))
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Book Value',
                      style: textStyle(
                        greyTextColor,
                        20,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    BlocSelector<AthletePageBloc, AthletePageState, AptType>(
                      selector: (state) => state.aptTypeSelection,
                      builder: (context, aptTypeSelection) {
                        return Row(
                          children: [
                            Text(
                              aptTypeSelection.isLong
                                  ? '''${athlete.longTokenBookPrice!.toStringAsFixed(2)} AX'''
                                  : '''${athlete.shortTokenBookPrice!.toStringAsFixed(2)} AX''',
                              style: textStyle(
                                Colors.white,
                                14,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            Text(
                              aptTypeSelection.isLong
                                  ? getPercentageDesc(
                                      athlete.longTokenBookPricePercent!,
                                    )
                                  : getPercentageDesc(
                                      athlete.shortTokenBookPricePercent!,
                                    ),
                              style: aptTypeSelection.isLong
                                  ? textStyle(
                                      getPercentageColor(
                                        athlete.longTokenBookPricePercent!,
                                      ),
                                      12,
                                      isBold: false,
                                      isUline: false,
                                    )
                                  : textStyle(
                                      getPercentageColor(
                                        athlete.shortTokenBookPricePercent!,
                                      ),
                                      12,
                                      isBold: false,
                                      isUline: false,
                                    ),
                            ),
                            // TODO(anyone): get the all time high book value
                            // and market value prices
                            // Text(shortBookValue, style: textStyle
                            // (greyTextColor, 14, false, false))
                          ],
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MP:BV Ratio',
                      style: textStyle(
                        greyTextColor,
                        20,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    BlocSelector<AthletePageBloc, AthletePageState, AptType>(
                      selector: (state) => state.aptTypeSelection,
                      builder: (context, aptTypeSelection) {
                        return Text(
                          '''${aptTypeSelection.isLong ? longCurrentBookValueRatio.toStringAsFixed(2) : shortCurrentBookValueRatio.toStringAsFixed(2)}%''',
                          style: textStyle(
                            greyTextColor,
                            16,
                            isBold: false,
                            isUline: false,
                          ),
                        );
                      },
                    ),
                    // TODO(anyone): get the all time high book value and
                    // market value prices
                    // Container(
                    //   child: Text("120%", style: textStyle(greyTextColor, 16,
                    //false, false)),),
                  ],
                ),
              ],
            ),
          ),
          // Detail Section
          AthleteDetailsWidget(athlete).athletePageDetails(),
          // Stats section
          if (_width < 900)
            AthleteDetailsWidget(athlete).athletePageKeyStatisticsForMobile()
          else
            AthleteDetailsWidget(athlete).athletePageKeyStatistics(),
        ],
      ),
    );
  }
}
