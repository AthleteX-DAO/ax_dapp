part of 'league_game_bloc.dart';

class LeagueGameState extends Equatable {
  const LeagueGameState({
    this.status = BlocStatus.initial,
    this.userTeams = const [],
    this.rosters = const {},
    this.selectedChain = EthereumChain.polygonMainnet,
    this.startDate = '',
    this.endDate = '',
    this.difference = 0,
  });

  final BlocStatus status;
  final List<UserTeam> userTeams;
  final Map<String, Map<String, double>> rosters;
  final EthereumChain selectedChain;
  final String startDate;
  final String endDate;
  final int difference;

  LeagueGameState copyWith({
    BlocStatus? status,
    List<UserTeam>? userTeams,
    Map<String, Map<String, double>>? rosters,
    EthereumChain? selectedChain,
    String? startDate,
    String? endDate,
    int? difference,
  }) {
    return LeagueGameState(
      status: status ?? this.status,
      userTeams: userTeams ?? this.userTeams,
      rosters: rosters ?? this.rosters,
      selectedChain: selectedChain ?? this.selectedChain,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      difference: difference ?? this.difference,
    );
  }

  @override
  List<Object> get props => [
        status,
        userTeams,
        rosters,
        selectedChain,
        startDate,
        endDate,
        difference,
      ];
}
