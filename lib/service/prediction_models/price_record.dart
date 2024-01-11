import 'package:json_annotation/json_annotation.dart';

part 'price_record.g.dart';

@JsonSerializable()
class PriceRecord {
  const PriceRecord({
    required this.price,
    required this.timestamp,
  });

  factory PriceRecord.fromJson(Map<String, dynamic> json) =>
      _$PriceRecordFromJson(json);

  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'timestamp')
  final String timestamp;

  Map<String, dynamic> toJson() => _$PriceRecordToJson(this);
}
