part of 'league_game_bloc.dart';

abstract class LeagueGameState extends Equatable {
  const LeagueGameState();
  
  @override
  List<Object> get props => [];
}

class LeagueGameInitial extends LeagueGameState {}
