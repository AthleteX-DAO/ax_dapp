import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'league_draft_event.dart';
part 'league_draft_state.dart';

class LeagueDraftBloc extends Bloc<LeagueDraftEvent, LeagueDraftState> {
  LeagueDraftBloc({required LeagueRepository leagueRepository})
      : _leagueRepository = leagueRepository,
        super(LeagueDraftState()) {
    on<LeagueDraftEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final LeagueRepository _leagueRepository;
}
