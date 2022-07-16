class SwapInfo {
  SwapInfo({
    required this.toPrice,
    required this.minimumReceived,
    required this.priceImpact,
    required this.receiveAmount,
    required this.totalFee,
  });

  factory SwapInfo.empty() {
    return SwapInfo(
      toPrice: 0,
      minimumReceived: 0,
      priceImpact: 0,
      receiveAmount: 0,
      totalFee: 0,
    );
  }

  final double toPrice;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final double totalFee;
}
