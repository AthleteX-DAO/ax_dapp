import 'dart:convert';

import 'package:ax_dapp/repositories/sports_repo.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete_stats.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:flutter/services.dart' show rootBundle;

class NFLRepo extends SportsRepo<NFLAthlete> {
  NFLRepo() : super(SupportedSport.NFL);

  @override
  Future<List<NFLAthlete>> getAllPlayers() async {
    // TODO(Ryan): Change this to query API
    final jsonData = await rootBundle.loadString('assets/nfl_athletes.json');
    final body = jsonDecode(jsonData) as List<dynamic>;
    final response =
        List<Map<String, dynamic>>.from(body).map(NFLAthlete.fromJson).toList();
    return response;
  }

  @override
  Future<List<NFLAthlete>> getSupportedPlayers() async {
    return getAllPlayers();
  }

  @override
  Future<NFLAthlete> getPlayer(int id) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getPlayerStatsHistory(int id, String from, String until) {
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersById(List<int> ids) {
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersByPosition(String position) {
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersByTeam(String team) {
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthlete>> getPlayersByTeamAtPosition(
    String team,
    String position,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<List<NFLAthleteStats>> getPlayersStatsHistory() async {
    final list = List<NFLAthleteStats>.empty();
    return list;
  }
}
