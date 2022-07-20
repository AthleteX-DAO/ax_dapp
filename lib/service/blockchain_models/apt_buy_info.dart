import 'package:equatable/equatable.dart';

class AptBuyInfo extends Equatable {
  const AptBuyInfo({
    required this.axPerAptPrice,
    required this.minimumReceived,
    required this.priceImpact,
    required this.receiveAmount,
    required this.totalFee,
  });

  factory AptBuyInfo.empty() {
    return const AptBuyInfo(
      axPerAptPrice: 0,
      minimumReceived: 0,
      priceImpact: 0,
      receiveAmount: 0,
      totalFee: 0,
    );
  }
  final double axPerAptPrice;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final double totalFee;

  @override
  List<Object?> get props => [
        axPerAptPrice,
        minimumReceived,
        priceImpact,
        receiveAmount,
        totalFee,
      ];
}
