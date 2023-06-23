part of 'league_draft_bloc.dart';

abstract class LeagueDraftEvent extends Equatable {
  const LeagueDraftEvent();

  @override
  List<Object> get props => [];
}

class WatchAppDataChangesStarted extends LeagueDraftEvent {
  const WatchAppDataChangesStarted();
}

class FetchAptsOwnedEvent extends LeagueDraftEvent {
  const FetchAptsOwnedEvent({
    required this.athletes,
    required this.leagueTeam,
  });

  final List<AthleteScoutModel> athletes;
  final LeagueTeam leagueTeam;

  @override
  List<Object> get props => [athletes, leagueTeam];
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
    required this.prizePoolAddress,
    required this.entryFee,
  });

  final String walletAddress;
  final String leagueID;
  final List<DraftApt> myTeam;
  final LeagueTeam existingTeam;
  final String prizePoolAddress;
  final int entryFee;

  @override
  List<Object> get props => [
        walletAddress,
        leagueID,
        myTeam,
        existingTeam,
        prizePoolAddress,
        entryFee,
      ];
}
