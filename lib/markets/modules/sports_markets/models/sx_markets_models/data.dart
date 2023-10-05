import 'package:ax_dapp/markets/modules/sports_markets/models/sx_markets_models/market.dart';

class Data {
  Data({
    required this.markets,
    required this.nextKey,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      markets: (json['markets'] as List<dynamic>)
          .map((e) => Market.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextKey: json['nextKey'] as String,
    );
  }
  
  final List<Market> markets;
  final String nextKey;
}
