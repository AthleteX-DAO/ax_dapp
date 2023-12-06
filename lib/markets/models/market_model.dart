import 'package:ax_dapp/markets/markets.dart';
import 'package:shared/shared.dart';

/// {@template market_model}
/// A base class to facilitate interopability between different Markets
/// {@endtemplate}
class MarketModel extends Equatable {
  const MarketModel({
    required this.id,
    required this.name,
    required this.marketHash,
    required this.typeOfMarket,
  });

  final int id;
  final String name;
  final String marketHash;
  final SupportedMarkets typeOfMarket;

  @override
  List<Object?> get props => [
        id,
        name,
        marketHash,
        typeOfMarket,
      ];

  // this purpose of this line is to generate some fake data because we don't
  // have any history of price at the moment
  // this.percentage = new Random().nextDouble() > 0.5 ? new Random().nextDouble
  // () : -1 * new Random().nextDouble();
}
