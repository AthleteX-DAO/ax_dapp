part of 'league_game_bloc.dart';

class LeagueGameState extends Equatable {
  const LeagueGameState({
    this.status = BlocStatus.initial,
    this.userTeams = const [],
    this.rosters = const {},
    this.selectedChain = EthereumChain.polygonMainnet,
  });

  final BlocStatus status;
  final List<UserTeam> userTeams;
  final Map<String, Map<String, double>> rosters;
  final EthereumChain selectedChain;

  LeagueGameState copyWith({
    BlocStatus? status,
    List<UserTeam>? userTeams,
    Map<String, Map<String, double>>? rosters,
    EthereumChain? selectedChain,
  }) {
    return LeagueGameState(
      status: status ?? this.status,
      userTeams: userTeams ?? this.userTeams,
      rosters: rosters ?? this.rosters,
      selectedChain: selectedChain ?? this.selectedChain,
    );
  }

  @override
  List<Object> get props => [
        status,
        userTeams,
        rosters,
        selectedChain,
      ];
}
