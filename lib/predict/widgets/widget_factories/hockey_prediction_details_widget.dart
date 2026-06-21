import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/widget_factories/widget_factories.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class HockeyPredictionsDetailsWidget implements PredictionDetailsWidget {
  const HockeyPredictionsDetailsWidget(this.predictionModel);

  final PredictionModel predictionModel;

  @override
  Widget predictionDetailsCardsForMobile(
    double prdNameBx, {
    required bool showIcon,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (showIcon)
            SizedBox(
              width: 40,
              child: Icon(
                Icons.sports_hockey,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
          SizedBox(
            width: prdNameBx,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  predictionModel.prompt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle(
                    Colors.white,
                    14,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget predictionDetailsCardsForWeb(double _width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50,
          child: Icon(
            Icons.sports_hockey,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(
          width: _width * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                predictionModel.prompt,
                style: textStyle(
                  Colors.white,
                  18,
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
  Widget predictionPageDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        predictionModel.details.isNotEmpty
            ? predictionModel.details
            : 'No additional details available for this market.',
        style: const TextStyle(color: Colors.white70, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget predictionPageKeyStatistics() {
    final stats = _parseKeyStatistics();
    if (stats.isEmpty) {
      return Center(
        child: Text(
          'No key statistics available',
          style: textStyle(
            Colors.grey,
            14,
            isBold: false,
            isUline: false,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: stats.entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: textStyle(
                            Colors.white70,
                            12,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: textStyle(
                            Colors.white,
                            12,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ),)
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget predictionPageKeyStatisticsForMobile() {
    final stats = _parseKeyStatistics();
    if (stats.isEmpty) {
      return Center(
        child: Text(
          'No key statistics available',
          style: textStyle(
            Colors.grey,
            12,
            isBold: false,
            isUline: false,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: stats.entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            entry.key,
                            style: textStyle(
                              Colors.white70,
                              11,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.value,
                          style: textStyle(
                            Colors.white,
                            11,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ),)
              .toList(),
        ),
      ),
    );
  }

  Map<String, String> _parseKeyStatistics() {
    return {
      'League': 'NHL',
      'Game Type': 'Regular Season',
      'Market Type': 'Moneyline',
      'Odds Format': 'Decimal',
    };
  }
}
