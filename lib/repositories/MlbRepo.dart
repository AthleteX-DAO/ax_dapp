import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/service/SupportedAthletes/SupportedMLBAthletes.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBAthlete.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:ax_dapp/service/athlete_api/MLBAthleteAPI.dart';
import 'package:ax_dapp/service/athlete_api/models/PlayerIds.dart';
import 'package:ax_dapp/util/SupportedSports.dart';

class MLBRepo extends SportsRepo<MLBAthlete> {
  final MLBAthleteAPI _api;

  MLBRepo(
    this._api,
  ): super(SupportedSport.MLB);

  @override
  Future<List<MLBAthlete>> getAllPlayers() async {
    return _api.getAllPlayers();
  }

  @override
  Future<List<MLBAthlete>> getPlayersById(List<int> ids) async {
    return _api.getPlayersById(PlayerIds(ids));
  }

  @override
  Future<List<MLBAthlete>> getSupportedPlayers() async {
    return _api.getPlayersById(PlayerIds(SupportedMLBAthletes().getSupportedAthletesList()));
  }

  @override
  Future<MLBAthlete> getPlayer(int id) async {
    return _api.getPlayer(id);
  }

  @override
  Future<List<MLBAthlete>> getPlayersByTeam(String team) async {
    return _api.getPlayersByTeam(team);
  }

  @override
  Future<List<MLBAthlete>> getPlayersByPosition(String position) async {
    return _api.getPlayersByPosition(position);
  }

  @override
  Future<List<MLBAthlete>> getPlayersByTeamAtPosition(
      String team, String position) async {
    return _api.getPlayersByTeamAtPosition(team, position);
  }

  @override
  Future<MLBAthleteStats> getPlayerStatsHistory(int id) async {
    return _api.getPlayerHistory(id);
  }
}
