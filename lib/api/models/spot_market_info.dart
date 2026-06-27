class SpotMarketInfo {
  const SpotMarketInfo({
    required this.marketId,
    required this.symbol,
    required this.synthAddress,
    required this.name,
  });

  factory SpotMarketInfo.fromJson(Map<String, dynamic> json) {
    return SpotMarketInfo(
      marketId: json['market_id'] as int,
      symbol: json['symbol'] as String? ?? '',
      synthAddress: json['synth_address'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  final int marketId;
  final String symbol;
  final String synthAddress;
  final String name;
}
