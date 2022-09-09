class AptSellInfo {
  const AptSellInfo({
    required this.axPrice,
    required this.minimumReceived,
    required this.priceImpact,
    required this.receiveAmount,
    required this.totalFee,
  });

  static const empty = AptSellInfo(
    axPrice: 0,
    minimumReceived: 0,
    priceImpact: 0,
    receiveAmount: 0,
    totalFee: 0,
  );

  final double axPrice;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final double totalFee;
}
