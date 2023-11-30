import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/widget_factories/widget_factories.dart';
import 'package:flutter/material.dart';

class BasketballPredictionsDetailsWidget implements PredictionDetailsWidget {
  const BasketballPredictionsDetailsWidget(this.predictionModel);

  final PredictionModel predictionModel;
  @override
  Widget predictionDetailsCardsForMobile(double prdNameBx, {
    required bool showIcon,
  }) {
    // TODO: implement predictionDetailsCardsForMobile
    throw UnimplementedError();
  }

  @override
  Widget predictionDetailsCardsForWeb(double _width) {
    // TODO: implement predictionDetailsCardsForWeb
    throw UnimplementedError();
  }

  @override
  Widget predictionPageDetails() {
    // TODO: implement predictionPageDetails
    throw UnimplementedError();
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
