import 'package:ax_dapp/sports_markets/models/sx_markets_models/data.dart';

class SXMarket {
  SXMarket({
    required this.status,
    required this.data,
  });

  factory SXMarket.fromJson(Map<String, dynamic> json) {
    return SXMarket(
      status: json['status'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
  final String status;
  final Data data;
}
