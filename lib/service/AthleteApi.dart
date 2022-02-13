import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AthleteApi {
  static Future<List<Athlete>> getAthletesLocally(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/data.json');
    final body = json.decode(data);
    //print(body);
    return body.map<Athlete>(Athlete.fromJson).toList();
  }

  static List<Athlete> parseAthletes(var athleteResponse) {
    final parsed = json.decode(athleteResponse).cast<Map<String, dynamic>>();
    return parsed.map<Athlete>((json) => Athlete.fromJson(json)).toList();
  }

  static Future<List<Athlete>> getAthletesFromIdList(
      BuildContext context) async {
    List<String> athleteIDs = ['9038', '22564', '21693', '18882'];
    final List<Athlete> athletesList = [];
    for (String id in athleteIDs) {
      final athleteResponse =
          await http.get(Uri.parse('https://db.athletex.io/nfl/players/$id'));

      print(athleteResponse.statusCode);

      if (athleteResponse.statusCode == 200) {
        var athlete = Athlete.fromJson(jsonDecode(athleteResponse.body));
        athletesList.add(athlete);
      } else {
        throw Exception("Failed to load athlete");
      }
    }
    print(athletesList);
    return athletesList;
  }
}
