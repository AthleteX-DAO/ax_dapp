part of 'league_bloc.dart';

class LeagueState extends Equatable {
  const LeagueState({
    this.status = BlocStatus.initial,
    this.league = League.empty,
    this.allLeagues = const [],
    this.filteredLeagues = const [],
    this.rosters = const {},
    this.sports = const [],
  });

  final BlocStatus status;
  final League league;
  final List<League> allLeagues;
  final List<League> filteredLeagues;
  final Map<String, List<String>> rosters;
  final List<SupportedSport> sports;

  LeagueState copyWith({
    BlocStatus? status,
    League? league,
    List<League>? allLeagues,
    List<League>? filteredLeagues,
    Map<String, List<String>>? rosters,
    List<SupportedSport>? sports,
  }) {
    return LeagueState(
      status: status ?? this.status,
      league: league ?? this.league,
      allLeagues: allLeagues ?? this.allLeagues,
      filteredLeagues: filteredLeagues ?? this.filteredLeagues,
      rosters: rosters ?? this.rosters,
      sports: sports ?? this.sports,
    );
  }

  @override
  List<Object> get props => [
        status,
        league,
        allLeagues,
        filteredLeagues,
        rosters,
        sports,
      ];
}
