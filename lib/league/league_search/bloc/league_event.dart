part of 'league_bloc.dart';

abstract class LeagueEvent extends Equatable {
  const LeagueEvent();

  @override
  List<Object?> get props => [];
}

class CreateLeague extends LeagueEvent {
  const CreateLeague({
    required this.league,
  });

  final League league;

  @override
  List<Object?> get props => [league];
}

class FetchLeagues extends LeagueEvent {}

class DeleteLeague extends LeagueEvent {
  const DeleteLeague({
    required this.leagueID,
  });

  final String leagueID;

  @override
  List<Object?> get props => [leagueID];
}

class UpdateLeague extends LeagueEvent {
  const UpdateLeague({
    required this.leagueID,
    required this.league,
  });

  final String leagueID;
  final League league;

  @override
  List<Object?> get props => [
        leagueID,
        league,
      ];
}

class UpdateRoster extends LeagueEvent {
  const UpdateRoster({
    required this.leagueID,
    required this.userWallet,
    required this.roster,
  });

  final String leagueID;
  final String userWallet;
  final List<String> roster;

  @override
  List<Object?> get props => [leagueID, userWallet, roster];
}

class EnrollUser extends LeagueEvent {
  const EnrollUser({
    required this.leagueID,
    required this.userWallet,
    required this.roster,
  });

  final String leagueID;
  final String userWallet;
  final List<String> roster;

  @override
  List<Object?> get props => [leagueID, userWallet, roster];
}

class RemoveUser extends LeagueEvent {
  const RemoveUser({
    required this.leagueID,
    required this.userWallet,
  });

  final String leagueID;
  final String userWallet;

  @override
  List<Object?> get props => [leagueID, userWallet];
}

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