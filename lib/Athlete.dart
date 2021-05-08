import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerGameStatsByDate/2021-APR-04?key=fa329ac2e3ce465e9db5a14b34ca9368
// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerGameStatsByDate/2021-APR-06?key=fa329ac2e3ce465e9db5a14b34ca9368

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
  final double fantasyPoints;
  String apiUrl;
  double warValue;

  // Constructor
  Athlete({
    @required this.name,
    @required this.playerID,
    @required this.fantasyPoints,
  });
  // @required this.warValue}); // Needsto be implemented, ignore for now ( can do this asap!)

  factory Athlete.fromJson(Map<String, dynamic> json) {
    double _OBA = json['OnBasePercentage'];
    double _PA = json['PitchingPlateAppearances'];
    double _lgwOBA = 0; //TODO
    double _wOBAScale = 1.254;
    double battingRuns = ((_OBA - _lgwOBA) / _wOBAScale) * _PA;

    double _SB = json['StolenBases'];
    double _CS = json['CaughtStealing'];
    double _runs = json['Runs'];
    double _outs = json['Outs'];
    double _runCS = 2 * (_runs / _outs) + 0.075;
    double _lgSB = 1; //TODO
    double _lgCS = 1; //TODO
    double _lg1B = 1; //TODO
    double _lgBB = 1; //TODO
    double _lgHBP = 1; //TODO
    double _lgIBB = 1; //TODO
    double _lgwSB = (_lgSB * 0.2 + _lgCS * _runCS) / (_lg1B + _lgBB + _lgHBP - lgIBB);
    double _1B = json['Singles'];
    double _BB = json['Walks'];
    double _HBP = json['HitByPitch'];
    double _IBB = json['IntentionalWalks'];
    double _wsB = _SB * 0.2 + _CS * _runCS - _lgwSB * (_1B + _BB + _HBP - _IBB);
    double baseRunningRuns = _wsB;


    double _warValue = battingRuns + baseRunningRuns;

    return Athlete(
        playerID: json['PlayerID'],
        name: json['Name'],
        warValue: _warValue); // this should be updated with the latest data
  }
}
