import 'dart:convert';

import 'package:ax_dapp/service/athlete_models/athlete_price_record.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete_stats.dart';
import 'package:ax_dapp/service/athlete_models/price_record.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NFLAthleteAPI {
  NFLAthleteAPI(this.dio) {
    _initFuture = initState();
  }

  final Dio dio;
  late String baseDataUrl;
  late Future<void> _initFuture;
  final defaultFrom = '2023-01-01';
  final defaultUntil = '2023-12-31';
  final defaultInterval = 'Day';

  Future<void> initState() async {
    const cidUrl =
        'https://raw.githubusercontent.com/AthleteX-DAO/sports-cids/main/nfl.json';
    try {
      final response = await http.get(Uri.parse(cidUrl));
      final decodedData = json.decode(response.body);
      final cid = decodedData['directory'];
      baseDataUrl = 'https://$cid.ipfs.nftstorage.link';
    } catch (error) {
      baseDataUrl = '';
      debugPrint('NFLAthleteAPI init failed: $error');
    }
  }

  Future<List<NFLAthlete>> getAllPlayers() async {
    await _initFuture;
    if (baseDataUrl.isEmpty) return [];
    final url = '$baseDataUrl/ALL_PLAYERS';
    final jsonString = (await dio.get<String>(url)).data!;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final athleteList = json['Athletes'] as List<dynamic>;
    return athleteList
        .map((athlete) => NFLAthlete.fromJson(athlete as Map<String, dynamic>))
        .toList();
  }

  Future<List<NFLAthlete>> getPlayersById(List<int> ids) async {
    await _initFuture;
    if (baseDataUrl.isEmpty) return [];
    final athletes = await Future.wait(ids.map(getPlayer));
    return athletes;
  }

  Future<NFLAthlete> getPlayer(int id) async {
    await _initFuture;
    if (baseDataUrl.isEmpty) {
      throw Exception('NFL data unavailable');
    }
    final url = '$baseDataUrl/$id';
    return NFLAthlete.fromJson(
      await dio.get<Map<String, dynamic>>(url) as Map<String, dynamic>,
    );
  }

  Future<List<NFLAthlete>> getPlayersByTeam(String team) async {
    await _initFuture;
    final athletes = await getAllPlayers();
    return athletes.where((athlete) => athlete.team == team).toList();
  }

  Future<List<NFLAthlete>> getPlayersByPosition(String position) async {
    await _initFuture;
    final athletes = await getAllPlayers();
    return athletes.where((athlete) => athlete.position == position).toList();
  }

  Future<List<NFLAthlete>> getPlayersByTeamAtPosition(
    String team,
    String position,
  ) async {
    await _initFuture;
    final athletes = await getAllPlayers();
    return athletes
        .where(
          (athlete) => athlete.position == position || athlete.team == team,
        )
        .toList();
  }

  Future<NFLAthleteStats> getPlayerHistory(
    int id,
    String from,
    String until,
  ) async {
    await _initFuture;
    if (baseDataUrl.isEmpty) {
      throw Exception('NFL data unavailable');
    }
    final url = '$baseDataUrl/$id';
    final response =
        await dio.get<Map<String, dynamic>>(url) as Map<String, dynamic>;
    return NFLAthleteStats.fromJson(
      response,
    );
  }

  Future<AthletePriceRecord> getPlayerPriceHistory(
    int id,
    String? from,
    String? until,
    String? interval,
  ) async {
    await _initFuture;
    if (baseDataUrl.isEmpty) {
      return AthletePriceRecord(id: id, name: '', priceHistory: const []);
    }
    final timeInterval = ((interval ?? 'hour').toLowerCase() == 'hour')
        ? 'Hour'
        : defaultInterval;
    final fromTime = DateTime.parse(from ?? defaultFrom);
    final untilTime = DateTime.parse(until ?? defaultUntil);

    final url = '$baseDataUrl/${id}_history';
    final jsonString = (await dio.get<String>(url)).data!;
    final history = <PriceRecord>[];

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final historyData = json[timeInterval] as List<dynamic>;
    for (var i = 0; i < historyData.length; i++) {
      final priceTime = historyData[i] as Map<String, dynamic>;
      final time = DateTime.parse(priceTime['Time'] as String);
      if (time.isAfter(fromTime) && time.isBefore(untilTime)) {
        history.add(
          PriceRecord(
            price: priceTime['Price'] as double,
            timestamp: time.toString(),
          ),
        );
      }
    }

    return AthletePriceRecord(id: id, name: '', priceHistory: history);
  }

  Future<List<NFLAthleteStats>> getPlayersHistory(
    List<int> playerIds,
    String from,
    String until,
  ) async {
    await _initFuture;
    if (baseDataUrl.isEmpty) return [];
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
    await _initFuture;
    if (baseDataUrl.isEmpty) return [];
    final playersHistory = await Future.wait(
      playerIds.map((id) => getPlayerPriceHistory(id, from, until, interval)),
    );

    return playersHistory;
  }
}
