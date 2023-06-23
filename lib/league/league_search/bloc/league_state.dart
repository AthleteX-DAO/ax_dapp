part of 'league_bloc.dart';

class LeagueState extends Equatable {
  const LeagueState({
    this.status = BlocStatus.initial,
    this.league = League.empty,
    this.allLeagues = const [],
    this.filteredLeagues = const [],
    this.sports = const [],
    this.selectedChain = EthereumChain.polygonMainnet,
    this.selectedSport = SupportedSport.all,
    this.filteredLeagueTeams = const [],
    this.leagueTeams = const [],
    this.leaguesWithTeams = const [],
    this.filteredLeaguesWithTeams = const [],
  });

  final BlocStatus status;
  final League league;
  final List<League> allLeagues;
  final List<League> filteredLeagues;
  final List<SupportedSport> sports;
  final EthereumChain selectedChain;
  final SupportedSport selectedSport;
  final List<List<LeagueTeam>> leagueTeams;
  final List<List<LeagueTeam>> filteredLeagueTeams;
  final List<Pair<League, List<LeagueTeam>>> leaguesWithTeams;
  final List<Pair<League, List<LeagueTeam>>> filteredLeaguesWithTeams;

  LeagueState copyWith({
    BlocStatus? status,
    League? league,
    List<League>? allLeagues,
    List<League>? filteredLeagues,
    List<SupportedSport>? sports,
    EthereumChain? selectedChain,
    SupportedSport? selectedSport,
    List<List<LeagueTeam>>? leagueTeams,
    List<List<LeagueTeam>>? filteredLeagueTeams,
    List<Pair<League, List<LeagueTeam>>>? leaguesWithTeams,
    List<Pair<League, List<LeagueTeam>>>? filteredLeaguesWithTeams,
  }) {
    return LeagueState(
      status: status ?? this.status,
      league: league ?? this.league,
      allLeagues: allLeagues ?? this.allLeagues,
      filteredLeagues: filteredLeagues ?? this.filteredLeagues,
      sports: sports ?? this.sports,
      selectedChain: selectedChain ?? this.selectedChain,
      selectedSport: selectedSport ?? this.selectedSport,
      leagueTeams: leagueTeams ?? this.leagueTeams,
      filteredLeagueTeams: filteredLeagueTeams ?? this.filteredLeagueTeams,
      leaguesWithTeams: leaguesWithTeams ?? this.leaguesWithTeams,
      filteredLeaguesWithTeams:
          filteredLeaguesWithTeams ?? this.filteredLeaguesWithTeams,
    );
  }

  @override
  List<Object> get props => [
        status,
        league,
        allLeagues,
        filteredLeagues,
        sports,
        selectedChain,
        selectedSport,
        leagueTeams,
        filteredLeagueTeams,
        leaguesWithTeams,
        filteredLeaguesWithTeams,
      ];
}
