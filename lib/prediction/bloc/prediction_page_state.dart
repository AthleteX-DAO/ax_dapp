part of 'prediction_page_bloc.dart';

class PredictionPageState extends Equatable {
  const PredictionPageState({
    this.status = BlocStatus.initial,
    this.predictionModel = PredictionModel.empty,
    this.yesAddress = '',
    this.noAddress = '',
    this.isToggled = false,
  });

  final BlocStatus status;
  final PredictionModel predictionModel;
  final String yesAddress;
  final String noAddress;
  final bool isToggled;

  PredictionPageState copyWith({
    String? yesAddress,
    String? noAddress,
    PredictionModel? predictionModel,
    BlocStatus? status,
    bool? isToggled,
  }) {
    return PredictionPageState(
      predictionModel: predictionModel ?? this.predictionModel,
      yesAddress: yesAddress ?? this.yesAddress,
      noAddress: noAddress ?? this.noAddress,
      status: status ?? this.status,
      isToggled: isToggled ?? this.isToggled,
    );
  }

  @override
  List<Object?> get props => [
        status,
        predictionModel,
        yesAddress,
        noAddress,
        isToggled,
      ];
}
