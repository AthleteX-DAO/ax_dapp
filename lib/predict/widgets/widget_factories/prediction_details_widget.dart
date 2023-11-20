import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/predict/widgets/widget_factories/widget_factories.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

abstract class PredictionDetailsWidget {
  factory PredictionDetailsWidget(PredictionModel predictionModel) {
    switch (predictionModel.supportedPredictionMarkets) {
      case SupportedPredictionMarkets.College:
        return CollegePredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.Basketball:
        return BasketballPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.Football:
        return FootballPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.Hockey:
        return HockeyPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.Baseball:
        return BaseballPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.Soccer:
        return SoccerPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.Voted:
        return VotedPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.Exotic:
        return ExoticPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.all:
        return NoStatsShownWidget();
    }
  }

  Widget predictionPageDetails();
  Widget predictionPageKeyStatistics();
  Widget predictionPageKeyStatisticsForMobile();
  Widget predictionDetailsCardsForWeb(
    double _width,
  );
  Widget predictionDetailsCardsForMobile(
    bool showIcon,
    double prdNameBx,
  );
}

class NoStatsShownWidget implements PredictionDetailsWidget {
  @override
  Widget predictionDetailsCardsForMobile(bool showIcon, double prdNameBx) {
    return const Center(
      child: Text(''),
    );
  }

  @override
  Widget predictionDetailsCardsForWeb(double _width) {
    return const Center(
      child: Text('No info shown for Prediction Card'),
    );
  }

  @override
  Widget predictionPageDetails() {
    return const Center(
      child: Text('No details for selected prediction'),
    );
  }

  @override
  Widget predictionPageKeyStatistics() {
    return const Center(
      child: Text('No statistics shown for selected prediction'),
    );
  }

  @override
  Widget predictionPageKeyStatisticsForMobile() {
    return const Center(
      child: Text('No statistics shown for selected prediction'),
    );
  }
}
