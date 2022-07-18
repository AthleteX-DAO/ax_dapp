part of 'athlete_page_bloc.dart';

class AthletePageState extends Equatable {
  const AthletePageState({
    required this.stats,
    required this.status,
  });

  factory AthletePageState.initial() {
    return const AthletePageState(stats: [], status: BlocStatus.initial);
  }

  final List<GraphData> stats;
  final BlocStatus status;

  AthletePageState copyWith({
    List<GraphData>? stats,
    BlocStatus? status,
  }) {
    return AthletePageState(
      stats: stats ?? this.stats,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, stats];

  @override
  String toString() => 'AthletePageState(stats: $stats, status: $status)';
}
