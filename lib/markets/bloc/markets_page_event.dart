part of 'markets_page_bloc.dart';

abstract class MarketsPageEvent extends Equatable {
  const MarketsPageEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends MarketsPageEvent {
  const WatchAppDataChangesStarted();
}

class SelectedSportChanged extends MarketsPageEvent {
  const SelectedSportChanged({
    required this.selectedSport,
  });

  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [selectedSport];
}

class SelectedMarketsChanged extends MarketsPageEvent {
  const SelectedMarketsChanged({
    required this.selectedMarkets,
  });

  final SupportedMarkets selectedMarkets;

  @override
  List<Object?> get props => [selectedMarkets];
}

class FetchScoutInfoRequested extends MarketsPageEvent {}

class AthleteSearchChanged extends MarketsPageEvent {
  const AthleteSearchChanged({
    required this.searchedName,
    required this.selectedSport,
  });

  final String searchedName;
  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [searchedName, selectedSport];
}
