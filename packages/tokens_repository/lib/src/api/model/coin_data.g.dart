// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinData _$CoinDataFromJson(Map<String, dynamic> json) => CoinData(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] == null
          ? null
          : Image.fromJson(Map<String, String>.from(json['image'] as Map)),
      marketData: json['market_data'] == null
          ? null
          : MarketData.fromJson(json['market_data'] as Map<String, dynamic>),
      lastUpdated: json['last_updated'] as String?,
    );

Map<String, dynamic> _$CoinDataToJson(CoinData instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'marketData': instance.marketData,
      'lastUpdated': instance.lastUpdated,
    };
