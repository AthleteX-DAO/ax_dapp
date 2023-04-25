import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:shared/shared.dart';

class EventMarketPredictionModel extends PredictionModel {
  const EventMarketPredictionModel(
    this.longTokenAddress,
    this.shortTokenAddress, {
    required this.address,
  }) : super(prompt: '', details: '');

  final String address;
  final String? longTokenAddress;
  final String? shortTokenAddress;
}
