import 'package:ax_dapp/markets/models/models.dart';
import 'package:tokens_repository/tokens_repository.dart';

class SportsMarketsModel extends MarketModel {
  const SportsMarketsModel({
    required this.id,
    required this.name,
    required super.typeOfMarket,
    required super.marketPrice,
    required super.recentPrice,
    required super.bookPrice,
  }) : super(id: id, name: name);

  @override
  final int id;
  @override
  final String name;

  static const empty = SportsMarketsModel(
    id: 0,
    name: '',
    typeOfMarket: SupportedMarkets.Sports,
    marketPrice: 0,
    recentPrice: 0,
    bookPrice: 0,
  );

  @override
  List<Object?> get props => [id, name, typeOfMarket, marketPrice];
}
