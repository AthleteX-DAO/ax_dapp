import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/predict/widgets/widget_factories/widget_factories.dart';
import 'package:flutter/material.dart';

abstract class PredictionDetailsWidget {
  factory PredictionDetailsWidget(PredictionModel predictionModel) {
    switch (predictionModel.supportedPredictionMarkets) {
      case SupportedPredictionMarkets.college:
        return CollegePredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.basketball:
        return BasketballPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.football:
        return FootballPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.hockey:
        return HockeyPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.baseball:
        return BaseballPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.soccer:
        return SoccerPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.voted:
        return VotedPredictionsDetailsWidget(predictionModel);
      case SupportedPredictionMarkets.exotic:
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
    double prdNameBx, {
    required bool showIcon,
  });
}

class NoStatsShownWidget implements PredictionDetailsWidget {
  @override
  Widget predictionDetailsCardsForMobile(
    double prdNameBx, {
    required bool showIcon,
  }) {
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
