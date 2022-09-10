import 'package:ax_dapp/service/athlete_models/price_record.dart';
import 'package:json_annotation/json_annotation.dart';

part 'athlete_price_record.g.dart';

@JsonSerializable()
class AthletePriceRecord {
  const AthletePriceRecord({
    required this.id,
    required this.name,
    required this.priceHistory,
  });

  factory AthletePriceRecord.fromJson(Map<String, dynamic> json) =>
      _$AthletePriceRecordFromJson(json);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'price_history')
  final List<PriceRecord> priceHistory;

  Map<String, dynamic> toJson() => _$AthletePriceRecordToJson(this);
}
