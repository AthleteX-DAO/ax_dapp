import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

/// {@template ax_data}
/// Holds `AthleteX` data: price, total supply, circulating supply and balance.
/// {@endtemplate}
class AxData extends Equatable {
  /// {@macro ax_data}
  const AxData({
    this.price,
    this.lastUpdated,
    this.totalSupply,
    this.circulatingSupply,
    this.balance,
  });

  /// Creates an [AxData] object from [AxMarketData], which supplies price,
  /// total supply and circulating supply.
  AxData.fromAxMarketData(AxMarketData axMarketData)
      : this(
          price: axMarketData.price,
          totalSupply: axMarketData.totalSupply,
          circulatingSupply: axMarketData.circulatingSupply,
          lastUpdated: axMarketData.lastUpdated,
        );

  /// `AthleteX` price.
  final double? price;

  /// `AthleteX` total supply.
  final double? totalSupply;

  /// `AthleteX` circulating supply.
  final double? circulatingSupply;

  /// `AthleteX` last updated time.
  final String? lastUpdated;

  /// `AthleteX` balance.
  final double? balance;

  /// Default [AxData].
  static const empty = AxData();

  @override
  List<Object?> get props =>
      [price, circulatingSupply, totalSupply, lastUpdated, balance];

  AxData copyWith({
    double? price,
    String? lastUpdated,
    double? totalSupply,
    double? circulatingSupply,
    double? balance,
  }) {
    return AxData(
      price: price ?? this.price,
      totalSupply: totalSupply ?? this.totalSupply,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      balance: balance ?? this.balance,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
