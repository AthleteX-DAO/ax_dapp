// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmModel _$FarmModelFromJson(Map<String, dynamic> json) => FarmModel(
      json['stakingToken']['symbol'] as String,
      json['id'] as String,
      json['stakingToken']['alias'] as String,
      json['stakingToken']['symbol'] as String,
      json['rewardToken']['symbol'] as String,
      json['stakingToken']['id'] as String,
      json['rewardToken']['id'] as String,
      json['stakingModule'] as String,
      json['apr'] as String,
      json['tvl'] as String,
      json['staked'] as String,
      json['rewards'] as String,
      json['stakingToken']['price'] as String,
      json['rewardToken']['price'] as String,
      int.parse(json['stakingToken']['decimals'] as String),
      int.parse(json['rewardToken']['decimals'] as String),
    );

Map<String, dynamic> _$FarmModelToJson(FarmModel instance) => <String, dynamic>{
      'strName': instance.strName,
      'strAddress': instance.strAddress,
      'strStakedAlias': instance.strStakedAlias,
      'strStakedSymbol': instance.strStakedSymbol,
      'strRewardSymbol': instance.strRewardSymbol,
      'strStakeTokenAddress': instance.strStakeTokenAddress,
      'strRewardTokenAddress': instance.strRewardTokenAddress,
      'strStakingModule': instance.strStakingModule,
      'strAPR': instance.strAPR,
      'strTVL': instance.strTVL,
      'strStaked': instance.strStaked,
      'strRewards': instance.strRewards,
      'strStakeTokenPrice': instance.strStakeTokenPrice,
      'strRewardTokenPrice': instance.strRewardTokenPrice,
      'nStakeTokenDecimals': instance.nStakeTokenDecimals,
      'nRewardTokenDecimals': instance.nRewardTokenDecimals,
    };
