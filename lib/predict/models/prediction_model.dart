import 'package:shared/shared.dart';

class PredictionModel extends Equatable {
  const PredictionModel(
      {required this.prompt, required this.details, this.resolution});

  final String prompt;
  final String details;
  final bool? resolution;

  static const empty = PredictionModel(prompt: "nothing", details: "details");
  static const generic = PredictionModel(
    prompt: 'Will you win today?',
    details: 'This market will resolve to fuck yea',
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
