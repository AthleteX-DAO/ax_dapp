part of 'scout_page_bloc.dart';

abstract class ScoutPageEvent extends Equatable {
  const ScoutPageEvent();

  @override
  List<Object?> get props => [];
}

class SelectSport extends ScoutPageEvent {
  const SelectSport({
    required this.selectedSport,
  });

  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [selectedSport];
}

class OnPageRefresh extends ScoutPageEvent {}

class OnAthleteSearch extends ScoutPageEvent {
  const OnAthleteSearch({
    required this.searchedName,
    required this.selectedSport,
  });

  final String searchedName;
  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [searchedName, selectedSport];
}
