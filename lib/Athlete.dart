import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Athlete {
  final String name;
  final int playerID;
  final int fantasyPoints;

  Athlete(
      {@required this.name,
      @required this.playerID,
      @required this.fantasyPoints});

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      playerID: json['PlayerID'],
      name: json['Name'],
      fantasyPoints: json['FantasyPoints'],
    );
  }
}

Future<Athlete> getBaseballAthletes() async {
  final String apiUrl =
      "https://api.sportsdata.io/v3/mlb/stats/json/PlayerSeasonStats/2020?key=fa329ac2e3ce465e9db5a14b34ca9368";
  final result = await http.get(apiUrl);

  if (result.statusCode == 200) {
    return Athlete.fromJson(jsonDecode(result.body));
  } else {
    throw Exception("Failed to get Athletes");
  }
}