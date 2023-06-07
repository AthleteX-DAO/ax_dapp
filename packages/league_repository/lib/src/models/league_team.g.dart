// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueTeam _$LeagueTeamFromJson(Map<String, dynamic> json) => LeagueTeam(
      userWalletID: json['userWalletID'] as String,
      teamAppreciation: (json['teamAppreciation'] as num).toDouble(),
      roster: (json['roster'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          int.parse(k),
          (e as List<dynamic>).map((e) => e as String).toList(),
        ),
      ),
    );

Map<String, dynamic> _$LeagueTeamToJson(LeagueTeam instance) =>
    <String, dynamic>{
      'userWalletID': instance.userWalletID,
      'teamAppreciation': instance.teamAppreciation,
      'roster': instance.roster.map((k, e) => MapEntry(k.toString(), e)),
    };
