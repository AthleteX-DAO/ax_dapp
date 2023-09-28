import 'dart:convert';

import 'package:dio/dio.dart';

class SXBetSportsAPI {
  SXBetSportsAPI(this.dio) {
    initState();
  }

  final Dio dio;
  late String baseDataUrl;

  Future<void> initState() async {
    try {
      baseDataUrl = 'https://api.sx.bet/markets/active';
    } catch (e) {
      throw Exception('Failed to load SX Bet Markets! \n $e');
    }
  }

  Future<List<dynamic>> getAllMarkets() async {
    final url = '$baseDataUrl/';
    final jsonString = (await dio.get<String>(url)).data!;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final liveMarketsList = json['markets'] as List<dynamic>;
    return liveMarketsList.map((e) {}).toList();
  }
}
