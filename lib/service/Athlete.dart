import 'package:flutter/material.dart';

const COLLATERALIZATION_MULTIPLIER = 1000;

class Athlete {
  final String name;
  final int id;
  final String team;
  final String position;
  final double passingYards;
  final double passingTouchDowns;
  final double reception;
  final double receiveYards;
  final double receiveTouch;
  final double rushingYards;
  final double war;
  final double scaledPrice;
  final String time;

  const Athlete({
    required this.name,
    required this.id,
    required this.team,
    required this.position,
    required this.passingYards,
    required this.passingTouchDowns,
    required this.reception,
    required this.receiveYards,
    required this.receiveTouch,
    required this.rushingYards,
    required this.war,
    required this.scaledPrice,
    required this.time,
  });

  static Athlete fromJson(json) => Athlete(
      name: json['name'],
      id: json['id'],
      team: json['team'],
      position: json['position'],
      passingYards: json['passingYards'],
      passingTouchDowns: json['passingTouchDowns'],
      reception: json['reception'],
      receiveYards: json['receiveYards'],
      receiveTouch: json['receiveTouch'],
      rushingYards: json['rushingYards'],
      time: json['timestamp'],
      war: json['price'],
      scaledPrice: json['price'] * COLLATERALIZATION_MULTIPLIER);

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold) if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }
}
