import 'package:ax_dapp/util/supported_sports.dart';

abstract class SportsRepo<SportAthlete> {
  SportsRepo(this.sport);

  final SupportedSport sport;

  Future<List<SportAthlete>> getAllPlayers();

  Future<List<SportAthlete>> getPlayersById(List<int> ids);

  Future<List<SportAthlete>> getSupportedPlayers();

  Future<SportAthlete> getPlayer(int id);

  Future<List<SportAthlete>> getPlayersByTeam(String team);

  Future<List<SportAthlete>> getPlayersByPosition(String position);

  Future<List<SportAthlete>> getPlayersByTeamAtPosition(
    String team,
    String position,
  );

  Future<dynamic> getPlayerStatsHistory(int id, String from, String until);

  Future<dynamic> getPlayersStatsHistory();
}
