part of 'scout_page_bloc.dart';

abstract class ScoutPageEvent extends Equatable {
  const ScoutPageEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends ScoutPageEvent {
  const WatchAppDataChangesStarted();
}

class SelectedSportChanged extends ScoutPageEvent {
  const SelectedSportChanged({
    required this.selectedSport,
  });

  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [selectedSport];
}

class FetchScoutInfoRequested extends ScoutPageEvent {}

class AthleteSearchChanged extends ScoutPageEvent {
  const AthleteSearchChanged({
    required this.searchedName,
    required this.selectedSport,
  });

  final String searchedName;
  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [searchedName, selectedSport];
}
