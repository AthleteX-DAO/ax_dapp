part of 'prediction_page_bloc.dart';

class PredictionPageState extends Equatable {
  const PredictionPageState({
    this.status = BlocStatus.initial,
    this.predictionModel = PredictionModel.empty,
    this.predictionAddress = kEmptyAddress,
  });

  final BlocStatus status;
  final PredictionModel predictionModel;
  final String predictionAddress;

  PredictionPageState copyWith({
    String? predictionAddress,
    PredictionModel? predictionModel,
    required BlocStatus status,
  }) {
    return PredictionPageState(
      predictionAddress: predictionAddress ?? this.predictionAddress,
      predictionModel: predictionModel ?? this.predictionModel,
    );
  }

  @override
  List<Object?> get props => [predictionAddress, status, predictionModel];
}
