// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AptPair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AptPair _$AptPairFromJson(Map<String, dynamic> json) => AptPair(
      json['id'] as String,
      json['name'] as String,
      json['reserve0'] as String,
      json['reserve1'] as String,
      Token.fromJson(json['token0'] as Map<String, dynamic>),
      Token.fromJson(json['token1'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AptPairToJson(AptPair instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reserve0': instance.reserve0,
      'reserve1': instance.reserve1,
      'token0': instance.token0.toJson(),
      'token1': instance.token1.toJson(),
    };
