import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/PairModel.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:equatable/equatable.dart';


class ScoutPageState extends Equatable {

  final List<AthleteScoutModel> athletes;
  final List<PairModel> pairs;
  final SupportedSport selectedSport;
  final BlocStatus status;

  const ScoutPageState({
    this.status = BlocStatus.initial,
    List<AthleteScoutModel>? athletes,
    List<PairModel>? pairs,
    this.selectedSport = SupportedSport.ALL}) : athletes = athletes ?? const [], pairs = pairs ?? const[];

  @override
  List<Object?> get props => [athletes, pairs];

  ScoutPageState copy({
    List<AthleteScoutModel>? athletes,
    List<PairModel>? pairs,
    SupportedSport? selectedSport,
    BlocStatus? status
  }) {
    return ScoutPageState(
        athletes: athletes ?? this.athletes,
        pairs: pairs ?? this.pairs,
        selectedSport: selectedSport ?? this.selectedSport,
        status: status ?? BlocStatus.initial
    );
  }
}