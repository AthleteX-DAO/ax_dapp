import 'package:json_annotation/json_annotation.dart';

part 'league_team.g.dart';

@JsonSerializable()
class LeagueTeam {
  const LeagueTeam({
    required this.userWalletID,
    required this.teamAppreciation,
    required this.roster,
  });

  factory LeagueTeam.fromJson(Map<String, dynamic> json) =>
      _$LeagueTeamFromJson(json);

  final String userWalletID;
  final double teamAppreciation;
  final Map<int, List<String>> roster;

  static const empty = LeagueTeam(
    userWalletID: '',
    teamAppreciation: 0,
    roster: {},
  );

  Map<String, dynamic> toJson() => _$LeagueTeamToJson(this);
}

extension LeagueTeamListX on List<LeagueTeam> {
  LeagueTeam findLeagueTeam(String walletAddress) {
    final leagueTeam = firstWhere(
      (leagueTeam) => leagueTeam.userWalletID == walletAddress,
      orElse: () => LeagueTeam.empty,
    );
    return leagueTeam;
  }
}

extension LeagueTeamX on LeagueTeam {
  List<int> get rosterIds => roster.keys.toList();
}
