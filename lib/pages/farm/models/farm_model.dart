import 'package:json_annotation/json_annotation.dart';
part 'farm_model.g.dart';

@JsonSerializable()
class FarmModel {
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
    this.nRewardTokenDecimals,
  );
  factory FarmModel.fromJson(Map<String, dynamic> json) =>
      _$FarmModelFromJson(json);

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

  Map<String, dynamic> toJson() => _$FarmModelToJson(this);

  @override
  String toString() {
    return '''APTFarmInfo(name: "$strName", address: "$strAddress", stakedAlias: "$strStakedAlias", stakedSymbol: "$strStakedSymbol", rewardSymbol: "$strRewardSymbol", stakeTokenAddress: "$strStakeTokenAddress", rewardTokenAddress: "$strRewardTokenAddress", stakingModule: "$strStakingModule", apr: "$strAPR", tvl: "$strTVL", staked: "$strStaked", rewards: "$strRewards", stakeTokenPrice: "$strStakeTokenPrice", rewardTokenPrice: "$strRewardTokenPrice")''';
  }
}
