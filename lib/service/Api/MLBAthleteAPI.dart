import 'package:ax_dapp/service/Api/models/PlayerIds.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBAthlete.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'MLBAthleteAPI.g.dart';

@RestApi(baseUrl: "https://db.athletex.io/mlb")
abstract class MLBAthleteAPI {
  factory MLBAthleteAPI(Dio dio, {String baseUrl}) = _MLBAthleteAPI;

  @GET("/players")
  Future<List<MLBAthlete>> getAllPlayers();

  @POST("/players")
  Future<List<MLBAthlete>> getPlayersById(@Body() PlayerIds playerIds);

  @GET("/players/{id}")
  Future<MLBAthlete> getPlayer(@Path() int id);

  @GET("/players")
  Future<List<MLBAthlete>> getPlayersByTeam(@Query("team") String team);

  @GET("/players")
  Future<List<MLBAthlete>> getPlayersByPosition(
      @Query("position") String position);

  @GET("/players")
  Future<List<MLBAthlete>> getPlayersByTeamAtPosition(
      @Query("team") String team, @Query("position") String position);

  @GET("/players/{id}/history")
  Future<MLBAthleteStats> getPlayerHistory(@Path() int id);
}
