// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfl_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFLStats _$NFLStatsFromJson(Map<String, dynamic> json) => NFLStats(
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

Map<String, dynamic> _$NFLStatsToJson(NFLStats instance) => <String, dynamic>{
      'passingYards': instance.passingYards,
      'passingTouchDowns': instance.passingTouchDowns,
      'reception': instance.reception,
      'receiveYards': instance.receiveYards,
      'receiveTouch': instance.receiveTouch,
      'rushingYards': instance.rushingYards,
      'OffensiveSnapsPlayed': instance.offensiveSnapsPlayed,
      'DefensiveSnapsPlayed': instance.defensiveSnapsPlayed,
      'price': instance.price,
      'timeStamp': instance.timeStamp,
    };
