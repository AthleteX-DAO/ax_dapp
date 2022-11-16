import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:flutter/material.dart';

class DesktopMarketPrice extends StatelessWidget {
  const DesktopMarketPrice({
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
      // width: 175,
      width: _width * 0.18 > 175 ? _width * 0.18 : 175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
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
              Container(width: 10),
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
            ],
          ),
          Text(
            isLongToken
                ? r'$' +
                    athlete.longTokenPriceUsd!.toStringAsFixed(
                      4,
                    )
                : '\$${athlete.shortTokenPriceUsd!.toStringAsFixed(4)}',
            style: textStyle(
              Colors.amberAccent,
              14,
              isBold: false,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }
}
