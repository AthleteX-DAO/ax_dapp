part of 'league_game_bloc.dart';

abstract class LeagueGameEvent extends Equatable {
  const LeagueGameEvent();

  @override
  List<Object?> get props => [];
}

class InviteEvent extends LeagueGameEvent {}

class EditTeamsEvent extends LeagueGameEvent {}

class ClaimPrizeEvent extends LeagueGameEvent {}

class TimerEvent extends LeagueGameEvent {
  const TimerEvent({
    required this.startDate,
    required this.endDate,
  });

  final String startDate;
  final String endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

class CalculateAppreciationEvent extends LeagueGameEvent {}

class JoinLeagueEvent extends LeagueGameEvent {}

class LeaveLeagueEvent extends LeagueGameEvent {}
