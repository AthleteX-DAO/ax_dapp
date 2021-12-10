import 'package:flutter/material.dart';
import 'package:ae_dapp/service/NFLAthlete.dart';
import 'dart:convert';

class NFLAthleteApi {
  static Future<List<NFLAthlete>> getAthletesLocally(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/data.json');
    final body = json.decode(data);
    return body.map<NFLAthlete>(NFLAthlete.fromJson).toList();
  }
}
