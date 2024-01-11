// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_price_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictionPriceRecord _$PredictionPriceRecordFromJson(
        Map<String, dynamic> json) =>
    PredictionPriceRecord(
      id: json['id'] as int,
      name: json['name'] as String,
      priceHistory: (json['price_history'] as List<dynamic>)
          .map((e) => PriceRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PredictionPriceRecordToJson(
        PredictionPriceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price_history': instance.priceHistory.map((e) => e.toJson()).toList(),
    };
