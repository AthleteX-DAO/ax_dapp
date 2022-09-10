import 'package:ax_dapp/service/athlete_models/athlete_price_record.dart';
import 'package:tokens_repository/tokens_repository.dart';

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

  Future<AthletePriceRecord> getPlayerPriceHistory(
    int id, {
    String? from,
    String? until,
    String? interval,
  });

  Future<List<dynamic>> getPlayersStatsHistory(
    List<int> ids,
    String from,
    String until,
  );

  Future<List<AthletePriceRecord>> getPlayersPriceHistory(
    List<int> ids, {
    String? from,
    String? until,
    String? interval,
  });
}
