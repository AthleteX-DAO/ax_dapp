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

class SpotMarketRangeSelected extends SpotMarketsEvent {
  const SpotMarketRangeSelected(this.range);

  final SpotMarketChartRange range;

  @override
  List<Object?> get props => [range];
}

class SpotMarketBuyOrderPlaced extends SpotMarketsEvent {
  const SpotMarketBuyOrderPlaced({
    required this.market,
    required this.quantity,
    required this.price,
    this.slippage = 0.01,
  });

  final String market;
  final double quantity;
  final double price;
  final double slippage; // Default 1%

  @override
  List<Object?> get props => [market, quantity, price, slippage];
}

class SpotMarketSellOrderPlaced extends SpotMarketsEvent {
  const SpotMarketSellOrderPlaced({
    required this.market,
    required this.quantity,
    required this.price,
    this.slippage = 0.01,
  });

  final String market;
  final double quantity;
  final double price;
  final double slippage; // Default 1%

  @override
  List<Object?> get props => [market, quantity, price, slippage];
}

class SpotMarketOrderConfirmed extends SpotMarketsEvent {
  const SpotMarketOrderConfirmed(this.orderId);

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

class SpotMarketOrderCancelled extends SpotMarketsEvent {
  const SpotMarketOrderCancelled(this.orderId);

  final String orderId;

  @override
  List<Object?> get props => [orderId];
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
// Internal event for oracle price updates
class _OraclePricesUpdated extends SpotMarketsEvent {
  const _OraclePricesUpdated(this.currentState, this.updatedData);

  final SpotMarketsLoaded currentState;
  final Map<String, SpotMarketModel> updatedData;

  @override
  List<Object?> get props => [currentState, updatedData];
}