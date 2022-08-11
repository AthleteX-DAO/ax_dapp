import 'package:shared/shared.dart';

/// {@template ax_market_data}
/// Holds `AthleteX` market data.
/// {@endtemplate}
class AxMarketData extends Equatable {
  /// {@macro ax_market_data}
  const AxMarketData({
    this.price,
    this.totalSupply,
    this.circulatingSupply,
  });

  /// `AthleteX` price.
  final double? price;

  /// `AthleteX` total supply.
  final double? totalSupply;

  /// `AthleteX` circulating supply.
  final double? circulatingSupply;

  /// Default [AxMarketData].
  static const empty = AxMarketData();

  @override
  List<Object?> get props => [price, totalSupply, circulatingSupply];
}
