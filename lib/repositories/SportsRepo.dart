import 'package:ax_dapp/util/SupportedSports.dart';

abstract class SportsRepo<SportAthlete> {
  final SupportedSport sport;
  SportsRepo(this.sport);

  Future<List<SportAthlete>> getAllPlayers();

  Future<List<SportAthlete>> getPlayersById(List<int> ids);

  Future<List<SportAthlete>> getSupportedPlayers();

  Future<SportAthlete> getPlayer(int id);

  Future<List<SportAthlete>> getPlayersByTeam(String team);

  Future<List<SportAthlete>> getPlayersByPosition(String position);

  Future<List<SportAthlete>> getPlayersByTeamAtPosition(
      String team, String position);

  Future getPlayerStatsHistory(int id);

  Future getPlayersStatsHistory();
}
