import 'package:shared/shared.dart';
import 'package:tokens_repository/src/api/model/market_data.dart';

part 'coin_data.g.dart';

/// Coin data
@JsonSerializable()
class CoinData {
  /// {@macro coin_data}
  CoinData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.marketData,
    required this.lastUpdated,
  });

  /// A necessary factory constructor for creating a new [CoinData] instance
  factory CoinData.fromJson(Map<String, dynamic> json) =>
      _$CoinDataFromJson(json);

  /// gets the [id] for the coin
  String id;

  /// gets the [symbol] for the coin
  String symbol;

  /// gets the [name] for the coin
  String name;

  /// gets the [image] for the coin
  Image? image;

  /// gets the [marketData] for the coin
  MarketData? marketData;

  /// gets the [lastUpdated] for the coin
  String? lastUpdated;

  /// Serialization for the [CoinData] class
  Map<String, dynamic> toJson() => _$CoinDataToJson(this);
}

/// Image data
class Image {
  /// {@macro image_data}
  Image({
    required this.thumb,
    required this.small,
    required this.large,
  });

  /// A necessary factory constructor for creating a new [Image] instance
  factory Image.fromJson(Map<String, String> json) => Image(
        thumb: json['thumb'] ?? '',
        small: json['small'] ?? '',
        large: json['large'] ?? '',
      );

  /// gets the thumbnail of image
  String thumb;

  /// gets the smallet version of the image
  String small;

  /// gets the larger version of the image
  String large;

  /// Serialization for the [Image] class
  Map<String, dynamic> toJson() => {
        'thumb': thumb,
        'small': small,
        'large': large,
      };
}
