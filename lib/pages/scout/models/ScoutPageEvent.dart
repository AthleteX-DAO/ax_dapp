import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:equatable/equatable.dart';

abstract class ScoutPageEvent extends Equatable {
  const ScoutPageEvent();
  
  @override
  List<Object?> get props => [];
}

class SelectSport extends ScoutPageEvent {
  final SupportedSport selectedSport;

  SelectSport({
    required this.selectedSport,
  });

  @override
  List<Object?> get props => [selectedSport];
}

class OnPageRefresh extends ScoutPageEvent {
  @override
  List<Object?> get props => [];
}

class OnAthleteSearch extends ScoutPageEvent {
  final String searchedName;
  final SupportedSport selectedSport;

  OnAthleteSearch({
    required this.searchedName,
    required this.selectedSport,
  });

  @override
  List<Object?> get props => [searchedName, selectedSport];
}
