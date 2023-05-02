// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mlb_athlete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLBAthlete _$MLBAthleteFromJson(Map<String, dynamic> json) => MLBAthlete(
      id: json['ID'] as int,
      name: json['Name'] as String,
      team: json['Team'] as String,
      position: json['Position'] as String,
      games: (json['Games'] as num).toDouble(),
      atBats: (json['AtBats'] as num).toDouble(),
      homeRuns: (json['HomeRuns'] as num).toDouble(),
      errors: (json['Errors'] as num).toDouble(),
      saves: (json['Saves'] as num).toDouble(),
      strikeouts: (json['Strikeouts'] as num).toDouble(),
      stolenBases: (json['StolenBases'] as num).toDouble(),
      plateAppearances: (json['PlateAppearances'] as num).toDouble(),
      weightedOnBasePercentage:
          (json['WeightedOnBasePercentage'] as num).toDouble(),
      price: (json['BookPrice'] as num).toDouble(),
      timeStamp: json['Time'] as String,
    );

Map<String, dynamic> _$MLBAthleteToJson(MLBAthlete instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'team': instance.team,
      'position': instance.position,
      'price': instance.price,
      'timestamp': instance.timeStamp,
      'games': instance.games,
      'atBats': instance.atBats,
      'homeRuns': instance.homeRuns,
      'errors': instance.errors,
      'saves': instance.saves,
      'strikeouts': instance.strikeouts,
      'stolenBases': instance.stolenBases,
      'plateAppearances': instance.plateAppearances,
      'weightedOnBasePercentage': instance.weightedOnBasePercentage,
    };
