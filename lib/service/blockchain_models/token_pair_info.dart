import 'package:equatable/equatable.dart';

class TokenSwapInfo extends Equatable {
  const TokenSwapInfo({
    required this.toPrice,
    required this.fromPrice,
    required this.minimumReceived,
    required this.priceImpact,
    required this.receiveAmount,
    required this.totalFee,
  });

  factory TokenSwapInfo.empty() {
    return const TokenSwapInfo(
      toPrice: 0,
      fromPrice: 0,
      minimumReceived: 0,
      priceImpact: 0,
      receiveAmount: 0,
      totalFee: 0,
    );
  }

  final double toPrice;
  final double fromPrice;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final double totalFee;

  @override
  List<Object?> get props => [
        toPrice,
        fromPrice,
        minimumReceived,
        priceImpact,
        receiveAmount,
        totalFee
      ];
}
