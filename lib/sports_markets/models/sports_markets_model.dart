import 'package:ax_dapp/markets/markets.dart';
import 'package:shared/shared.dart';

class SportsMarketsModel extends Equatable {
  const SportsMarketsModel({
    required this.id,
    required this.name,
    required this.marketHash,
    required this.typeOfMarket,
    required this.line,
    required this.mainLine,
  });

  final String id;
  final String name;
  final SupportedMarkets typeOfMarket;
  final String marketHash;
  final double line;
  final bool mainLine;

  static const empty = SportsMarketsModel(
    id: '0',
    name: '',
    typeOfMarket: SupportedMarkets.sports,
    marketHash: '',
    line: 0,
    mainLine: true,
  );

  @override
  List<Object?> get props => [id, name, marketHash, typeOfMarket, line];

  @override
  String toString() {
    return '''ID: $id NAME: $name MARKETHASH: $marketHash TYPE OF MARKET: $typeOfMarket LINE: $line MAINLINE: $mainLine''';
  }
}
