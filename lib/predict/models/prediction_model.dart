import 'package:shared/shared.dart';

class PredictionModel extends Equatable {
  const PredictionModel(
      {required this.prompt, required this.details, this.resolution});

  final String prompt;
  final String details;
  final bool? resolution;

  static const empty = PredictionModel(
    prompt: 'Did you predict this could happen?',
    details:
        "Lol, You're not supposed to be here.  Do me a favor and click on 'Predict' on the top left of your screen",
  );
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
