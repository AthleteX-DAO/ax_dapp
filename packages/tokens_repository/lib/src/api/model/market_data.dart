import 'package:shared/shared.dart';

part 'market_data.g.dart';
/// Market Coin Data
@JsonSerializable()
class MarketData {
  /// {@macro market_data}
  MarketData({
    required this.currentPrice,
    this.totalValueLocked,
    required this.marketCap,
    required this.totalVolume,
    required this.high24H,
    required this.low24H,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
    required this.marketCapChange24H,
    required this.marketCapChangePercentage24H,
    required this.totalSupply,
    required this.maxSupply,
    required this.circulatingSupply,
    required this.lastUpdated,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) =>
      _$MarketDataFromJson(json);

  Map<String, double>? currentPrice;
  dynamic totalValueLocked;
  Map<String, double>? marketCap;
  dynamic marketCapRank;
  Map<String, double>? totalVolume;
  Map<String, dynamic>? high24H;
  Map<String, dynamic>? low24H;
  double priceChange24H;
  double priceChangePercentage24H;
  double marketCapChange24H;
  double marketCapChangePercentage24H;
  double totalSupply;
  double maxSupply;
  double circulatingSupply;
  String lastUpdated;

  Map<String, dynamic> toJson() => _$MarketDataToJson(this);
}
