import 'package:ax_dapp/repositories/sports_repo.dart';
import 'package:ax_dapp/service/api/mlb_athlete_api.dart';
import 'package:ax_dapp/service/athlete_models/athlete_price_record.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete_stats.dart';
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
    return _api.getPlayersById(ids);
  }

  @override
  Future<List<MLBAthlete>> getSupportedPlayers() async {
    return _api.getAllPlayers();
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
  Future<AthletePriceRecord> getPlayerPriceHistory(
    int id, {
    String? from,
    String? until,
    String? interval,
  }) {
    return _api.getPlayerPriceHistory(id, from, until, interval ?? '1d');
  }

  @override
  Future<List<MLBAthleteStats>> getPlayersStatsHistory(
    List<int> ids,
    String from,
    String until,
  ) async {
    final list = _api.getPlayersHistory(ids, from, until);
    return list;
  }

  @override
  Future<List<AthletePriceRecord>> getPlayersPriceHistory(
    List<int> ids, {
    String? from,
    String? until,
    String? interval,
  }) async {
    final list =
        _api.getPlayersPriceHistory(ids, from, until, interval ?? '1d');
    return list;
  }
}
