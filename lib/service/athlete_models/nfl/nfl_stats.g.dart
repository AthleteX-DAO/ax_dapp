// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfl_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFLStats _$NFLStatsFromJson(Map<String, dynamic> json) => NFLStats(
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

Map<String, dynamic> _$NFLStatsToJson(NFLStats instance) => <String, dynamic>{
      'passingYards': instance.passingYards,
      'passingTouchdowns': instance.passingTouchdowns,
      'reception': instance.reception,
      'receivingYards': instance.receivingYards,
      'receivingTouchdowns': instance.receivingTouchdowns,
      'rushingYards': instance.rushingYards,
      'offensiveSnapsPlayed': instance.offensiveSnapsPlayed,
      'defensiveSnapsPlayed': instance.defensiveSnapsPlayed,
      'price': instance.price,
      'timestamp': instance.timeStamp,
    };
