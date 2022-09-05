// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmModel _$FarmModelFromJson(Map<String, dynamic> json) => FarmModel(
      json['strName'] as String,
      json['strAddress'] as String,
      json['strStakedAlias'] as String,
      json['strStakedSymbol'] as String,
      json['strRewardSymbol'] as String,
      json['strStakeTokenAddress'] as String,
      json['strRewardTokenAddress'] as String,
      json['strStakingModule'] as String,
      json['strAPR'] as String,
      json['strTVL'] as String,
      json['strStaked'] as String,
      json['strRewards'] as String,
      json['strStakeTokenPrice'] as String,
      json['strRewardTokenPrice'] as String,
      json['nStakeTokenDecimals'] as int,
      json['nRewardTokenDecimals'] as int,
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
