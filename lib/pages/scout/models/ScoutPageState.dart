import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:equatable/equatable.dart';


class ScoutPageState extends Equatable {

  final List<AthleteScoutModel> athletes;
  final SupportedSport selectedSport;
  final BlocStatus status;

  const ScoutPageState({
    this.status = BlocStatus.initial,
    List<AthleteScoutModel>? athletes,
    this.selectedSport = SupportedSport.ALL}) : athletes = athletes ?? const [];

  @override
  List<Object?> get props => [athletes];

  ScoutPageState copy({
    List<AthleteScoutModel>? athletes,
    SupportedSport? selectedSport,
    BlocStatus? status
  }) {
    return ScoutPageState(
        athletes: athletes ?? this.athletes,
        selectedSport: selectedSport ?? this.selectedSport,
        status: status ?? BlocStatus.initial
    );
  }
}