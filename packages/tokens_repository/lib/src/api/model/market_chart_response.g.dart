// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_chart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketChartResponse _$MarketChartResponseFromJson(Map<String, dynamic> json) =>
    MarketChartResponse(
      prices: (json['prices'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      marketCaps: (json['market_caps'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      totalVolumes: (json['total_volumes'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

Map<String, dynamic> _$MarketChartResponseToJson(
        MarketChartResponse instance) =>
    <String, dynamic>{
      'prices': instance.prices,
      'market_caps': instance.marketCaps,
      'total_volumes': instance.totalVolumes,
    };
