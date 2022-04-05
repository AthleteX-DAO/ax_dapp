import 'package:ax_dapp/service/athleteModels/mlb/MLBAthlete.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:ax_dapp/service/athlete_api/MLBAthleteAPI.dart';
import 'package:ax_dapp/service/athlete_api/models/PlayerIds.dart';

class MLBRepo {
  final MLBAthleteAPI _api;

  MLBRepo(
    this._api,
  );

  Future<List<MLBAthlete>> getAllPlayers() async {
    return _api.getAllPlayers();
  }

  Future<List<MLBAthlete>> getPlayersById(List<int> ids) async {
    return _api.getPlayersById(PlayerIds(ids));
  }

  Future<MLBAthlete> getPlayer(int id) async {
    return _api.getPlayer(id);
  }

  Future<List<MLBAthlete>> getPlayersByTeam(String team) async {
    return _api.getPlayersByTeam(team);
  }

  Future<List<MLBAthlete>> getPlayersByPosition(String position) async {
    return _api.getPlayersByPosition(position);
  }

  Future<List<MLBAthlete>> getPlayersByTeamAtPosition(
      String team, String position) async {
    return _api.getPlayersByTeamAtPosition(team, position);
  }

  Future<MLBAthleteStats> getPlayerStatsHistory(int id) async {
    return _api.getPlayerHistory(id);
  }
}
