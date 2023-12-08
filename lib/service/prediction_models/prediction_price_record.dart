import 'package:ax_dapp/service/athlete_models/price_record.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prediction_price_record.jg.dart';

@JsonSerializable()
class PredictionPriceRecord {
  const PredictionPriceRecord({
    required this.id,
    required this.name,
    required this.priceHistory,
  });

  factory PredictionPriceRecord.fromJson(Map<String, dynamic> json) =>
      _$PredictionPriceRecordfromJson(json);

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'price_history')
  final List<PriceRecord> priceHistory;

  Map<String, dynamic> toJson() => _$PredictionPriceRecordfromJson(this);
}
