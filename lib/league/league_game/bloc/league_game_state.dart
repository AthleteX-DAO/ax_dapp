part of 'league_game_bloc.dart';

class LeagueGameState extends Equatable {
  const LeagueGameState({
    this.status = BlocStatus.initial,
    this.athletes = const [],
    this.userTeams = const [],
  });

  final BlocStatus status;
  final List<AthleteScoutModel> athletes;
  final List<UserTeam> userTeams;
  
  LeagueGameState copyWith({
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
    List<UserTeam>? userTeams,
  }) {
    return LeagueGameState(
      status: status ?? this.status,
      athletes: athletes ?? this.athletes,
      userTeams: userTeams ?? this.userTeams,
    );
  }

  @override
  List<Object> get props => [
        status,
        athletes,
        userTeams,
      ];
}
