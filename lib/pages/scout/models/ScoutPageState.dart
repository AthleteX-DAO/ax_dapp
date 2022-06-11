import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:equatable/equatable.dart';

class ScoutPageState extends Equatable {
  final List<AthleteScoutModel> athletes;
  final List<AthleteScoutModel> filteredAthletes;
  final SupportedSport selectedSport;
  final BlocStatus status;
  ScoutPageState({
    required this.athletes,
    required this.filteredAthletes,
    required this.selectedSport,
    required this.status,
  });

  factory ScoutPageState.initial() {
    return ScoutPageState(athletes: [], filteredAthletes: [], status: BlocStatus.initial, selectedSport: SupportedSport.ALL);
  }

  ScoutPageState copyWith({
    List<AthleteScoutModel>? filteredAthletes,
    SupportedSport? selectedSport,
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
  }) {
    return ScoutPageState(
      athletes: athletes ?? this.athletes,
      filteredAthletes: filteredAthletes ?? this.filteredAthletes,
      status: status ?? this.status,
      selectedSport: selectedSport ?? this.selectedSport,
    );
  }

  @override
  List<Object> get props => [athletes, filteredAthletes, selectedSport, status];

  @override
  String toString() => 'ScoutPageState(cards: $athletes, status: $status, filteredAthletes: $filteredAthletes, selectedSport: $selectedSport)';
}
