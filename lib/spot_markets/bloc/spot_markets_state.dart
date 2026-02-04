part of 'spot_markets_bloc.dart';

abstract class SpotMarketsState extends Equatable {
  const SpotMarketsState();

  @override
  List<Object?> get props => [];
}

class SpotMarketsInitial extends SpotMarketsState {
  const SpotMarketsInitial();
}

class SpotMarketsLoading extends SpotMarketsState {
  const SpotMarketsLoading();
}

class SpotMarketsLoaded extends SpotMarketsState {
  const SpotMarketsLoaded({
    required this.markets,
    required this.selectedMarket,
    required this.marketData,
    required this.priceHistory,
    required this.selectedRange,
    this.showSidebar = true,
    this.pendingOrders = const [],
  });

  final List<String> markets;
  final String selectedMarket;
  final Map<String, SpotMarketModel> marketData;
  final Map<String, List<GraphData>> priceHistory;
  final SpotMarketChartRange selectedRange;
  final bool showSidebar;
  final List<PendingOrder> pendingOrders;

  @override
  List<Object?> get props => [
        markets,
        selectedMarket,
        marketData,
        priceHistory,
        selectedRange,
        showSidebar,
        pendingOrders,
      ];

  SpotMarketsLoaded copyWith({
    List<String>? markets,
    String? selectedMarket,
    Map<String, SpotMarketModel>? marketData,
    Map<String, List<GraphData>>? priceHistory,
    SpotMarketChartRange? selectedRange,
    bool? showSidebar,
    List<PendingOrder>? pendingOrders,
  }) {
    return SpotMarketsLoaded(
      markets: markets ?? this.markets,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      marketData: marketData ?? this.marketData,
      priceHistory: priceHistory ?? this.priceHistory,
      selectedRange: selectedRange ?? this.selectedRange,
      showSidebar: showSidebar ?? this.showSidebar,
      pendingOrders: pendingOrders ?? this.pendingOrders,
    );
  }
}

class SpotMarketsError extends SpotMarketsState {
  const SpotMarketsError(this.message, {this.details});

  final String message;
  final String? details;

  @override
  List<Object?> get props => [message, details];
}

class SpotMarketOrderPlaced extends SpotMarketsState {
  const SpotMarketOrderPlaced({
    required this.message,
    required this.orderId,
  });

  final String message;
  final String orderId;

  @override
  List<Object?> get props => [message, orderId];
}

class SpotMarketOrderAwaitingConfirmation extends SpotMarketsState {
  const SpotMarketOrderAwaitingConfirmation({
    required this.pendingOrder,
  });

  final PendingOrder pendingOrder;

  @override
  List<Object?> get props => [pendingOrder];
}

class SpotMarketOrderApprovalNeeded extends SpotMarketsState {
  const SpotMarketOrderApprovalNeeded({
    required this.pendingOrder,
  });

  final PendingOrder pendingOrder;

  @override
  List<Object?> get props => [pendingOrder];
}

class SpotMarketOrderProcessing extends SpotMarketsState {
  const SpotMarketOrderProcessing({
    required this.pendingOrder,
  });

  final PendingOrder pendingOrder;

  @override
  List<Object?> get props => [pendingOrder];
}

class SpotMarketsGasEstimate extends SpotMarketsState {
  const SpotMarketsGasEstimate({
    required this.gasLimit,
    required this.gasPrice,
    required this.totalCostWei,
    required this.totalCostEth,
  });

  final BigInt gasLimit;
  final BigInt gasPrice;
  final BigInt totalCostWei;
  final String totalCostEth;

  @override
  List<Object?> get props => [gasLimit, gasPrice, totalCostWei, totalCostEth];
}
