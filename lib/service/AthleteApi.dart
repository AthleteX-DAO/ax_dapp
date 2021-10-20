import 'dart:io';

import 'package:ae_dapp/service/Athlete.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AthleteApi {
  Future<dynamic> getAthletesLocally() async {
    File assetBundle = new File('assets/data.json');
    var data = assetBundle.readAsLines();
    final body = await data;

    return body.map<Athlete>(Athlete.fromJson).toList();
  }

  void fetchData() async {
    final queryParams = {
      'query': 'select * from nfl;',
    };
    final url = Uri.http('54.38.139.134:9000', '/exec?', queryParams);
    final response = await get(url);
    print(response.body);
  }
}
