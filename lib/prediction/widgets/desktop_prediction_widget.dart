import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:flutter/material.dart';

abstract class PredictionDetailsWidget {
  factory PredictionDetailsWidget() {
    return NoPredictionsShowWidget();
  }
}

class PredictionsDetailsWidget implements PredictionDetailsWidget {}

class NoPredictionsShowWidget implements PredictionDetailsWidget {
  Widget predictionPageDetails() {
    return const Center(child: Text('no predictions are available for prompt'));
  }
}
