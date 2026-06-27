class PoolInfo {
  const PoolInfo({
    required this.poolId,
    required this.name,
    required this.collateralTypes,
  });

  factory PoolInfo.fromJson(Map<String, dynamic> json) {
    return PoolInfo(
      poolId: json['pool_id'] as int,
      name: json['name'] as String? ?? '',
      collateralTypes: (json['collateral_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  final int poolId;
  final String name;
  final List<String> collateralTypes;
}
