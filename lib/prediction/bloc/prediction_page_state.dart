part of 'prediction_page_bloc.dart';

class PredictionPageState extends Equatable {
  const PredictionPageState({
    this.status = BlocStatus.initial,
    this.predictionModel = PredictionModel.empty,
    this.yesAddress = '',
    this.noAddress = '',
  });

  final BlocStatus status;
  final PredictionModel predictionModel;
  final String yesAddress;
  final String noAddress;

  PredictionPageState copyWith({
    String? yesAddress,
    String? noAddress,
    PredictionModel? predictionModel,
    BlocStatus? status,
  }) {
    return PredictionPageState(
      predictionModel: predictionModel ?? this.predictionModel,
      yesAddress: yesAddress ?? this.yesAddress,
      noAddress: noAddress ?? this.noAddress,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
        predictionModel,
        yesAddress,
        noAddress,
      ];
}
