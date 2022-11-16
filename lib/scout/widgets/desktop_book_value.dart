import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:flutter/material.dart';

class DesktopBookPrice extends StatelessWidget {
  const DesktopBookPrice({
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
                    ? '${athlete.longTokenBookPrice!.toStringAsFixed(4)} AX'
                    : '${athlete.shortTokenBookPrice!.toStringAsFixed(4)}AX',
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
            ],
          ),
          Text(
            isLongToken
                ? '\$${athlete.longTokenBookPriceUsd!.toStringAsFixed(4)}'
                : '\$${athlete.shortTokenBookPriceUsd!.toStringAsFixed(4)}',
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
