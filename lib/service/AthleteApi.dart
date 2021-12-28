import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'dart:convert';

class AthleteApi {
  static Future<List<Athlete>> getAthletesLocally(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('assets/data.json');
    final body = json.decode(data);

    return body.map<Athlete>(Athlete.fromJson).toList();
  }
}