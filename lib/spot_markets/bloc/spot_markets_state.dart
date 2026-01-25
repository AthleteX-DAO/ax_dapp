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
    this.showSidebar = true,
  });

  final List<String> markets;
  final String selectedMarket;
  final Map<String, SpotMarketModel> marketData;
  final bool showSidebar;

  @override
  List<Object?> get props => [markets, selectedMarket, marketData, showSidebar];

  SpotMarketsLoaded copyWith({
    List<String>? markets,
    String? selectedMarket,
    Map<String, SpotMarketModel>? marketData,
    bool? showSidebar,
  }) {
    return SpotMarketsLoaded(
      markets: markets ?? this.markets,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      marketData: marketData ?? this.marketData,
      showSidebar: showSidebar ?? this.showSidebar,
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
