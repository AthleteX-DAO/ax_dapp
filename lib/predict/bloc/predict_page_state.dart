part of 'predict_page_bloc.dart';

class PredictPageState extends Equatable {
  const PredictPageState({
    this.status = BlocStatus.initial,
    this.predictions = const [],
  });

  final List<PredictionModel> predictions;

  final BlocStatus status;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
