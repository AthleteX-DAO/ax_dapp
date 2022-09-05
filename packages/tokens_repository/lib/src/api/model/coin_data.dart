import 'package:shared/shared.dart';
import 'package:tokens_repository/src/api/model/market_data.dart';

part 'coin_data.g.dart';

@JsonSerializable()
class CoinData {
  CoinData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.marketData,
    required this.lastUpdated,
  });

  factory CoinData.fromJson(Map<String, dynamic> json) =>
      _$CoinDataFromJson(json);

  String id;
  String symbol;
  String name;
  Image? image;
  MarketData? marketData;
  String? lastUpdated;

  Map<String, dynamic> toJson() => _$CoinDataToJson(this);
}

class Image {
  Image({
    required this.thumb,
    required this.small,
    required this.large,
  });

  factory Image.fromJson(Map<String, String> json) => Image(
        thumb: json['thumb'] ?? '',
        small: json['small'] ?? '',
        large: json['large'] ?? '',
      );

  String thumb;
  String small;
  String large;

  Map<String, dynamic> toJson() => {
        'thumb': thumb,
        'small': small,
        'large': large,
      };
}
