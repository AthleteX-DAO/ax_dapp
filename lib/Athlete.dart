import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'AthletesList.dart';

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
  final double oba;
  final double pa;
  final double sb;
  final double cs;
  final double runs;
  final double outs;
  final double walks;
  final double hitByPitch;
  final double intentionalWalks;

  // Constructor
  Athlete({
    @required this.name,
    @required this.playerID,
    @required this.oba,
    @required this.pa,
    @required this.sb,
    @required this.cs,
    @required this.runs,
    @required this.outs,
    @required this.singles,
    @required this.walks,
    @required this.hitByPitch,
    @required this.intentionalWalks,
  });
  // @required this.warValue}); // Needsto be implemented, ignore for now ( can do this asap!)

  factory Athlete.fromJson(Map<String, dynamic> json) {
 
    return Athlete(
        playerID: json['PlayerID'],
        name: json['Name'],
        oba: json['OnBasePercentage'],
        pa: json['PitchingPlateAppearances'],
        sb: json['StolenBases'],
        cs: json['CaughtStealing'],
        runs: json['Runs'],
        singles: json['Singles'],
        walks: json['Walks'],
        hitByPitch: json['HitByPitch'],
        intentionalWalks: json['IntentionalWalks'],); // this should be updated with the latest data
  }

  // Create a token per athlete
  generateTokenPerAthlete() async {
    List<Athlete> allAthletes = await fetchAthletes();
    allAthletes.forEach((element) {
      // Implement logic here
    });
  }
}

double warValue(Athlete athlete)
{
  /*
  double lgwOBA = 0;
  double lgSB = 0;
  double lgCS = 0;
  double lg1B = 0;
  double lgBB = 0;
  double lgHBP = 0;
  double lgIBB = 0;
  int numAthletes = list.length;
  
  for () // for every athlete
  {
    lgOBA += ath.oba;
    lgSB += ath.sb;
    lgCS += ath.cs;
    lg1B += ath.singles;
    lgBB += ath.walks;
    lgHBP += ath.hitByPitch;
    lgIBB += ath.intentionalWalks;
  }

  lgwOBA /= numAthletes;
  lgSB /= numAthletes;
  lgCS /= numAthletes;
  lg1B /= numAthletes;
  lgBB /= numAthletes;
  lgHBP /= numAthletes;
  lgIBB /= numAthletes;
  
  double wOBAScale = 1.254;
  double battingRuns = ((athlete.oba - lgwOBA) / wOBAScale) * athlete.pa;

  double _runCS = 2 * (athlete.runs / athlete.outs) + 0.075;
  double lgwSB = (lgSB * 0.2 + lgCS * runCS) / (lg1B + lgBB + lgHBP - lgIBB);
  double _wsB = athlete.SB * 0.2 + athlete.CS * runCS - lgwSB * (athlete.1B + athlete.BB + athlete.HBP - athlete.IBB);
  double baseRunningRuns = _wsB;

  return battingRuns + baseRunningRuns;
  */
}