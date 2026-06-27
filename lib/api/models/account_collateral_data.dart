class AccountCollateralData {
  const AccountCollateralData({
    required this.deposited,
    required this.assigned,
    required this.locked,
    required this.available,
  });

  factory AccountCollateralData.fromJson(Map<String, dynamic> json) {
    return AccountCollateralData(
      deposited: BigInt.parse(json['deposited']?.toString() ?? '0'),
      assigned: BigInt.parse(json['assigned']?.toString() ?? '0'),
      locked: BigInt.parse(json['locked']?.toString() ?? '0'),
      available: BigInt.parse(json['available']?.toString() ?? '0'),
    );
  }

  final BigInt deposited;
  final BigInt assigned;
  final BigInt locked;
  final BigInt available;
}
