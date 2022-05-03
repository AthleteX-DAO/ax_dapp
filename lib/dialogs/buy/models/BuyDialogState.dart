import 'package:equatable/equatable.dart';

enum Status { initial, success, error, loading }

class BuyDialogState extends Equatable {
  final double price;
  final double balance;
  final double aptInputAmount;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final double totalFee;
  final Status status;
  final String? tokenAddress;

  const BuyDialogState({
    this.status = Status.initial,
    double? axInputValue,
    double? price,
    double? balance,
    double? minimumReceived,
    double? estimatedSlippage,
    double? receiveAmount,
    double? totalFee,
    String? tokenAddress,
  })  : aptInputAmount = axInputValue ?? 0.0,
        price = price ?? 0.0,
        balance = balance ?? 0.0,
        minimumReceived = minimumReceived ?? 0.0,
        priceImpact = estimatedSlippage ?? 0.0,
        receiveAmount = receiveAmount ?? 0.0,
        totalFee = totalFee ?? 0.0,
        tokenAddress = tokenAddress;

  @override
  List<Object?> get props => [
        aptInputAmount,
        price,
        balance,
        minimumReceived,
        priceImpact,
        receiveAmount,
        totalFee,
        tokenAddress
      ];

  BuyDialogState copy({
    Status? status,
    double? axInputValue,
    double? price,
    double? balance,
    double? minimumReceived,
    double? priceImpact,
    double? receiveAmount,
    double? totalFee,
    String? tokenAddress,
  }) {
    return BuyDialogState(
      status: status ?? Status.initial,
      axInputValue: axInputValue ?? this.aptInputAmount,
      price: price ?? this.price,
      balance: balance ?? this.balance,
      minimumReceived: minimumReceived ?? this.minimumReceived,
      estimatedSlippage: priceImpact ?? this.priceImpact,
      receiveAmount: receiveAmount ?? this.receiveAmount,
      totalFee: totalFee ?? this.totalFee,
      tokenAddress: tokenAddress ?? this.tokenAddress,
    );
  }
}
