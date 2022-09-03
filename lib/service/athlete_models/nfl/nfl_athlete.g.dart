// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfl_athlete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFLAthlete _$NFLAthleteFromJson(Map<String, dynamic> json) => NFLAthlete(
      id: json['id'] as int,
      name: json['name'] as String,
      team: json['team'] as String,
      position: json['position'] as String,
      passingYards: (json['passingYards'] as num).toDouble(),
      passingTouchdowns: (json['passingTouchdowns'] as num).toDouble(),
      reception: (json['reception'] as num).toDouble(),
      receivingYards: (json['receivingYards'] as num).toDouble(),
      receivingTouchdowns: (json['receivingTouchdowns'] as num).toDouble(),
      rushingYards: (json['rushingYards'] as num).toDouble(),
      offensiveSnapsPlayed: (json['offensiveSnapsPlayed'] as num).toDouble(),
      defensiveSnapsPlayed: (json['defensiveSnapsPlayed'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      timeStamp: json['timestamp'] as String,
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
      'offensiveSnapsPlayed': instance.offensiveSnapsPlayed,
      'defensiveSnapsPlayed': instance.defensiveSnapsPlayed,
    };
