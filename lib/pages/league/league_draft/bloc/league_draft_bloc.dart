import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'league_draft_event.dart';
part 'league_draft_state.dart';

class LeagueDraftBloc extends Bloc<LeagueDraftEvent, LeagueDraftState> {
  LeagueDraftBloc() : super(LeagueDraftInitial()) {
    on<LeagueDraftEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
