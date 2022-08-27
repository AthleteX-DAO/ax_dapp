// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketData _$MarketDataFromJson(Map<String, dynamic> json) => MarketData(
      currentPrice: (json['current_price'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalValueLocked: json['total_value_locked'],
      marketCap: (json['market_cap'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalVolume: (json['total_volume'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      high24H: json['high_24h'] as Map<String, dynamic>?,
      low24H: json['low_24h'] as Map<String, dynamic>?,
      priceChange24H: (json['price_change_24h'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24H:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapChange24H:
          (json['market_cap_change_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapChangePercentage24H:
          (json['market_cap_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      totalSupply: (json['total_supply'] as num?)?.toDouble() ?? 0.0,
      maxSupply: (json['max_supply'] as num?)?.toDouble() ?? 0.0,
      circulatingSupply:
          (json['circulating_supply'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: json['last_updated'] as String,
    )..marketCapRank = json['market_cap_rank'];

Map<String, dynamic> _$MarketDataToJson(MarketData instance) =>
    <String, dynamic>{
      'currentPrice': instance.currentPrice,
      'totalValueLocked': instance.totalValueLocked,
      'marketCap': instance.marketCap,
      'marketCapRank': instance.marketCapRank,
      'totalVolume': instance.totalVolume,
      'high24H': instance.high24H,
      'low24H': instance.low24H,
      'priceChange24H': instance.priceChange24H,
      'priceChangePercentage24H': instance.priceChangePercentage24H,
      'marketCapChange24H': instance.marketCapChange24H,
      'marketCapChangePercentage24H': instance.marketCapChangePercentage24H,
      'totalSupply': instance.totalSupply,
      'maxSupply': instance.maxSupply,
      'circulatingSupply': instance.circulatingSupply,
      'lastUpdated': instance.lastUpdated,
    };
