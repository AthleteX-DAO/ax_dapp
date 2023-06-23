part of 'prediction_page_bloc.dart';

class PredictionPageState extends Equatable {
  const PredictionPageState({
    this.status = BlocStatus.initial,
    this.predictionModel = PredictionModel.empty,
    this.predictionAddress = '',
  });

  final BlocStatus status;
  final PredictionModel predictionModel;
  final String predictionAddress;

  PredictionPageState copyWith({
    String? predictionAddress,
    PredictionModel? predictionModel,
    BlocStatus? status,
  }) {
    return PredictionPageState(
      predictionModel: predictionModel ?? this.predictionModel,
      predictionAddress: predictionAddress ?? this.predictionAddress,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, predictionModel, predictionAddress];
}
