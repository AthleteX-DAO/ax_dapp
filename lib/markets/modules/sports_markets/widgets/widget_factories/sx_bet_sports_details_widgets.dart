import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/abbreviation_mappings_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class SXBetSportsDetailsWidget implements SportsDetailsWidget {
  @override
  Widget sportsDetailsCardsForMobile(bool showIcon, double athNameBx) {
    // TODO: implement sportsDetailsCardsForMobile
    throw UnimplementedError();
  }

  @override
  Widget sportsDetailsCardsForWeb(bool team, double _width) {
    // TODO: implement sportsDetailsCardsForWeb
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50,
          child: ImageIcon(
            AssetImage('assets/images/SX_Small.png'),
          ),
        ),
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
