// import 'package:flutter/material.dart';

class Athlete {
  final String name;

  const Athlete({required this.name});

  static Athlete fromJson(json) => Athlete(name: json['name']);
}
