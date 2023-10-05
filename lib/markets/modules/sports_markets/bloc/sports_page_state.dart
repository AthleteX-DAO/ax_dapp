part of 'sports_page_bloc.dart';

class SportsPageState extends Equatable {
  const SportsPageState({
    this.status = BlocStatus.initial,
    this.failure = Failure.none,
  });

  final BlocStatus status;
  final Failure failure;

  SportsPageState copyWith({
    BlocStatus? status,
  }) {
    return SportsPageState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}
