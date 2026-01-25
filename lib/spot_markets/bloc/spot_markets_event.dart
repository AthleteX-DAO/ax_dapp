part of 'spot_markets_bloc.dart';

abstract class SpotMarketsEvent extends Equatable {
  const SpotMarketsEvent();

  @override
  List<Object?> get props => [];
}

class SpotMarketsInitialize extends SpotMarketsEvent {
  const SpotMarketsInitialize();
}

class SpotMarketsRefresh extends SpotMarketsEvent {
  const SpotMarketsRefresh();
}

class SpotMarketSelected extends SpotMarketsEvent {
  const SpotMarketSelected(this.market);

  final String market;

  @override
  List<Object?> get props => [market];
}

class SpotMarketBuyOrderPlaced extends SpotMarketsEvent {
  const SpotMarketBuyOrderPlaced({
    required this.market,
    required this.quantity,
    required this.price,
  });

  final String market;
  final double quantity;
  final double price;

  @override
  List<Object?> get props => [market, quantity, price];
}

class SpotMarketSellOrderPlaced extends SpotMarketsEvent {
  const SpotMarketSellOrderPlaced({
    required this.market,
    required this.quantity,
    required this.price,
  });

  final String market;
  final double quantity;
  final double price;

  @override
  List<Object?> get props => [market, quantity, price];
}

class SpotSidebarVisibilityToggled extends SpotMarketsEvent {
  const SpotSidebarVisibilityToggled();
}

class SpotMarketSingleRefresh extends SpotMarketsEvent {
  const SpotMarketSingleRefresh(this.market);

  final String market;

  @override
  List<Object?> get props => [market];
}
