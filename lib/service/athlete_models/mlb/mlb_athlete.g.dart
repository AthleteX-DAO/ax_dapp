// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mlb_athlete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLBAthlete _$MLBAthleteFromJson(Map<String, dynamic> json) => MLBAthlete(
      id: json['id'] as int,
      name: json['name'] as String,
      team: json['team'] as String,
      position: json['position'] as String,
      games: (json['games'] as num).toDouble(),
      errors: (json['errors'] as num).toDouble(),
      stolenBases: (json['stolenBases'] as num).toDouble(),
      plateAppearances: (json['plateAppearances'] as num).toDouble(),
      weightedOnBasePercentage:
          (json['weightedOnBasePercentage'] as num).toDouble(),
      homeRuns: (json['HomeRuns'] as num).toDouble(),
      strikeouts: (json['Strikeouts'] as num).toDouble(),
      saves: (json['Saves'] as num).toDouble(),
      atBats: (json['AtBats'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      timeStamp: json['timestamp'] as String,
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
      'errors': instance.errors,
      'stolenBases': instance.stolenBases,
      'plateAppearances': instance.plateAppearances,
      'weightedOnBasePercentage': instance.weightedOnBasePercentage,
      'HomeRuns': instance.homeRuns,
      'Strikeouts': instance.strikeouts,
      'Saves': instance.saves,
      'AtBats': instance.atBats,
    };
