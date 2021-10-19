import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AthleteApi {
  static Future<List<Athlete>> getAthletesLocally(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/data.json');
    final body = json.decode(data);

    return body.map<Athlete>(Athlete.fromJson).toList();
  }

  static Future<List<Athlete>> getAthletesFromApi(BuildContext context) async {
    final String component = "select * from nfl;";
    final String apiUrl =
        "http://54.38.139.134:9000/exect?${Uri.encodeComponent(component)}";

    var theResponseJSON = await http.get(Uri.parse(apiUrl));
    final body = json.decode(theResponseJSON.body);

    return body.map<Athlete>(Athlete.fromJson).toList();
  }
}
