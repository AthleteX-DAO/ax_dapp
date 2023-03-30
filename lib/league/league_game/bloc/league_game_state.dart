part of 'league_game_bloc.dart';

class LeagueGameState extends Equatable {
  const LeagueGameState({
    this.status = BlocStatus.initial,
    this.athletes = const [],
    this.userTeams = const [],
    this.rosters = const {},
  });

  final BlocStatus status;
  final List<AthleteScoutModel> athletes;
  final List<UserTeam> userTeams;
  final Map<String, Map<String, double>> rosters;

  LeagueGameState copyWith({
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
    List<UserTeam>? userTeams,
    Map<String, Map<String, double>>? rosters,
  }) {
    return LeagueGameState(
      status: status ?? this.status,
      athletes: athletes ?? this.athletes,
      userTeams: userTeams ?? this.userTeams,
      rosters: rosters ?? this.rosters,
    );
  }

  @override
  List<Object> get props => [
        status,
        athletes,
        userTeams,
        rosters,
      ];
}
