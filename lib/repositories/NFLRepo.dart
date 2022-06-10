import 'dart:convert';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/service/athleteModels/nfl/NFLAthlete.dart';

class NFLRepo extends SportsRepo<NFLAthlete> {
  NFLRepo() : super(SupportedSport.NFL);

  @override
  Future<List<NFLAthlete>> getAllPlayers() async {
    // TODO: Change this to query API
    //final file = new File('assets/nfl_athletes.json');
    final jsonData = await rootBundle.loadString('assets/nfl_athletes.json');
    //final jsonString = await file.readAsString();
    final body = jsonDecode(jsonData) as List<dynamic>;
    //final body = json.decode(jsonData).cast<Map<String, dynamic>>();
    print(body);

    //return List<NFLAthlete>.from(body.map((item) => NFLAthlete.fromJson(item))).toList();
    
    final List<NFLAthlete> response =
        body.map((jsonObject) => NFLAthlete.fromJson(jsonObject)).toList();
    print("[NFL Repo]: $response");
    return response;

    //return body.map<NFLAthlete>((json) => NFLAthlete.fromJson(json)).toList();
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
}
