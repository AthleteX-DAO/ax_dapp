import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AthleteApi {
  static final String _baseURL = 'https://db.athletex.io';
  static final int mStaffordId = 9038;
  static final int jChaseId = 22564;
  static final int jBurrowId = 21693;
  static final int cKuppId = 18882;
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
    List<String> athleteIDs = [
      mStaffordId.toString(),
      jChaseId.toString(),
      jBurrowId.toString(),
      cKuppId.toString()
    ];
    final List<Athlete> athletesList = [];
    for (String id in athleteIDs) {
      final athleteResponse =
          await http.get(Uri.parse('$_baseURL/nfl/players/$id'));

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

  static Future<List<Athlete>> getAthletesFromIdsDict(
      BuildContext context) async {
    Map<String, List<int>> athleteIdDict = {
      "ids": [mStaffordId, jChaseId, jBurrowId, cKuppId],
    };
    final jsonRequestBody = json.encode(athleteIdDict);
    print(jsonRequestBody);

    final uri = Uri.parse('$_baseURL/nfl/players');
    final athleteResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: jsonRequestBody);
    print(athleteResponse.statusCode);

    if (athleteResponse.statusCode == 200) {
      var athleteResponseList = jsonDecode(athleteResponse.body) as List;
      return athleteResponseList
          .map((athlete) => Athlete.fromJson(athlete))
          .toList();
    } else {
      throw Exception("Failed to load athlete");
    }
  }
}
