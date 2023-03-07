import 'package:json_annotation/json_annotation.dart';

part 'league.g.dart';

@JsonSerializable()
class LeagueData {
  const LeagueData({
    required this.id,
    required this.name,
    required this.adminWallet,
    required this.dateStart,
    required this.dateEnd,
    required this.teamSize,
    required this.maxTeams,
    required this.entryFee,
    required this.isPrivate,
    required this.isLocked,
    required this.roster,
  });

  factory LeagueData.fromJson(Map<String, dynamic> json) =>
      _$LeagueDataFromJson(json);

  final int id;
  final String name;
  final String adminWallet;
  final String dateStart;
  final String dateEnd;
  final int teamSize;
  final int maxTeams;
  final int entryFee;
  final bool isPrivate;
  final bool isLocked;
  final List<Map<String, List<String>>> roster;

  Map<String, dynamic> toJson() => _$LeagueDataToJson(this);
}
