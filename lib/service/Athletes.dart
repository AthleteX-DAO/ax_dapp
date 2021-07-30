import 'dart:core';
import 'package:http/http.dart' as http;

abstract class Athletes {
   String? name;
   int? playerID;
   int? season;

  Athletes() {
    this.fetchAthletes();
    // this.name = "Athlete Name";
    // this.playerID = 00000000;
    // this.season = 0000;
  }

  void fetchAthletes() async {
    //TODO - break it up into sports / date / time etc
    final String key = "22c8f467077d4ff2a14c5b69e2355343";
    //Steps - get curent date + time, set value in playerUrl
    //2021-APR-04
    var year = DateTime.now().toLocal().year;

    /*
  String today =
      "$todayYear-$todayMonth-$todayDay"; //REMINDER: No data on Sunday
  */
    // Tracks player stats by date

    final Uri playerUrl = Uri.parse(
        "https://fly.sportsdata.io/v3/mlb/stats/json/PlayerSeasonStats/$year?key=$key");
    final playerResult = await http.get(playerUrl);
    var allAthletes = "";
  }

  getPrice();
}
