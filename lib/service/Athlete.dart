import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerGameStatsByDate/2021-APR-04?key=fa329ac2e3ce465e9db5a14b34ca9368
// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerGameStatsByDate/2021-APR-06?key=fa329ac2e3ce465e9db5a14b34ca9368

// https://fly.sportsdata.io/v3/mlb/stats/json/PlayerSeasonStats/2021-APR-06?key=22c8f467077d4ff2a14c5b69e2355343

// b6acfb905f1945fc8b9bb808b1f375bf

Future<List<Athlete>> fetchAthletes() async {
  final String key = "22c8f467077d4ff2a14c5b69e2355343";

  //Steps - get curent date + time, set value in playerUrl
  //2021-APR-04
  var year = DateTime.now().toLocal().year;
  // ignore: unused_local_variable

  /*
  String today =
      "$todayYear-$todayMonth-$todayDay"; //REMINDER: No data on Sunday
  */
  // ignore: unnecessary_cast
  // Tracks player stats by date

  final Uri playerUrl = Uri.parse("https://fly.sportsdata.io/v3/mlb/stats/json/PlayerSeasonStats/$year?key=$key");
  final Uri teamUrl = Uri.parse("https://fly.sportsdata.io/v3/mlb/scores/json/TeamSeasonStats/$year?key=$key");

  final playerResult = await http.get(playerUrl);
  final teamResult = await http.get(teamUrl);

  // check if both team and player list valid
  if (teamResult.statusCode == 200) {
    if (playerResult.statusCode == 200) {
      // parses teams and uses to parse athletes
      // returns athlete list with warValues
      return parseAthletes(playerResult.body, parseTeams(teamResult.body));
    } else {
      throw Exception("Failed to get Athletes");
    }
  } else {
    throw Exception("Failed to get Teams");
  }
}

List<Athlete> parseAthletes(String responseBody, List<Team> _teamList) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  var aePlayerList =
      parsed.map<Athlete>((json) => Athlete.fromJson(json)).toList();

  return parseWarValue(aePlayerList, _teamList);
}

List<Team> parseTeams(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  var aeTeamList = parsed.map<Team>((json) => Team.fromJson(json)).toList();

  return aeTeamList;
}

class Team {
  final int? games;
  final double? runs;
  final double? innings;

  // Constructor
  Team({
    @required this.games,
    @required this.runs,
    @required this.innings,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      games: json['Games'],
      runs: json['Runs'],
      innings: json['InningsPitchedDecimal'],
    );
  }
}

class Athlete {
  final String? name;
  final int? playerID;
  final String? position;
  final double? oba;
  final double? pa;
  final double? sb;
  final double? cs;
  final double? runs;
  final double? outs;
  final double? singles;
  final double? walks;
  final double? hitByPitch;
  final double? intentionalWalks;

  final double? fip;
  final double? inningsPitched;
  final int? games;
  final int? gamesStarted;
  late List<int> priceHistory;
  double? warValue;

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
      @required this.fip,
      @required this.inningsPitched,
      @required this.games,
      @required this.gamesStarted,
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
        fip: json['FieldingIndependentPitching'],
        inningsPitched: json['InningsPitchedDecimal'],
        games: json['Games'],
        gamesStarted: json['Started'],
        warValue: 0.0); // this should be updated with the latest data
  }
}

List<Athlete> parseWarValue(List<Athlete> aeList, List<Team> _teamList) {
  // league averages of pitchers
  double lgFIP = 0;
  int numPitchers = 0;

  // league averages of non-pitchers
  double lgwOBA = 0;
  double lgSB = 0;
  double lgCS = 0;
  double lg1B = 0;
  double lgBB = 0;
  double lgHBP = 0;
  double lgIBB = 0;
  double lgPA = 0;

  // league averages of Teams
  double lgGames = 0;
  double lgRuns = 0;
  double lgInnings = 0;

  double runsPerWin = 9 * (lgRuns / lgInnings) * 1.5 + 3;

  for (Team team in _teamList) {
    lgGames += (team.games ?? 0);
    lgRuns += (team.runs ?? 0);
    lgInnings += (team.innings ?? 0);
  }
  lgGames /= 2;
  lgInnings /= 2;

  for (Athlete ath in aeList) // for every athlete
  {
    if (ath.position == "P") {
      lgFIP += (ath.fip ?? 0);
      numPitchers++;
    } else if (ath.position != "P") {
      lgwOBA += (ath.oba ?? 0);
      lgSB += (ath.sb ?? 0);
      lgCS += (ath.cs ?? 0);
      lg1B += (ath.singles ?? 0);
      lgBB += (ath.walks ?? 0);
      lgHBP += (ath.hitByPitch ?? 0);
      lgIBB += (ath.intentionalWalks ?? 0);
      lgPA += (ath.pa ?? 0);
    }
  }

  lgFIP /= numPitchers;

  /*
    NON-PITCHERS
    WAR =
      (
        (
          ("OnBasePercentage" - lgwOBA) / 1.254
        )
        * "PitchingPlateAppearances" + wsb
        + (570 * (MLB Games/2,430))
        * (Runs Per Win/sum"PA") * PA
      )
      / (9*(sum"Runs" / sum"InningsPitchedDecimal")*1.5 + 3)
  */

  // Calculates warVal for every player
  int _games;
  double _ip;
  double _fip;
  int _gs;

  double _runs;
  double _outs;
  double _oba;
  double _pa;
  double _sb;
  double _cs;
  double _singles;
  double _walks;
  double _hbp;
  double _iw;

  for (Athlete a in aeList) {
    // Calculation for pitchers
    if (a.position == "P") {
      _games = a.games ?? 0;
      _ip = a.inningsPitched ?? 0;
      _fip = a.fip ?? 0;
      _gs = a.gamesStarted ?? 0;

      a.warValue = ((((lgFIP - (a.fip ?? 0)) /
                  // Dynamic RPW (dRPW)
                  (((((18 - _ip / _games) * lgFIP) +
                              ((_ip / _games) * _fip) / 18) +
                          2) *
                      1.5))
              // + Replacement Level
              +
              (0.03 * (1 - _gs / _games) + 0.12 * (_gs / _games))) *
          (_ip / 9));
    }

    // Calculation for non-pitchers
    else if (a.position != "P") {
      _runs = a.runs ?? 0;
      _outs = a.outs ?? 0;
      _oba = a.oba ?? 0;
      _pa = a.pa ?? 0;
      _cs = a.cs ?? 0;
      _sb = a.sb ?? 0;
      _singles = a.singles ?? 0;
      _walks = a.walks ?? 0;
      _hbp = a.hitByPitch ?? 0;
      _iw = a.intentionalWalks ?? 0;

      double runCS = 2 * (_runs / _outs) + 0.075;
      double lgwSB =
          (lgSB * 0.2 + lgCS * runCS) / (lg1B + lgBB + lgHBP - lgIBB);

      a.warValue = (
          // 1.254 wOBAScale
          (((_oba - lgwOBA) / 1.254) * _pa
                  // wsb
                  +
                  _sb * 0.2 +
                  _cs * runCS -
                  lgwSB * (_singles + _walks + _hbp - _iw)
                  // replacement Runs
                  +
                  (570 * (lgGames / 2430)) * (runsPerWin / lgPA) * _pa) /
              runsPerWin);
    }
  }
  return aeList;
}
