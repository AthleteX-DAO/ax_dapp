// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueData _$LeagueDataFromJson(Map<String, dynamic> json) => LeagueData(
      id: json['id'] as int,
      name: json['name'] as String,
      adminWallet: json['adminWallet'] as String,
      dateStart: json['dateStart'] as String,
      dateEnd: json['dateEnd'] as String,
      teamSize: json['teamSize'] as int,
      maxTeams: json['maxTeams'] as int,
      entryFee: json['entryFee'] as int,
      isPrivate: json['isPrivate'] as bool,
      isLocked: json['isLocked'] as bool,
      roster: (json['roster'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(
                    k, (e as List<dynamic>).map((e) => e as String).toList()),
              ))
          .toList(),
    );

Map<String, dynamic> _$LeagueDataToJson(LeagueData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'adminWallet': instance.adminWallet,
      'dateStart': instance.dateStart,
      'dateEnd': instance.dateEnd,
      'teamSize': instance.teamSize,
      'maxTeams': instance.maxTeams,
      'entryFee': instance.entryFee,
      'isPrivate': instance.isPrivate,
      'isLocked': instance.isLocked,
      'roster': instance.roster,
    };
