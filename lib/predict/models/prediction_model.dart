import 'package:ethereum_api/tokens_api.dart';
import 'package:shared/shared.dart';

class PredictionModel extends Equatable {
  const PredictionModel({
    required this.prompt,
    required this.details,
    required this.address,
    this.resolution,
    this.longTokenAddress,
    this.shortTokenAddress,
  });

  final String prompt;
  final String details;
  final bool? resolution;

  final String address;
  final String? longTokenAddress;
  final String? shortTokenAddress;

  static const empty = PredictionModel(
    prompt: 'Did you predict this could happen?',
    details:
        "Lol, You're not supposed to be here.  Do me a favor and click on 'Predict' on the top left of your screen",
    address: kNullAddress,
  );
  static const generic = PredictionModel(
    prompt: 'Will you win today?',
    details: 'This market will resolve to fuck yea',
    address: kNullAddress,
  );
  @override
  List<Object?> get props => [
        prompt,
        details,
        resolution,
      ];

  @override
  String toString() =>
      'PredictModel(prompt: $prompt, details: $details, resolution: $resolution)';
}
