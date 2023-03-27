part of 'league_game_bloc.dart';

class LeagueGameState extends Equatable {
  const LeagueGameState({
    this.status = BlocStatus.initial,
    this.athletes = const [],
  });

  final BlocStatus status;
  final List<AthleteScoutModel> athletes;
  
  LeagueGameState copyWith({
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
  }) {
    return LeagueGameState(
      status: status ?? this.status,
      athletes: athletes ?? this.athletes,
    );
  }

  @override
  List<Object> get props => [
        status,
        athletes,
      ];
}
