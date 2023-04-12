import 'dart:convert';

import 'package:ax_dapp/app/config/app_config.dart';
import 'package:ax_dapp/service/api/models/player_ids.dart';
import 'package:ax_dapp/service/athlete_models/athlete_price_record.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete_stats.dart';
import 'package:ax_dapp/service/athlete_models/price_record.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class NFLAthleteAPI {
  NFLAthleteAPI(this.dio) {
    initState();
  }

  final Dio dio;
  late String baseDataUrl;
  static const DEFAULT_FROM = '2023-01-01';
  static const DEFAULT_UNTIL = '2023-12-31';
  static const DEFAULT_TIME = 'Day';

  Future<void> initState() async {
    const cidUrl =
        'https://raw.githubusercontent.com/AthleteX-DAO/sports-cids/main/nfl.json';
    final response = await http.get(Uri.parse(cidUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final cid = await decodedData['directory'] as String;
      baseDataUrl = 'https://$cid.ipfs.nftstorage.link';
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<NFLAthlete>> getAllPlayers() async {
    final athletes = <NFLAthlete>[];
    final url = '$baseDataUrl/ALL_PLAYERS';
    final jsonString = await dio.get(url);
    final json = jsonDecode(jsonString.toString()) as Map<String, dynamic>;
    final athleteList = json['Athletes'] as List<dynamic>;
    for (final athlete in athleteList) {
      athletes.add(
        NFLAthlete.fromPartialJson(athlete as Map<String, dynamic>),
      );
    }
    return athletes;
  }

  Future<List<NFLAthlete>> getPlayersById(List<int> ids) async {
    final athletes = <NFLAthlete>[];
    for (var i = 0; i < ids.length; i++) {
      final athlete = await getPlayer(ids[i]);
      athletes.add(athlete);
    }

    return athletes;
  }

  Future<NFLAthlete> getPlayer(int id) async {
    final url = '$baseDataUrl/$id';
    return NFLAthlete.fromJson(
      await dio.get(url) as Map<String, dynamic>,
    );
  }

  Future<List<NFLAthlete>> getPlayersByTeam(String team) async {
    final athletes = await getAllPlayers();
    for (final athlete in athletes) {
      if (athlete.team != team) {
        athletes.remove(athlete);
      }
    }

    return athletes;
  }

  Future<List<NFLAthlete>> getPlayersByPosition(String position) async {
    final athletes = await getAllPlayers();
    for (final athlete in athletes) {
      if (athlete.position != position) {
        athletes.remove(athlete);
      }
    }

    return athletes;
  }

  Future<List<NFLAthlete>> getPlayersByTeamAtPosition(
    String team,
    String position,
  ) async {
    final athletes = await getAllPlayers();
    for (final athlete in athletes) {
      if (athlete.position != position || athlete.team != team) {
        athletes.remove(athlete);
      }
    }

    return athletes;
  }

  Future<NFLAthleteStats> getPlayerHistory(
    int id,
    String from,
    String until,
  ) async {
    final url = '$baseDataUrl/$id';
    return NFLAthleteStats.fromJson(await dio.get(url) as Map<String, dynamic>);
  }

  Future<AthletePriceRecord> getPlayerPriceHistory(
    int id,
    String? from,
    String? until,
    String? interval,
  ) async {
    final timeInterval =
        ((interval ?? 'hour').toLowerCase() == 'hour') ? 'Hour' : DEFAULT_TIME;
    final fromTime = DateTime.parse(from ?? DEFAULT_FROM);
    final untilTime = DateTime.parse(until ?? DEFAULT_UNTIL);

    final url = '$baseDataUrl/${id}_history';
    final jsonString = await dio.get(url);
    final history = <PriceRecord>[];

    final jsonData = jsonDecode(jsonString.toString()) as Map<String, dynamic>;
    final historyData = jsonData[timeInterval] as List<dynamic>;
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
    final playersHistory = <NFLAthleteStats>[];
    for (final id in playerIds) {
      playersHistory.add(await getPlayerHistory(id, from, until));
    }
    return playersHistory;
  }

  Future<List<AthletePriceRecord>> getPlayersPriceHistory(
    List<int> playerIds,
    String? from,
    String? until,
    String interval,
  ) async {
    final playersHistory = <AthletePriceRecord>[];
    for (final id in playerIds) {
      playersHistory
          .add(await getPlayerPriceHistory(id, from, until, interval));
    }

    return playersHistory;
  }
}
