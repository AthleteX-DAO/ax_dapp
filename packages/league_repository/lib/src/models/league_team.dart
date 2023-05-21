import 'package:json_annotation/json_annotation.dart';

part 'league_team.g.dart';

@JsonSerializable()
/// {@template league_team}
/// Holds data related to a league team.
/// {@endtemplate}
class LeagueTeam {
  /// {@macro league_team}
  const LeagueTeam({
    required this.userWalletID,
    required this.teamAppreciation,
    required this.roster,
  });

  /// Constructs a new [LeagueTeam] from a [Map] structure.
  factory LeagueTeam.fromJson(Map<String, dynamic> json) =>
      _$LeagueTeamFromJson(json);

  /// Wallet Address of the user.
  final String userWalletID;
  /// Calculated team performance from the selected roster.
  final double teamAppreciation;
  /// Selected roster from the users' team.
  final Map<int, List<String>> roster;

  /// Represents an empty [LeagueTeam].
  static const empty = LeagueTeam(
    userWalletID: '',
    teamAppreciation: 0,
    roster: {},
  );

  /// Converts a [LeagueTeam] instance to a [Map].
  Map<String, dynamic> toJson() => _$LeagueTeamToJson(this);
}

/// [LeagueTeam] extensions.
extension LeagueTeamListX on List<LeagueTeam> {
  /// Retrieves the [LeagueTeam] from the [walletAddress].
  LeagueTeam findLeagueTeam(String walletAddress) {
    final leagueTeam = firstWhere(
      (leagueTeam) => leagueTeam.userWalletID == walletAddress,
      orElse: () => LeagueTeam.empty,
    );
    return leagueTeam;
  }
}

/// [LeagueTeam] extensions.
extension LeagueTeamX on LeagueTeam {
  /// returns the keys of rosters as a list.
  List<int> get rosterIds => roster.keys.toList();
}
