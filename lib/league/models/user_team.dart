import 'package:equatable/equatable.dart';

class UserTeam extends Equatable {
  const UserTeam({
    required this.address,
    required this.roster,
    required this.teamPerformance,
  });

  final String address;
  final Map<int, List<String>> roster;
  final double teamPerformance;

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

extension UserTeamX on UserTeam {
  List<MapEntry<int, List<String>>> get rosters => roster.entries.toList();
}
