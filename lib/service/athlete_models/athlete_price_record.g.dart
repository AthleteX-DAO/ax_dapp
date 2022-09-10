// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete_price_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AthletePriceRecord _$AthletePriceRecordFromJson(Map<String, dynamic> json) =>
    AthletePriceRecord(
      id: json['id'] as int,
      name: json['name'] as String,
      priceHistory: (json['price_history'] as List<dynamic>)
          .map((e) => PriceRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AthletePriceRecordToJson(AthletePriceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price_history': instance.priceHistory.map((e) => e.toJson()).toList(),
    };
