import 'package:equatable/equatable.dart';

/// {@template uniswap_price}
/// Represents a price data point from Uniswap V3.
/// {@endtemplate}
class UniswapPrice extends Equatable {
  /// {@macro uniswap_price}
  const UniswapPrice({
    required this.priceUSD,
    required this.token0Price,
    required this.token1Price,
    required this.timestamp,
    required this.liquidity,
    this.volume24h,
    this.priceChange24h,
  });

  /// Price in USD
  final double priceUSD;

  /// Price of token0 in terms of token1
  final double token0Price;

  /// Price of token1 in terms of token0
  final double token1Price;

  /// Timestamp of the price data
  final DateTime timestamp;

  /// Total liquidity in the pool
  final double liquidity;

  /// 24-hour trading volume
  final double? volume24h;

  /// 24-hour price change percentage
  final double? priceChange24h;

  /// Empty price
  static final empty = UniswapPrice(
    priceUSD: 0,
    token0Price: 0,
    token1Price: 0,
    timestamp: _kEmptyDateTime,
    liquidity: 0,
  );

  static final _kEmptyDateTime = DateTime.utc(1970);

  @override
  List<Object?> get props => [
        priceUSD,
        token0Price,
        token1Price,
        timestamp,
        liquidity,
        volume24h,
        priceChange24h,
      ];
}

/// {@template historical_price}
/// Represents historical price data for charting.
/// {@endtemplate}
class HistoricalPrice extends Equatable {
  /// {@macro historical_price}
  const HistoricalPrice({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  @override
  List<Object?> get props => [timestamp, open, high, low, close, volume];
}
