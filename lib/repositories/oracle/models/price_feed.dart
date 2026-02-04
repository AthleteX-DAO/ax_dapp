import 'package:equatable/equatable.dart';

/// Immutable price feed data model
/// Represents a single price from any oracle source
class PriceFeed extends Equatable {
  const PriceFeed({
    required this.symbol,
    required this.price,
    required this.decimals,
    required this.timestamp,
    required this.source,
    this.confidence,
    this.rawData,
  });

  /// Asset symbol (e.g., 'ETH', 'BTC', 'USDC')
  final String symbol;

  /// Price as a decimal value (e.g., 2543.25 for ETH)
  /// Stored as BigInt internally with decimal adjustment for precision
  final double price;

  /// Number of decimal places for precision
  /// Chainlink: 8 decimals
  /// Pyth: 8 decimals
  /// Custom: varies
  final int decimals;

  /// When the price was fetched (Unix timestamp in milliseconds)
  final int timestamp;

  /// Source of the price data
  final PriceFeedSource source;

  /// Confidence interval (for Pyth feeds)
  /// Represents the range of uncertainty around the price
  final double? confidence;

  /// Raw response data for debugging
  /// Contains the full response from the oracle
  final Map<String, dynamic>? rawData;

  /// Whether this price data is still fresh
  /// Based on configured staleness threshold
  bool isFresh(Duration stalenessDuration) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - timestamp < stalenessDuration.inMilliseconds;
  }

  /// Age of the price in seconds
  int get ageSeconds {
    final now = DateTime.now().millisecondsSinceEpoch;
    return ((now - timestamp) / 1000).round();
  }

  /// Formatted price with symbol and decimals
  String get formattedPrice {
    return '$price ${symbol.toUpperCase()}';
  }

  /// For Pyth: confidence as percentage of price
  double? get confidencePercentage {
    if (confidence == null || price == 0) return null;
    return (confidence! / price) * 100;
  }

  /// Copy constructor for immutability
  PriceFeed copyWith({
    String? symbol,
    double? price,
    int? decimals,
    int? timestamp,
    PriceFeedSource? source,
    double? confidence,
    Map<String, dynamic>? rawData,
  }) {
    return PriceFeed(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      decimals: decimals ?? this.decimals,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      confidence: confidence ?? this.confidence,
      rawData: rawData ?? this.rawData,
    );
  }

  @override
  List<Object?> get props => [
        symbol,
        price,
        decimals,
        timestamp,
        source,
        confidence,
        rawData,
      ];

  @override
  String toString() {
    return 'PriceFeed('
        'symbol: $symbol, '
        'price: $price, '
        'decimals: $decimals, '
        'age: ${ageSeconds}s, '
        'source: ${source.name}, '
        'confidence: $confidence)';
  }
}

enum PriceFeedSource {
  chainlink,
  pyth,
  optimisticZk,
  custom,
}
