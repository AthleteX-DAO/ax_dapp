import 'package:shared/shared.dart';

class PredictionModel extends Equatable {
  const PredictionModel({this.prompt, this.details, this.resolution});

  final String? prompt;
  final String? details;
  final bool? resolution;

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
