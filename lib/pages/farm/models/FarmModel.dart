class FarmModel {
  final String strName;
  final String strAddress;
  final String strStakedAlias;
  final String strStakedSymbol;
  final String strRewardSymbol;
  final String strStakeTokenAddress;
  final String strRewardTokenAddress;
  final String strStakingModule;
  final double dAPR;
  final double dTVL;
  final double dStaked;
  final double dRewards;
  final double dStakeTokenPrice;
  final double dRewardTokenPrice;

  FarmModel(
      this.strName,
      this.strAddress,
      this.strStakedAlias,
      this.strStakedSymbol,
      this.strRewardSymbol,
      this.strStakeTokenAddress,
      this.strRewardTokenAddress,
      this.strStakingModule,
      this.dAPR,
      this.dTVL,
      this.dStaked,
      this.dRewards,
      this.dStakeTokenPrice,
      this.dRewardTokenPrice);
}
