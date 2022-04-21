// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MLBPAthleteStats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLBAthleteStats _$MLBAthleteStatsFromJson(Map<String, dynamic> json) =>
    MLBAthleteStats(
      id: json['id'] as int,
      name: json['name'] as String,
      team: json['team'] as String,
      position: json['position'] as String,
      statHistory: (json['stat_history'] as List<dynamic>)
          .map((e) => MLBStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MLBAthleteStatsToJson(MLBAthleteStats instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'team': instance.team,
      'position': instance.position,
      'stat_history': instance.statHistory.map((e) => e.toJson()).toList(),
    };
