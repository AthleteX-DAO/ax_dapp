class TransactionInfo {
  TransactionInfo(
    this.minimumReceived,
    this.priceImpact,
    this.receiveAmount,
    this.totalFee,
    this.price,
  );

  final double? minimumReceived;
  final double? priceImpact;
  final double? receiveAmount;
  final double? totalFee;
  final double? price;
}
