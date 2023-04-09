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
  const AddAptToTeam({required this.apt});

  final DraftApt apt;

  @override
  List<Object> get props => [apt];
}

class RemoveAptFromTeam extends LeagueDraftEvent {
  const RemoveAptFromTeam({required this.apt});

  final DraftApt apt;

  @override
  List<Object> get props => [apt];
}

class ConfirmTeam extends LeagueDraftEvent {
  const ConfirmTeam({required this.walletAddress, required this.myTeam});

  final String walletAddress;
  final List<DraftApt> myTeam;

  @override
  List<Object> get props => [walletAddress, myTeam];
}

class GetAthletes extends LeagueDraftEvent {
  const GetAthletes({required this.athletes});

  final List<AthleteScoutModel> athletes;

  @override
  List<Object> get props => [athletes];
}
