import 'package:equatable/equatable.dart';

enum Status { initial, success, error, loading }

class BuyDialogState extends Equatable {
  final double price;
  final double aptInputAmount;
  final double minimumReceived;
  final double estimatedSlippage;
  final double receiveAmount;
  final Status status;

  const BuyDialogState({
    this.status = Status.initial,
    double? axInputValue,
    double? price,
    double? minimumReceived,
    double? estimatedSlippage,
    double? receiveAmount,
  })  : aptInputAmount = axInputValue ?? 0.0,
        price = price ?? 0.0,
        minimumReceived = minimumReceived ?? 0.0,
        estimatedSlippage = estimatedSlippage ?? 0.0,
        receiveAmount = receiveAmount ?? 0.0;

  @override
  List<Object?> get props => [
        aptInputAmount,
        price,
        minimumReceived,
        estimatedSlippage,
        receiveAmount,
      ];

  BuyDialogState copy({
    Status? status,
    double? axInputValue,
    double? price,
    double? minimumReceived,
    double? estimatedSlippage,
    double? receiveAmount,
  }) {
    return BuyDialogState(
      status: status ?? Status.initial,
      axInputValue: axInputValue ?? this.aptInputAmount,
      price: price ?? this.price,
      minimumReceived: minimumReceived ?? this.minimumReceived,
      estimatedSlippage: estimatedSlippage ?? this.estimatedSlippage,
      receiveAmount: receiveAmount ?? this.receiveAmount,
    );
  }
}
