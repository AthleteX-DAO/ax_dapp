class FarmModel {
  const FarmModel(
    this.strName,
    this.strAddress,
    this.strStakedAlias,
    this.strStakedSymbol,
    this.strRewardSymbol,
    this.strStakeTokenAddress,
    this.strRewardTokenAddress,
    this.strStakingModule,
    this.strAPR,
    this.strTVL,
    this.strStaked,
    this.strRewards,
    this.strStakeTokenPrice,
    this.strRewardTokenPrice,
    this.nStakeTokenDecimals,
    this.nRewardTokenDecimals,
  );

  final String strName;
  final String strAddress;
  final String strStakedAlias;
  final String strStakedSymbol;
  final String strRewardSymbol;
  final String strStakeTokenAddress;
  final String strRewardTokenAddress;
  final String strStakingModule;
  final String strAPR;
  final String strTVL;
  final String strStaked;
  final String strRewards;
  final String strStakeTokenPrice;
  final String strRewardTokenPrice;
  final int nStakeTokenDecimals;
  final int nRewardTokenDecimals;

  @override
  String toString() {
    return '''APTFarmInfo(name: "$strName", address: "$strAddress", stakedAlias: "$strStakedAlias", stakedSymbol: "$strStakedSymbol", rewardSymbol: "$strRewardSymbol", stakeTokenAddress: "$strStakeTokenAddress", rewardTokenAddress: "$strRewardTokenAddress", stakingModule: "$strStakingModule", apr: "$strAPR", tvl: "$strTVL", staked: "$strStaked", rewards: "$strRewards", stakeTokenPrice: "$strStakeTokenPrice", rewardTokenPrice: "$strRewardTokenPrice")''';
  }
}
