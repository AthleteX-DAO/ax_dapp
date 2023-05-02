import 'dart:convert';

import 'package:ax_dapp/service/athlete_models/athlete_price_record.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete_stats.dart';
import 'package:ax_dapp/service/athlete_models/price_record.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class MLBAthleteAPI {
  MLBAthleteAPI(this.dio) {
    initState();
  }

  final Dio dio;
  late String baseDataUrl;
  final defaultFrom = '2023-01-01';
  final defaultUntil = '2023-12-31';
  final defaultInterval = 'Hour';

  Future<void> initState() async {
    const cidUrl =
        'https://raw.githubusercontent.com/AthleteX-DAO/sports-cids/main/mlb.json';
    try {
      final response = await http.get(Uri.parse(cidUrl));
      final decodedData = json.decode(response.body);
      final cid = decodedData['directory'];
      baseDataUrl = 'https://$cid.ipfs.nftstorage.link';
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  Future<List<MLBAthlete>> getAllPlayers() async {
    final url = '$baseDataUrl/ALL_PLAYERS';
    final jsonString = (await dio.get<String>(url)).data!;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final athleteList = json['Athletes'] as List<dynamic>;
    return athleteList
        .map((athlete) => MLBAthlete.fromJson(athlete as Map<String, dynamic>))
        .toList();
  }

  Future<List<MLBAthlete>> getPlayersById(List<int> ids) async {
    final athletes = await Future.wait(ids.map(getPlayer));
    return athletes;
  }

  Future<MLBAthlete> getPlayer(int id) async {
    final url = '$baseDataUrl/$id';
    return MLBAthlete.fromJson(
      await dio.get<Map<String, dynamic>>(url) as Map<String, dynamic>,
    );
  }

  Future<List<MLBAthlete>> getPlayersByTeam(String team) async {
    final athletes = await getAllPlayers();
    return athletes.where((athlete) => athlete.team == team).toList();
  }

  Future<List<MLBAthlete>> getPlayersByPosition(String position) async {
    final athletes = await getAllPlayers();
    return athletes.where((athlete) => athlete.position == position).toList();
  }

  Future<List<MLBAthlete>> getPlayersByTeamAtPosition(
    String team,
    String position,
  ) async {
    final athletes = await getAllPlayers();
    return athletes
        .where(
          (athlete) => athlete.position == position || athlete.team == team,
        )
        .toList();
  }

  Future<MLBAthleteStats> getPlayerHistory(
    int id,
    String from,
    String until,
  ) async {
    final url = '$baseDataUrl/$id';
    final response =
        await dio.get<Map<String, dynamic>>(url) as Map<String, dynamic>;
    return MLBAthleteStats.fromJson(
      response,
    );
  }

  Future<AthletePriceRecord> getPlayerPriceHistory(
    int id,
    String? from,
    String? until,
    String? interval,
  ) async {
    var timeInterval = '';
    switch (interval?.toLowerCase()) {
      case 'hour':
        timeInterval = 'Hour';
        break;
      case 'day':
      default:
        timeInterval = 'Day';
        break;
    }
    final fromTime = DateTime.parse(from ?? defaultFrom);
    final untilTime = DateTime.parse(until ?? defaultUntil);

    final url = '$baseDataUrl/${id}_history';
    final jsonString = (await dio.get<String>(url)).data!;
    final history = <PriceRecord>[];

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final name = json['Name'] as String;
    final historyData = json[timeInterval] as List<dynamic>;
    for (var i = 0; i < historyData.length; i++) {
      final priceTime = historyData[i] as Map<String, dynamic>;
      final time = DateTime.parse(priceTime['Time'] as String);
      if (time.isAfter(fromTime) && time.isBefore(untilTime)) {
        history.add(
          PriceRecord(
            price: priceTime['BookPrice'] as double,
            timestamp: time.toString(),
          ),
        );
      }
    }

    return AthletePriceRecord(id: id, name: name, priceHistory: history);
  }

  Future<List<MLBAthleteStats>> getPlayersHistory(
    List<int> playerIds,
    String from,
    String until,
  ) async {
    final playersHistory = await Future.wait(
      playerIds.map((id) => getPlayerHistory(id, from, until)),
    );

    return playersHistory;
  }

  Future<List<AthletePriceRecord>> getPlayersPriceHistory(
    List<int> playerIds,
    String? from,
    String? until,
    String interval,
  ) async {
    final playersHistory = await Future.wait(
      playerIds.map((id) => getPlayerPriceHistory(id, from, until, interval)),
    );

    return playersHistory;
  }
}
