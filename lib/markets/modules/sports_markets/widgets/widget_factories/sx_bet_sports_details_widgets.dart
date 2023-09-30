import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class SXBetSportsDetailsWidget implements SportsDetailsWidget {
  const SXBetSportsDetailsWidget(this.sportsMarketsModel);

  final SportsMarketsModel sportsMarketsModel;

  @override
  Widget sportsDetailsCardsForMobile(bool showIcon, double athNameBx) {
    // TODO: implement sportsDetailsCardsForMobile
    throw UnimplementedError();
  }

  @override
  Widget sportsDetailsCardsForWeb(bool team, double _width) {
    // TODO: implement sportsDetailsCardsForWeb
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
          width: _width * 0.1,
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
              Text(
                sportsMarketsModel.id as String,
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
