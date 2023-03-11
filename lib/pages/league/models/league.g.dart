// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

League _$LeagueFromJson(Map<String, dynamic> json) => League(
      name: json['name'] as String,
      adminWallet: json['adminWallet'] as String,
      dateStart: json['dateStart'] as String,
      dateEnd: json['dateEnd'] as String,
      teamSize: json['teamSize'] as int,
      maxTeams: json['maxTeams'] as int,
      entryFee: json['entryFee'] as int,
      isPrivate: json['isPrivate'] as bool,
      isLocked: json['isLocked'] as bool,
      rosters: (json['rosters'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(
                    k, (e as List<dynamic>).map((e) => e as String).toList()),
              ))
          .toList(),
    );

Map<String, dynamic> _$LeagueToJson(League instance) => <String, dynamic>{
      'name': instance.name,
      'adminWallet': instance.adminWallet,
      'dateStart': instance.dateStart,
      'dateEnd': instance.dateEnd,
      'teamSize': instance.teamSize,
      'maxTeams': instance.maxTeams,
      'entryFee': instance.entryFee,
      'isPrivate': instance.isPrivate,
      'isLocked': instance.isLocked,
      'rosters': instance.rosters,
    };
