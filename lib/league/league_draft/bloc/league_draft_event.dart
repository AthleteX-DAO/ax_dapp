part of 'league_draft_bloc.dart';

abstract class LeagueDraftEvent extends Equatable {
  const LeagueDraftEvent();

  @override
  List<Object> get props => [];
}

class FetchAptsOwnedEvent extends LeagueDraftEvent {
  const FetchAptsOwnedEvent({required this.athletes});

  final List<AthleteScoutModel> athletes;

  @override
  List<Object> get props => [athletes];
}

class AddAptToTeam extends LeagueDraftEvent {
  const AddAptToTeam({
    required this.apt,
    required this.teamSize,
  });

  final DraftApt apt;
  final int teamSize;

  @override
  List<Object> get props => [apt, teamSize];
}

class RemoveAptFromTeam extends LeagueDraftEvent {
  const RemoveAptFromTeam({required this.apt});

  final DraftApt apt;

  @override
  List<Object> get props => [apt];
}

class ConfirmTeam extends LeagueDraftEvent {
  const ConfirmTeam({
    required this.walletAddress,
    required this.leagueID,
    required this.myTeam,
    required this.existingTeam,
  });

  final String walletAddress;
  final String leagueID;
  final List<DraftApt> myTeam;
  final LeagueTeam existingTeam;

  @override
  List<Object> get props => [
        walletAddress,
        leagueID,
        myTeam,
        existingTeam,
      ];
}
