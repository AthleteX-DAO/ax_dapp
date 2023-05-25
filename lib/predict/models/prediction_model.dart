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
  });

  final String id;
  final String prompt;
  final String details;
  final bool? resolution;

  final String address;
  final String yesTokenAddress;
  final String noTokenAddress;

  static const empty = PredictionModel(
    id: '',
    prompt: '',
    details: '',
    address: kEmptyAddress,
    yesTokenAddress: '',
    noTokenAddress: '',
  );
  static const generic = PredictionModel(
    id: '',
    prompt: 'Will you win today?',
    details: 'This market will resolve to fo sure yea',
    address: kNullAddress,
    yesTokenAddress: kEmptyAddress,
    noTokenAddress: kEmptyAddress,
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
