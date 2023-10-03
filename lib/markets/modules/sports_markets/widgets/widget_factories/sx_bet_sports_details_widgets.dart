import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class SXBetSportsDetailsWidget implements SportsDetailsWidget {
  const SXBetSportsDetailsWidget({
    required this.sportsMarketsModel,
  });

  final SportsMarketsModel sportsMarketsModel;

  @override
  Widget sportsDetailsCardsForMobile(bool showIcon, double athNameBx) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Icon(
            Icons.trending_up_rounded,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(
          width: athNameBx,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sportsMarketsModel.name,
                style: textStyle(
                  Colors.white,
                  16,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                'Line: ${sportsMarketsModel.line}',
                style: textStyle(
                  Colors.grey[700]!,
                  10,
                  isBold: false,
                  isUline: false,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget sportsDetailsCardsForWeb(bool team, double _width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 50,
          child: ImageIcon(
            AssetImage('assets/images/SX_Small.png'),
          ),
        ),
        SizedBox(
          width: _width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sportsMarketsModel.name,
                style: textStyle(
                  Colors.white,
                  18,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget sportsPageDetails() {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Details',
              style: textStyle(
                Colors.white,
                24,
                isBold: false,
                isUline: false,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget sportsPageKeyStatistics() {
    // TODO: implement sportsPageKeyStatistics
    throw UnimplementedError();
  }

  @override
  Widget sportsPageKeyStatisticsForMobile() {
    // TODO: implement sportsPageKeyStatisticsForMobile
    throw UnimplementedError();
  }
}
