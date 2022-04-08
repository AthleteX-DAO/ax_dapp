import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:equatable/equatable.dart';

enum Status { initial, success, error, loading }


class ScoutPageState extends Equatable {

  final List<AthleteScoutModel> athletes;
  final SupportedSport selectedSport;
  final Status status;

  const ScoutPageState({
    this.status = Status.initial,
    List<AthleteScoutModel>? athletes,
    this.selectedSport = SupportedSport.ALL}) : athletes = athletes ?? const [];

  @override
  List<Object?> get props => [athletes];

  ScoutPageState copy({
    List<AthleteScoutModel>? athletes,
    SupportedSport? selectedSport,
    Status? status
  }) {
    return ScoutPageState(
        athletes: athletes ?? this.athletes,
        selectedSport: selectedSport ?? this.selectedSport,
        status: status ?? Status.initial
    );
  }
}