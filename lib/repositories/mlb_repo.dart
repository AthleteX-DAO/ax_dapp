import 'package:ax_dapp/repositories/sports_repo.dart';
import 'package:ax_dapp/service/api/mlb_athlete_api.dart';
import 'package:ax_dapp/service/api/models/player_ids.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete_stats.dart';
// ignore: don't_import_implementation_files
import 'package:ethereum_api/src/config/models/apts/mlb_apt_list.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MLBRepo extends SportsRepo<MLBAthlete> {
  MLBRepo(MLBAthleteAPI api)
      : _api = api,
        super(SupportedSport.MLB);

  final MLBAthleteAPI _api;

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
    return _api.getPlayersById(
      PlayerIds(mlbApts.map((e) => e.athleteId).toList()),
    );
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
    String team,
    String position,
  ) async {
    return _api.getPlayersByTeamAtPosition(team, position);
  }

  @override
  Future<MLBAthleteStats> getPlayerStatsHistory(
    int id,
    String from,
    String until,
  ) async {
    return _api.getPlayerHistory(id, from, until);
  }

  @override
  Future<List<MLBAthleteStats>> getPlayersStatsHistory(
    List<int> ids,
    String from,
    String until,
  ) async {
    final playerIds = PlayerIds(ids);
    final list = _api.getPlayersHistory(playerIds, from, until);
    return list;
  }
}
