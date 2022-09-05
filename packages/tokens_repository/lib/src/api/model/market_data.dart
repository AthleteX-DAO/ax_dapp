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

  /// A necessary factory constructor for creating a new [MarketData] instance
  factory MarketData.fromJson(Map<String, dynamic> json) =>
      _$MarketDataFromJson(json);

  /// gets the [currentPrice] of the token
  Map<String, double>? currentPrice;

  /// gets the [totalValueLocked] of the token
  dynamic totalValueLocked;

  /// gets the [marketCap] of the token
  Map<String, double>? marketCap;

  /// gets the [marketCapRank] of the token
  dynamic marketCapRank;

  /// gets the [totalVolume] of the token
  Map<String, double>? totalVolume;

  /// gets the highest token price for the last 24 hours
  Map<String, dynamic>? high24H;

  /// gets the lowest token price for the last 24 hours
  Map<String, dynamic>? low24H;

  /// gets the [priceChange24H] of the token
  double priceChange24H;

  /// gets the [priceChangePercentage24H] of the token
  double priceChangePercentage24H;

  /// gets the [marketCapChange24H] of the token
  double marketCapChange24H;

  /// gets the [marketCapChange24H] of the token
  double marketCapChangePercentage24H;

  /// gets the [totalSupply] of the token
  double totalSupply;

  /// gets the [maxSupply] of the token
  double maxSupply;

  /// gets the [circulatingSupply] of the token
  double circulatingSupply;

  /// gets the [lastUpdated] of the token
  String lastUpdated;

  /// Serialization for the [MarketData] class
  Map<String, dynamic> toJson() => _$MarketDataToJson(this);
}
