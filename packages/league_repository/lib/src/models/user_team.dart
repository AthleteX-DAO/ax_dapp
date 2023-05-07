import 'package:equatable/equatable.dart';

/// {@template user_team}
/// Holds data related to a users' team.
/// {@endtemplate}
class UserTeam extends Equatable {
  /// {@macro user_team}
  const UserTeam({
    required this.address,
    required this.roster,
    required this.teamPerformance,
  });

  /// Wallet Address of the user.
  final String address;
  /// Selected roster from the users' team.
  final Map<int, List<String>> roster;
  /// Calculated team performance from the selected roster.
  final double teamPerformance;

  /// Represents and empty [UserTeam].
  static const empty = UserTeam(
    address: '',
    roster: {},
    teamPerformance: 0,
  );

  @override
  List<Object?> get props => [
        address,
        roster,
        teamPerformance,
      ];
}

/// [UserTeam] extensions.
extension UserTeamX on UserTeam {
  /// returns the entries of rosters as a list.
  List<MapEntry<int, List<String>>> get rosters => roster.entries.toList();
}
