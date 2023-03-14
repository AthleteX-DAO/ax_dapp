import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'league_game_event.dart';
part 'league_game_state.dart';

class LeagueGameBloc extends Bloc<LeagueGameEvent, LeagueGameState> {
  LeagueGameBloc() : super(LeagueGameInitial()) {
    on<LeagueGameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
