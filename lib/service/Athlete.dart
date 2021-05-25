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
  // ignore: unused_local_variable
  var todayMonth = months[DateTime.now().toLocal().month - 1];
  // ignore: unused_local_variable
  var todayDay = DateTime.now().toLocal().day - 2;
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

  return parsed.map<Athlete>((json) => Athlete.fromJson(json)).toList();

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

  // Constructor
  Athlete({
    @required this.name,
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
  });

  // AEWAR equation

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      name: json['name'],
      playerID: json['PlayerID'],
      position: json['PositionCategory'],
      oba: json['OnBasePercentage'],
      pa: json['PitchingPlateAppearances'],
      sb: json['StolenBases'],
      cs: json['CaughtStealing'],
      runs: json['Runs'],
      outs: json['outs'],
      singles: json['Singles'],
      walks: json['Walks'],
      hitByPitch: json['HitByPitch'],
      intentionalWalks: json['IntentionalWalks'],
    ); // this should be updated with the latest data
  }
}

double warValue(Athlete athlete, List<Athlete> athleteList) {
  List<Athlete> players = athleteList;
  List<Athlete> pitchers = athleteList;
  
  for (Athlete ath in athleteList) {
    if (athlete.position != "P")
      pitchers.remove(ath);
    else
      players.remove(ath);
  }
  
  if (athlete.position != "P")
    return playerWARValue(athlete, players);
  else
    return -999;
}

double playerWARValue(Athlete athlete, List<Athlete> athleteList) {
  double lgwOBA = 0;
  double lgSB = 0;
  double lgCS = 0;
  double lg1B = 0;
  double lgBB = 0;
  double lgHBP = 0;
  double lgIBB = 0;

  int numAthletes = 0;

  for (Athlete ath in athleteList) // for every athlete
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
  double battingRuns = ((athlete.oba - lgwOBA) / wOBAScale) * athlete.pa;

  double runCS = 2 * (athlete.runs / athlete.outs) + 0.075;
  double lgwSB = (lgSB * 0.2 + lgCS * runCS) / (lg1B + lgBB + lgHBP - lgIBB);
  double wsB = athlete.sb * 0.2 +
      athlete.cs * runCS -
      lgwSB *
          (athlete.singles +
              athlete.walks +
              athlete.hitByPitch -
              athlete.intentionalWalks);
  double baseRunningRuns = wsB;
  return battingRuns + baseRunningRuns;
}
