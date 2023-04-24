import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:shared/shared.dart';

class LeagueInfo extends Equatable {
  const LeagueInfo({
    required this.leagues,
    required this.leagueTeams,
  });

  final List<League> leagues;
  final List<List<LeagueTeam>> leagueTeams;

  static const empty = LeagueInfo(
    leagues: [],
    leagueTeams: [],
  );

  @override
  List<Object?> get props => [
        leagues,
        leagueTeams,
      ];
}
