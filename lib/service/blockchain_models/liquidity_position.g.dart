// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liquidity_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiquidityPosition _$LiquidityPositionFromJson(Map<String, dynamic> json) =>
    LiquidityPosition(
      TokenPair.fromJson(json['pair'] as Map<String, dynamic>),
      json['liquidityTokenBalance'] as String,
    );

Map<String, dynamic> _$LiquidityPositionToJson(LiquidityPosition instance) =>
    <String, dynamic>{
      'liquidityTokenBalance': instance.liquidityTokenBalance,
      'pair': instance.pair.toJson(),
    };
