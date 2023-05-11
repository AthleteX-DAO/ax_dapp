part of 'prediction_page_bloc.dart';

class PredictionPageState extends Equatable {
  const PredictionPageState({
    this.status = BlocStatus.initial,
    this.predictionModel = PredictionModel.empty,
  });

  final BlocStatus status;
  final PredictionModel predictionModel;

  PredictionPageState copyWith({
    String? predictionAddress,
    PredictionModel? predictionModel,
    required BlocStatus status,
  }) {
    return PredictionPageState(
      predictionModel: predictionModel ?? this.predictionModel,
    );
  }

  @override
  List<Object?> get props => [status, predictionModel];
}
