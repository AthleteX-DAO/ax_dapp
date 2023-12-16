// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceRecord _$PriceRecordFromJson(Map<String, dynamic> json) => PriceRecord(
      price: (json['price'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$PriceRecordToJson(PriceRecord instance) =>
    <String, dynamic>{
      'price': instance.price,
      'timestamp': instance.timestamp,
    };
