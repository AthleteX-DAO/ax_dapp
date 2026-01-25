import 'package:equatable/equatable.dart';

class SpotMarketModel extends Equatable {
  const SpotMarketModel({
    required this.symbol,
    required this.currentPrice,
    required this.change24h,
    required this.high24h,
    required this.low24h,
    required this.volume24h,
  });

  final String symbol;
  final double currentPrice;
  final double change24h;
  final double high24h;
  final double low24h;
  final double volume24h;

  @override
  List<Object?> get props => [
        symbol,
        currentPrice,
        change24h,
        high24h,
        low24h,
        volume24h,
      ];

  SpotMarketModel copyWith({
    String? symbol,
    double? currentPrice,
    double? change24h,
    double? high24h,
    double? low24h,
    double? volume24h,
  }) {
    return SpotMarketModel(
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      change24h: change24h ?? this.change24h,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      volume24h: volume24h ?? this.volume24h,
    );
  }
}
