part of 'prediction_page_bloc.dart';

class PredictionPageState extends Equatable {
  const PredictionPageState({
    this.status = BlocStatus.initial,
    this.aptTypeSelection = AptType.long,
    this.predictionModel = PredictionModel.empty,
    this.stats = const [],
    this.yesAddress = '',
    this.noAddress = '',
    this.isToggled = false,
  });

  final BlocStatus status;
  final AptType aptTypeSelection;
  final PredictionModel predictionModel;
  final List<GraphData> stats;
  final String yesAddress;
  final String noAddress;
  final bool isToggled;

  PredictionPageState copyWith({
    String? yesAddress,
    String? noAddress,
    AptType? aptTypeSelection,
    PredictionModel? predictionModel,
    List<GraphData>? stats,
    BlocStatus? status,
    bool? isToggled,
  }) {
    return PredictionPageState(
      predictionModel: predictionModel ?? this.predictionModel,
      aptTypeSelection: aptTypeSelection ?? this.aptTypeSelection,
      yesAddress: yesAddress ?? this.yesAddress,
      noAddress: noAddress ?? this.noAddress,
      status: status ?? this.status,
      stats: stats ?? this.stats,
      isToggled: isToggled ?? this.isToggled,
    );
  }

  @override
  List<Object?> get props => [
        status,
        aptTypeSelection,
        predictionModel,
        yesAddress,
        noAddress,
        stats,
        isToggled,
      ];
}
