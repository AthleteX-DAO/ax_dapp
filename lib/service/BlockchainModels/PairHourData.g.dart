// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PairHourData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairHourData _$PairHourDataFromJson(Map<String, dynamic> json) => PairHourData(
      json['hourStartUnix'] as String,
      TokenPair.fromJson(json['pair'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PairHourDataToJson(PairHourData instance) =>
    <String, dynamic>{
      'hourStartUnix': instance.hourStartUnix,
      'pair': instance.pair.toJson(),
    };
