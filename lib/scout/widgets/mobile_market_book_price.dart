import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:flutter/material.dart';

class MobileMarketBookPrice extends StatelessWidget {
  const MobileMarketBookPrice({
    required this.marketVsBookPriceIndex,
    required this.athlete,
    required this.isLongToken,
    super.key,
  });

  final int marketVsBookPriceIndex;
  final AthleteScoutModel athlete;
  final bool isLongToken;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return IndexedStack(
      index: marketVsBookPriceIndex,
      children: [
        // Market
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  isLongToken
                      ? '${athlete.longTokenPrice!.toStringAsFixed(4)} AX'
                      : '${athlete.shortTokenPrice!.toStringAsFixed(4)} AX',
                  style: textStyle(
                    Colors.white,
                    16,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                Text(
                  isLongToken
                      ? '${athlete.longTokenPrice!.toStringAsFixed(4)} AX'
                      : '${athlete.shortTokenPrice!.toStringAsFixed(4)} AX',
                  style: textStyle(
                    Colors.amberAccent,
                    14,
                    isBold: false,
                    isUline: false,
                  ),
                )
              ],
            ),
            if (_width > 355) ...[
              const SizedBox(width: 10),
              // change
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLongToken
                        ? getPercentageDesc(
                            athlete.longTokenPercentage!,
                          )
                        : getPercentageDesc(
                            athlete.shortTokenPercentage!,
                          ),
                    style: isLongToken
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
                  const SizedBox(
                    height: 26,
                  )
                ],
              ),
            ]
          ],
        ),
        // Book
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  isLongToken
                      ? '${athlete.longTokenBookPrice!.toStringAsFixed(4)} AX'
                      : '${athlete.shortTokenBookPrice!.toStringAsFixed(4)} AX',
                  style: textStyle(
                    Colors.white,
                    16,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                Text(
                  isLongToken
                      ? '${athlete.longTokenBookPriceUsd!.toStringAsFixed(4)} AX'
                      : '${athlete.shortTokenBookPriceUsd!.toStringAsFixed(4)} AX',
                  style: textStyle(
                    Colors.amberAccent,
                    14,
                    isBold: false,
                    isUline: false,
                  ),
                )
              ],
            ),
            if (_width > 355) ...[
              const SizedBox(width: 10),
              // change
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLongToken
                        ? getPercentageDesc(
                            athlete.longTokenBookPricePercent!,
                          )
                        : getPercentageDesc(
                            athlete.shortTokenBookPricePercent!,
                          ),
                    style: isLongToken
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
                  const SizedBox(
                    height: 26,
                  )
                ],
              ),
            ]
          ],
        ),
      ],
    );
  }
}
