import 'package:equatable/equatable.dart';

class SpotOrderModel extends Equatable {
  const SpotOrderModel({
    required this.orderId,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.timestamp,
  });

  final String orderId;
  final String symbol;
  final String side; // 'BUY' or 'SELL'
  final double quantity;
  final double price;
  final DateTime timestamp;

  @override
  List<Object?> get props => [
        orderId,
        symbol,
        side,
        quantity,
        price,
        timestamp,
      ];
}
