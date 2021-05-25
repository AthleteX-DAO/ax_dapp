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
  // ignore: unused_local_variable

  /*
  String today =
      "$todayYear-$todayMonth-$todayDay"; //REMINDER: No data on Sunday
  */

  String today = "$todayYear";
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

  var aeList = parsed.map<Athlete>((json) => Athlete.fromJson(json)).toList();

  return parseWarValue(aeList);
  /*
  athleteList = parsed.map<Athlete>((json) => Athlete.fromJson(json)).toList();
  return athleteList;
  */
}

class Athlete {
  final String name;
  final int playerID;
  final String position;
  final double oba;
  final double pa;
  final double sb;
  final double cs;
  final double runs;
  final double outs;
  final double singles;
  final double walks;
  final double hitByPitch;
  final double intentionalWalks;
   double warValue;

  // Constructor
  Athlete(
      {@required this.name,
      @required this.playerID,
      @required this.position,
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
      @required this.warValue});

  // AEWAR equation

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
        name: json['Name'],
        playerID: json['PlayerID'],
        position: json['PositionCategory'],
        oba: json['OnBasePercentage'],
        pa: json['PitchingPlateAppearances'],
        sb: json['StolenBases'],
        cs: json['CaughtStealing'],
        runs: json['Runs'],
        outs: json['Outs'],
        singles: json['Singles'],
        walks: json['Walks'],
        hitByPitch: json['HitByPitch'],
        intentionalWalks: json['IntentionalWalks'],
        warValue: 0.0); // this should be updated with the latest data
  }
}

// double warValue(Athlete athlete, List<Athlete> athleteList) {
//   List<Athlete> players = athleteList;
//   List<Athlete> pitchers = athleteList;

//   for (Athlete ath in athleteList) {
//     if (athlete.position != "P")
//       pitchers.remove(ath);
//     else
//       players.remove(ath);
//   }

//   if (athlete.position != "P")
//     return parseWarValue(athlete);
//   else
//     return -999;
// }

List<Athlete> parseWarValue(List<Athlete> aeList) {
  
  double lgwOBA = 0;
  double lgSB = 0;
  double lgCS = 0;
  double lg1B = 0;
  double lgBB = 0;
  double lgHBP = 0;
  double lgIBB = 0;
  int numAthletes = 0;


  for (Athlete ath in aeList) // for every athlete
  {
    if (ath.position != "P") {
      lgwOBA += ath.oba;
      lgSB += ath.sb;
      lgCS += ath.cs;
      lg1B += ath.singles;
      lgBB += ath.walks;
      lgHBP += ath.hitByPitch;
      lgIBB += ath.intentionalWalks;
      numAthletes++;
    }
  }

  lgwOBA /= numAthletes;
  lgSB /= numAthletes;
  lgCS /= numAthletes;
  lg1B /= numAthletes;
  lgBB /= numAthletes;
  lgHBP /= numAthletes;
  lgIBB /= numAthletes;

  double wOBAScale = 1.254;

  for (Athlete a in aeList) {
    if (a.position != "P")
    {
          double battingRuns = ((a.oba - lgwOBA) / wOBAScale) * a.pa;
    double runCS = 2 * (a.runs / a.outs) + 0.075;
    double lgwSB = (lgSB * 0.2 + lgCS * runCS) / (lg1B + lgBB + lgHBP - lgIBB);
    double wsB = a.sb * 0.2 +
        a.cs * runCS -
        lgwSB * (a.singles + a.walks + a.hitByPitch - a.intentionalWalks);
    double baseRunningRuns = wsB;
    a.warValue = battingRuns + baseRunningRuns;
    }
  }
  return aeList;
}
