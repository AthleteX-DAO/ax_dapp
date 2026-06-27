class AccountDebtData {
  const AccountDebtData({
    required this.debt,
    required this.cRatio,
  });

  factory AccountDebtData.fromJson(Map<String, dynamic> json) {
    return AccountDebtData(
      debt: BigInt.parse(json['debt']?.toString() ?? '0'),
      cRatio: BigInt.parse(json['c_ratio']?.toString() ?? '0'),
    );
  }

  final BigInt debt;
  final BigInt cRatio;
}
