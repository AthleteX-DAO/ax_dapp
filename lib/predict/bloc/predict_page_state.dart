part of 'predict_page_bloc.dart';

class PredictPageState extends Equatable {
  const PredictPageState({
    this.status = BlocStatus.initial,
    this.predictions = const [],
  });

  final List<PredictionModel> predictions;

  final BlocStatus status;

  PredictPageState copyWith({
    List<PredictionModel>? predictions,
    BlocStatus? status,
  }) {
    return PredictPageState(
      predictions: predictions ?? this.predictions,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [predictions, status];
}
