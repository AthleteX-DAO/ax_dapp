import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:equatable/equatable.dart';

enum SelectedSport { ALL, NFL, MLB }
enum Status { initial, success, error, loading }


class ScoutPageState extends Equatable {

  final List<AthleteScoutModel> athletes;
  final SelectedSport selectedSport;
  final Status status;

  const ScoutPageState({
    this.status = Status.initial,
    List<AthleteScoutModel>? athletes,
    this.selectedSport = SelectedSport.ALL}) : athletes = athletes ?? const [];

  @override
  List<Object?> get props => [athletes];

  ScoutPageState copy({
    List<AthleteScoutModel>? athletes,
    SelectedSport? selectedSport,
    Status? status
  }) {
    return ScoutPageState(
        athletes: athletes ?? this.athletes,
        selectedSport: selectedSport ?? this.selectedSport,
        status: status ?? Status.initial
    );
  }
}