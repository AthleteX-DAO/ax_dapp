class FarmModel {
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

  FarmModel(
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
      this.nRewardTokenDecimals);

  @override
  String toString() {
    return 'APTFarmInfo(name: "${this.strName}", address: "${this.strAddress}", stakedAlias: "${this.strStakedAlias}", stakedSymbol: "${this.strStakedSymbol}", rewardSymbol: "${this.strRewardSymbol}", stakeTokenAddress: "${this.strStakeTokenAddress}", rewardTokenAddress: "${this.strRewardTokenAddress}", stakingModule: "${this.strStakingModule}", apr: "${this.strAPR}", tvl: "${this.strTVL}", staked: "${this.strStaked}", rewards: "${this.strRewards}", stakeTokenPrice: "${this.strStakeTokenPrice}", rewardTokenPrice: "${this.strRewardTokenPrice}")';
  }
}
