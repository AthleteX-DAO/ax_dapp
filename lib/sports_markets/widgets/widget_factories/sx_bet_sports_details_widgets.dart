import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/widgets/widget_factories/sports_details_widget.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class SXBetSportsDetailsWidget implements SportsDetailsWidget {
  const SXBetSportsDetailsWidget({
    required this.sportsMarketsModel,
    required this.context,
  });

  final BuildContext context;
  final SportsMarketsModel sportsMarketsModel;

  @override
  Widget sportsDetailsCardsForMobile(bool showIcon, double athNameBx) {
    final _width = MediaQuery.of(context).size.width;
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
          width: _width < 768 ? _width * 0.6 : 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sportsMarketsModel.name,
                style: textStyle(
                  Colors.white,
                  13,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                'Sports Market',
                style: textStyle(
                  Colors.grey[700]!,
                  13,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget sportsDetailsCardsForWeb(bool team, double _width) {
    final _width = MediaQuery.of(context).size.width;

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
              Text(
                'Sports Market',
                style: textStyle(
                  Colors.grey[700]!,
                  13,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget sportsPageDetails() {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: _height * 0.85,
          width: _width * 0.9,
          alignment: Alignment.center,
          decoration: boxDecoration(
            primaryOrangeColor.withOpacity(0.75),
            30,
            0.5,
            primaryWhiteColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sportsMarketsModel.name,
                    style: textStyle(
                      Colors.black87,
                      _height * 0.04,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 3,
                color: primaryWhiteColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Spread',
                    style: textStyle(
                      Colors.black,
                      25,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                  Text(
                    'Money Line',
                    style: textStyle(
                      Colors.black,
                      25,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                  Text(
                    'Total',
                    style: textStyle(
                      Colors.black,
                      25,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('$sportsMarketsModel'),
                  Text('${sportsMarketsModel.line}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
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
                          onPressed: () {},
                          child: Text(
                            'Place Bet',
                            style: textStyle(
                              Colors.white70,
                              25,
                              isBold: true,
                              isUline: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget sportsPageKeyStatistics() {
    return SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Key Stats',
                style:
                    textStyle(Colors.white, 24, isBold: false, isUline: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget sportsPageKeyStatisticsForMobile() {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Key Stats',
              style: textStyle(Colors.white, 24, isBold: false, isUline: false),
            ),
          ),
        ],
      ),
    );
  }
}
