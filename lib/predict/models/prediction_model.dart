import 'package:ethereum_api/tokens_api.dart';
import 'package:shared/shared.dart';

class PredictionModel extends Equatable {
  const PredictionModel({
    required this.id,
    required this.prompt,
    required this.details,
    required this.address,
    this.resolution,
    required this.yesTokenAddress,
    required this.noTokenAddress,
    required this.yesName,
    required this.noName,
  });

  final String id;
  final String prompt;
  final String details;
  final bool? resolution;
  final String address;
  final String yesTokenAddress;
  final String noTokenAddress;
  final String yesName;
  final String noName;

  static const empty = PredictionModel(
    id: '',
    prompt: '',
    details: '',
    address: kEmptyAddress,
    yesTokenAddress: '',
    noTokenAddress: '',
    yesName: '',
    noName: '',
  );

  @override
  List<Object?> get props => [
        id,
        prompt,
        details,
        address,
        yesTokenAddress,
        noTokenAddress,
        resolution,
        yesName,
        noName,
      ];

  @override
  String toString() =>
      'PredictModel(prompt: $prompt, details: $details, resolution: $resolution)';
}
