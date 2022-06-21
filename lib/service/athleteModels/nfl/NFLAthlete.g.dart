// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NFLAthlete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFLAthlete _$NFLAthleteFromJson(Map<String, dynamic> json) => NFLAthlete(
      id: json['id'] as int,
      name: json['name'] as String,
      team: json['team'] as String,
      position: json['position'] as String,
      passingYards: (json['passingYards'] as num).toDouble(),
      passingTouchDowns: (json['passingTouchDowns'] as num).toDouble(),
      reception: (json['reception'] as num).toDouble(),
      receiveYards: (json['receiveYards'] as num).toDouble(),
      receiveTouch: (json['receiveTouch'] as num).toDouble(),
      rushingYards: (json['rushingYards'] as num).toDouble(),
      offensiveSnapsPlayed: (json['OffensiveSnapsPlayed'] as num).toDouble(),
      defensiveSnapsPlayed: (json['DefensiveSnapsPlayed'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      timeStamp: json['timeStamp'] as String,
    );

Map<String, dynamic> _$NFLAthleteToJson(NFLAthlete instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'team': instance.team,
      'position': instance.position,
      'price': instance.price,
      'timeStamp': instance.timeStamp,
      'passingYards': instance.passingYards,
      'passingTouchDowns': instance.passingTouchDowns,
      'reception': instance.reception,
      'receiveYards': instance.receiveYards,
      'receiveTouch': instance.receiveTouch,
      'rushingYards': instance.rushingYards,
      'OffensiveSnapsPlayed': instance.offensiveSnapsPlayed,
      'DefensiveSnapsPlayed': instance.defensiveSnapsPlayed,
    };
