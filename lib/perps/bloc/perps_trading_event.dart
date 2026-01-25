part of 'perps_trading_bloc.dart';

abstract class PerpsTradingEvent extends Equatable {
  const PerpsTradingEvent();

  @override
  List<Object?> get props => [];
}

class PlacePerpsOrder extends PerpsTradingEvent {
  const PlacePerpsOrder({
    required this.symbol,
    required this.size,
    required this.isLong,
    required this.isMarketOrder,
    this.limitPrice,
  });

  final String symbol;
  final double size;
  final bool isLong;
  final bool isMarketOrder;
  final double? limitPrice;

  @override
  List<Object?> get props => [symbol, size, isLong, isMarketOrder, limitPrice];
}

class CancelPerpsOrder extends PerpsTradingEvent {
  const CancelPerpsOrder({required this.orderId});

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

class UpdatePerpsBalance extends PerpsTradingEvent {
  const UpdatePerpsBalance();
}
