import 'package:ax_dapp/markets/models/models.dart';
import 'package:tokens_repository/tokens_repository.dart';

class SportsMarketsModel extends MarketModel {
  const SportsMarketsModel({
    required this.id,
    required this.name,
    required this.marketHash,
    required super.typeOfMarket,
    required this.line,
  }) : super(id: id, name: name, marketHash: marketHash);

  @override
  final int id;
  @override
  final String name;
  @override
  final String marketHash;

  final double line;

  static const empty = SportsMarketsModel(
    id: 0,
    name: '',
    typeOfMarket: SupportedMarkets.Sports,
    marketHash: '',
    line: 0,
  );

  @override
  List<Object?> get props => [id, name, marketHash, typeOfMarket, line];
}
