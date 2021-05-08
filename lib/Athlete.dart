import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerGameStatsByDate/2021-APR-04?key=fa329ac2e3ce465e9db5a14b34ca9368
// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerGameStatsByDate/2021-APR-06?key=fa329ac2e3ce465e9db5a14b34ca9368

// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerSeasonStats/2021-APR-06?key=22c8f467077d4ff2a14c5b69e2355343

Future<List<Athlete>> fetchAthletes() async {
  //Steps - get curent date + time, set value in apiUrl
  //2021-APR-04
  var todayYear = DateTime.now().toLocal().year;
  var months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  var todayMonth = months[DateTime.now().toLocal().month - 1];
  var todayDay = DateTime.now().toLocal().day -2;
  
  
  /*
  String today =
      "$todayYear-$todayMonth-$todayDay"; //REMINDER: No data on Sunday
  */

  String today =
      "$todayYear";

  // ignore: unnecessary_cast
  // Tracks player stats by date
  final String apiUrl =
      "https://fly.sportsdata.io/v3/mlb/stats/json/PlayerSeasonStats/$today?key=22c8f467077d4ff2a14c5b69e2355343";

  final result = await http.get(apiUrl);

  if (result.statusCode == 200) {
    return parseAthletes(result.body);
  } else {
    throw Exception("Failed to get Athletes");
  }
}

List<Athlete> parseAthletes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Athlete>((json) => Athlete.fromJson(json)).toList();
}

// Future<List<Athlete>> fetchAthleteWAR() async {
//   var currentDate = new DateTime.now();
//   final String apiUrl = 'https://fly.sportsdata.io/v3/mlb/stats/json/PlayerGameStatsByDate/';
// }

class Athlete {
  final String name;
  final int playerID;
  //final double fantasyPoints;
  String apiUrl;
  double warValue;

  // Constructor
  Athlete({
    @required this.name,
    @required this.playerID,
    //@required this.fantasyPoints,
    @required this.warValue,
  });

  // AEWAR equation

  factory Athlete.fromJson(Map<String, dynamic> json) {
    double _wins = json['Wins'];
    double _losses = json['Losses'];
    double _warValue = _wins/_losses;

    return Athlete(
        playerID: json['PlayerID'],
        name: json['Name'],
        warValue: _warValue); // this should be updated with the latest data
  }
}
