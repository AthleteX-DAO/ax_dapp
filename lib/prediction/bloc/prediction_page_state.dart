part of 'prediction_page_bloc.dart';

class PredictionPageState extends Equatable {
  const PredictionPageState({
    this.status = BlocStatus.initial,
    this.predictionAddress = kEmptyAddress,
  });

  final BlocStatus status;
  final String predictionAddress;

  PredictionPageState copyWith({
    String? predictionAddress,
    required BlocStatus status,
  }) {
    return PredictionPageState(
      predictionAddress: predictionAddress ?? this.predictionAddress,
    );
  }

  @override
  List<Object?> get props => [predictionAddress, status];
}
