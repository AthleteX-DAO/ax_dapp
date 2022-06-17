import 'dart:convert';
import 'package:ax_dapp/service/athleteModels/nfl/NFLAthleteStats.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/service/athleteModels/nfl/NFLAthlete.dart';

class NFLRepo extends SportsRepo<NFLAthlete> {
  NFLRepo() : super(SupportedSport.NFL);

  @override
  Future<List<NFLAthlete>> getAllPlayers() async {
    // TODO: Change this to query API
    final jsonData = await rootBundle.loadString('assets/nfl_athletes.json');
    final body = jsonDecode(jsonData) as List<dynamic>;
    final List<NFLAthlete> response =
        body.map((jsonObject) => NFLAthlete.fromJson(jsonObject)).toList();
    return response;
  }

  @override
  Future<List<NFLAthlete>> getSupportedPlayers() async {
    print("[NFL Repo]: Inside get supported players");
    return getAllPlayers();
  }

  @override
  Future<NFLAthlete> getPlayer(int id) {
    // TODO: implement getPlayer
    throw UnimplementedError();
  }

  @override
  Future getPlayerStatsHistory(int id) {
    // TODO: implement getPlayerStatsHistory
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersById(List<int> ids) {
    // TODO: implement getPlayersById
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersByPosition(String position) {
    // TODO: implement getPlayersByPosition
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersByTeam(String team) {
    // TODO: implement getPlayersByTeam
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersByTeamAtPosition(
      String team, String position) {
    // TODO: implement getPlayersByTeamAtPosition
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthleteStats>> getPlayersStatsHistory() async {
    List<NFLAthleteStats> list = List.empty();
    return list;
  }
}
