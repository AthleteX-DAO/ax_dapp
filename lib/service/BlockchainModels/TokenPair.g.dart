// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TokenPair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => TokenPair(
      json['id'] as String,
      json['name'] as String,
      json['reserve0'] as String,
      json['reserve1'] as String,
      Token.fromJson(json['token0'] as Map<String, dynamic>),
      Token.fromJson(json['token1'] as Map<String, dynamic>),
      json['token0Price'] as String,
      json['token1Price'] as String,
    );

Map<String, dynamic> _$TokenPairToJson(TokenPair instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reserve0': instance.reserve0,
      'reserve1': instance.reserve1,
      'token0Price': instance.token0Price,
      'token1Price': instance.token1Price,
      'token0': instance.token0.toJson(),
      'token1': instance.token1.toJson(),
    };
