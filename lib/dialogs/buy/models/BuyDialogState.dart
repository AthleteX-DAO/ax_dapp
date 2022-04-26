import 'package:equatable/equatable.dart';

enum Status { initial, success, error, loading }

class BuyDialogState extends Equatable {
  final double price;
  final double aptInputAmount;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final Status status;
  final String? tokenAddress;

  const BuyDialogState({
    this.status = Status.initial,
    double? axInputValue,
    double? price,
    double? minimumReceived,
    double? estimatedSlippage,
    double? receiveAmount,
    String? tokenAddress,
  })  : aptInputAmount = axInputValue ?? 0.0,
        price = price ?? 0.0,
        minimumReceived = minimumReceived ?? 0.0,
        priceImpact = estimatedSlippage ?? 0.0,
        receiveAmount = receiveAmount ?? 0.0,
        tokenAddress = tokenAddress;

  @override
  List<Object?> get props => [
        aptInputAmount,
        price,
        minimumReceived,
        priceImpact,
        receiveAmount,
        tokenAddress
      ];

  BuyDialogState copy({
    Status? status,
    double? axInputValue,
    double? price,
    double? minimumReceived,
    double? priceImpact,
    double? receiveAmount,
    String? tokenAddress,
  }) {
    return BuyDialogState(
      status: status ?? Status.initial,
      axInputValue: axInputValue ?? this.aptInputAmount,
      price: price ?? this.price,
      minimumReceived: minimumReceived ?? this.minimumReceived,
      estimatedSlippage: priceImpact ?? this.priceImpact,
      receiveAmount: receiveAmount ?? this.receiveAmount,
      tokenAddress: tokenAddress ?? this.tokenAddress,
    );
  }
}
