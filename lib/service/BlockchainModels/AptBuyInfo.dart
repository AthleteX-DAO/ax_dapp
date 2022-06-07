import 'package:equatable/equatable.dart';

class AptBuyInfo extends Equatable {
  final double axPerAptPrice;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final double totalFee;

  factory AptBuyInfo.empty() {
    return AptBuyInfo(
        axPerAptPrice: 0.0,
        minimumReceived: 0.0,
        priceImpact: 0.0,
        receiveAmount: 0.0,
        totalFee: 0.0);
  }
  AptBuyInfo(
      {required this.axPerAptPrice,
      required this.minimumReceived,
      required this.priceImpact,
      required this.receiveAmount,
      required this.totalFee});

  @override
  // TODO: implement props
  List<Object?> get props =>
      [axPerAptPrice, minimumReceived, priceImpact, receiveAmount, totalFee];
}
