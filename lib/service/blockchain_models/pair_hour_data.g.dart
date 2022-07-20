// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_hour_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairHourData _$PairHourDataFromJson(Map<String, dynamic> json) => PairHourData(
      json['hourStartUnix'] as int,
      json['reserve0'] as String,
      json['reserve1'] as String,
      TokenPair.fromJson(json['pair'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PairHourDataToJson(PairHourData instance) =>
    <String, dynamic>{
      'hourStartUnix': instance.hourStartUnix,
      'reserve0': instance.reserve0,
      'reserve1': instance.reserve1,
      'pair': instance.pair.toJson(),
    };
