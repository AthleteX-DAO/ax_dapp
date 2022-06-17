import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:equatable/equatable.dart';
import 'package:ax_dapp/util/BlocStatus.dart';

class AthletePageState extends Equatable {
  final MLBAthleteStats stats;
  final BlocStatus status;

  const AthletePageState(
      {this.status = BlocStatus.initial, MLBAthleteStats? stats})
      : this.stats = stats ??
            const MLBAthleteStats(
                id: 0, name: "", team: "", position: "", statHistory: []);

  AthletePageState copyWith({
    MLBAthleteStats? stats,
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
