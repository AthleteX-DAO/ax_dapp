// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

League _$LeagueFromJson(Map<String, dynamic> json) => League(
      leagueID: json['leagueID'] as String,
      name: json['name'] as String,
      adminWallet: json['adminWallet'] as String,
      dateStart: json['dateStart'] as String,
      dateEnd: json['dateEnd'] as String,
      teamSize: json['teamSize'] as int,
      maxTeams: json['maxTeams'] as int,
      entryFee: json['entryFee'] as int,
      isPrivate: json['isPrivate'] as bool,
      isLocked: json['isLocked'] as bool,
      sports: (json['sports'] as List<dynamic>)
          .map((e) => $enumDecode(_$SupportedSportEnumMap, e))
          .toList(),
      winner: json['winner'] as String,
      prizePoolAddress: json['prizePoolAddress'] as String,
    );

Map<String, dynamic> _$LeagueToJson(League instance) => <String, dynamic>{
      'leagueID': instance.leagueID,
      'name': instance.name,
      'adminWallet': instance.adminWallet,
      'dateStart': instance.dateStart,
      'dateEnd': instance.dateEnd,
      'teamSize': instance.teamSize,
      'maxTeams': instance.maxTeams,
      'entryFee': instance.entryFee,
      'isPrivate': instance.isPrivate,
      'isLocked': instance.isLocked,
      'sports':
          instance.sports.map((e) => _$SupportedSportEnumMap[e]!).toList(),
      'winner': instance.winner,
      'prizePoolAddress': instance.prizePoolAddress,
    };

const _$SupportedSportEnumMap = {
  SupportedSport.all: 'all',
  SupportedSport.NFL: 'NFL',
  SupportedSport.MLB: 'MLB',
  SupportedSport.NBA: 'NBA',
};
