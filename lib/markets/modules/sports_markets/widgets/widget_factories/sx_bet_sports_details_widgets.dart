import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
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
    final _height = MediaQuery.of(context).size.height;
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
              )
            ],
          ),
        )
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
              )
            ],
          ),
        )
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
            primaryOrangeColor.withOpacity(0.6),
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
                  )
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
                  )
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text(''), Text(''), Text('')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 128, 96, 0),
                          ),
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      )
                    ],
                  )
                ],
              )
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
          )
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
          )
        ],
      ),
    );
  }
}
