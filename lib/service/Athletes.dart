import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Athlete {
  String? name;
  List? history;

  Athlete({@required this.name, @required this.history});

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
        name: json['name'],
        history:
            json['history']); // this should be updated with the latest data
  }
}
