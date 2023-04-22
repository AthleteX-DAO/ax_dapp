part of 'league_bloc.dart';

abstract class LeagueEvent extends Equatable {
  const LeagueEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends LeagueEvent {
  const WatchAppDataChangesStarted();
}

class CreateLeague extends LeagueEvent {
  const CreateLeague({
    required this.name,
    required this.adminWallet,
    required this.dateStart,
    required this.dateEnd,
    required this.teamSize,
    required this.maxTeams,
    required this.entryFee,
    required this.isPrivate,
    required this.isLocked,
    required this.sports,
  });

  final String name;
  final String adminWallet;
  final String dateStart;
  final String dateEnd;
  final int teamSize;
  final int maxTeams;
  final int entryFee;
  final bool isPrivate;
  final bool isLocked;

  final List<SupportedSport> sports;

  @override
  List<Object?> get props => [
        name,
        adminWallet,
        dateStart,
        dateEnd,
        teamSize,
        maxTeams,
        entryFee,
        isPrivate,
        isLocked,
        sports,
      ];
}

class FetchLeagues extends LeagueEvent {}

class SearchLeague extends LeagueEvent {
  const SearchLeague({
    required this.input,
    required this.selectedSport,
  });

  final String input;
  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [input, selectedSport];
}

class SelectedSportChanged extends LeagueEvent {
  const SelectedSportChanged({
    required this.selectedSport,
  });

  final SupportedSport selectedSport;

  @override
  List<Object?> get props => [selectedSport];
}
