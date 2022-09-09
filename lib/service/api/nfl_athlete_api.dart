import 'package:ax_dapp/app/config/app_config.dart';
import 'package:ax_dapp/service/api/models/player_ids.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete_stats.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'nfl_athlete_api.g.dart';

@RestApi(baseUrl: '$baseApiUrl/nfl')
abstract class NFLAthleteAPI {
  factory NFLAthleteAPI(Dio dio, {String baseUrl}) = _NFLAthleteAPI;

  @GET('/players')
  Future<List<NFLAthlete>> getAllPlayers();

  @POST('/players')
  Future<List<NFLAthlete>> getPlayersById(@Body() PlayerIds playerIds);

  @GET('/players/{id}')
  Future<NFLAthlete> getPlayer(@Path() int id);

  @GET('/players')
  Future<List<NFLAthlete>> getPlayersByTeam(@Query('team') String team);

  @GET('/players')
  Future<List<NFLAthlete>> getPlayersByPosition(
      @Query('position') String position,);

  @GET('/players')
  Future<List<NFLAthlete>> getPlayersByTeamAtPosition(@Query('team') String team,
      @Query('position') String position,);

  @GET('/players/{id}/history')
  Future<NFLAthleteStats> getPlayerHistory(@Path() int id,
      @Query('from') String from,
      @Query('until') String until,);

  @POST('/players/history')
  Future<List<NFLAthleteStats>> getPlayersHistory(@Body() PlayerIds playerIds,
      @Query('from') String from,
      @Query('until') String until,);
}
