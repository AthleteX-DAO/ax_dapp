part of 'athelete_bloc.dart';

class AthletePageState extends Equatable {
  final List<GraphData> stats;
  final BlocStatus status;
  AthletePageState({
    required this.stats,
    required this.status,
  });

  factory AthletePageState.initial() {
    return AthletePageState(stats: [], status: BlocStatus.initial);
  }

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
