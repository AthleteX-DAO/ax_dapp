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
      started: (json['started'] as num).toDouble(),
      games: (json['games'] as num).toDouble(),
      atBats: (json['atBats'] as num).toDouble(),
      runs: (json['runs'] as num).toDouble(),
      singles: (json['singles'] as num).toDouble(),
      triples: (json['triples'] as num).toDouble(),
      homeRuns: (json['homeRuns'] as num).toDouble(),
      inningsPlayed: (json['inningsPlayed'] as num).toDouble(),
      battingAverage: (json['battingAverage'] as num).toDouble(),
      outs: (json['outs'] as num).toDouble(),
      walks: (json['walks'] as num).toDouble(),
      errors: (json['errors'] as num).toDouble(),
      saves: (json['saves'] as num).toDouble(),
      strikeOuts: (json['strikeOuts'] as num).toDouble(),
      stolenBases: (json['stolenBases'] as num).toDouble(),
      plateAppearances: (json['plateAppearances'] as num).toDouble(),
      weightedOnBasePercentage:
          (json['weightedOnBasePercentage'] as num).toDouble(),
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
      'timeStamp': instance.timeStamp,
      'started': instance.started,
      'games': instance.games,
      'atBats': instance.atBats,
      'runs': instance.runs,
      'singles': instance.singles,
      'triples': instance.triples,
      'homeRuns': instance.homeRuns,
      'inningsPlayed': instance.inningsPlayed,
      'battingAverage': instance.battingAverage,
      'outs': instance.outs,
      'walks': instance.walks,
      'errors': instance.errors,
      'saves': instance.saves,
      'strikeOuts': instance.strikeOuts,
      'stolenBases': instance.stolenBases,
      'plateAppearances': instance.plateAppearances,
      'weightedOnBasePercentage': instance.weightedOnBasePercentage,
    };
