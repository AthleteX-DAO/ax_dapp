// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfl_athlete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFLAthlete _$NFLAthleteFromJson(Map<String, dynamic> json) => NFLAthlete(
      id: json['ID'] as int,
      name: json['Name'] as String,
      team: json['Team'] as String,
      position: json['Position'] as String,
      passingYards: (json['PassingYards'] as num).toDouble(),
      passingTouchdowns: (json['PassingTouchdowns'] as num).toDouble(),
      reception: (json['Receptions'] as num).toDouble(),
      receivingYards: (json['ReceivingYards'] as num).toDouble(),
      receivingTouchdowns: (json['ReceivingTouchdowns'] as num).toDouble(),
      rushingYards: (json['RushingYards'] as num).toDouble(),
      price: (json['BookPrice'] as num).toDouble(),
      timeStamp: json['Time'] as String,
    );

Map<String, dynamic> _$NFLAthleteToJson(NFLAthlete instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'team': instance.team,
      'position': instance.position,
      'price': instance.price,
      'timestamp': instance.timeStamp,
      'passingYards': instance.passingYards,
      'passingTouchdowns': instance.passingTouchdowns,
      'reception': instance.reception,
      'receivingYards': instance.receivingYards,
      'receivingTouchdowns': instance.receivingTouchdowns,
      'rushingYards': instance.rushingYards,
    };
