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
    this.leagueInfo = LeagueInfo.empty,
  });

  final BlocStatus status;
  final League league;
  final List<League> allLeagues;
  final List<League> filteredLeagues;
  final List<SupportedSport> sports;
  final EthereumChain selectedChain;
  final SupportedSport selectedSport;
  final LeagueInfo leagueInfo;

  LeagueState copyWith({
    BlocStatus? status,
    League? league,
    List<League>? allLeagues,
    List<League>? filteredLeagues,
    List<SupportedSport>? sports,
    EthereumChain? selectedChain,
    SupportedSport? selectedSport,
    LeagueInfo? leagueInfo,
  }) {
    return LeagueState(
      status: status ?? this.status,
      league: league ?? this.league,
      allLeagues: allLeagues ?? this.allLeagues,
      filteredLeagues: filteredLeagues ?? this.filteredLeagues,
      sports: sports ?? this.sports,
      selectedChain: selectedChain ?? this.selectedChain,
      selectedSport: selectedSport ?? this.selectedSport,
      leagueInfo: leagueInfo ?? this.leagueInfo,
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
        leagueInfo,
      ];
}