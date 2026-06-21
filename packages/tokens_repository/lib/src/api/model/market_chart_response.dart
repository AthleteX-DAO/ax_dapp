import 'package:json_annotation/json_annotation.dart';

part 'market_chart_response.g.dart';

@JsonSerializable()
class MarketChartResponse {
  MarketChartResponse({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });

  factory MarketChartResponse.fromJson(Map<String, dynamic> json) =>
      _$MarketChartResponseFromJson(json);

  final List<List<double>> prices;
  @JsonKey(name: 'market_caps')
  final List<List<double>> marketCaps;
  @JsonKey(name: 'total_volumes')
  final List<List<double>> totalVolumes;

  Map<String, dynamic> toJson() => _$MarketChartResponseToJson(this);
}
