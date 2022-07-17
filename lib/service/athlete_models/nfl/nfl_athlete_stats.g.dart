// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfl_athlete_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFLAthleteStats _$NFLAthleteStatsFromJson(Map<String, dynamic> json) =>
    NFLAthleteStats(
      id: json['id'] as int,
      name: json['name'] as String,
      team: json['team'] as String,
      position: json['position'] as String,
      statHistory: (json['stat_history'] as List<dynamic>)
          .map((e) => NFLStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NFLAthleteStatsToJson(NFLAthleteStats instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'team': instance.team,
      'position': instance.position,
      'stat_history': instance.statHistory.map((e) => e.toJson()).toList(),
    };
