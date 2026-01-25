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
    // TODO: implement predictionDetailsCardsForMobile
    throw UnimplementedError();
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
    // TODO: implement predictionPageKeyStatistics
    throw UnimplementedError();
  }

  @override
  Widget predictionPageKeyStatisticsForMobile() {
    // TODO: implement predictionPageKeyStatisticsForMobile
    throw UnimplementedError();
  }
}
