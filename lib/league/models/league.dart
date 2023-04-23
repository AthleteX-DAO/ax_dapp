import 'package:json_annotation/json_annotation.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'league.g.dart';

@JsonSerializable()
class League {
  const League({
    required this.leagueID,
    required this.name,
    required this.adminWallet,
    required this.dateStart,
    required this.dateEnd,
    required this.teamSize,
    required this.maxTeams,
    required this.entryFee,
    required this.isPrivate,
    required this.isLocked,
    required this.sports,
    required this.winner,
    required this.prizePoolAddress,
  });

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  static const empty = League(
    leagueID: '',
    name: '',
    adminWallet: '',
    dateStart: '',
    dateEnd: '',
    teamSize: 0,
    maxTeams: 0,
    entryFee: 0,
    isPrivate: false,
    isLocked: false,
    sports: [],
    winner: '',
    prizePoolAddress: '',
  );

  final String leagueID;
  final String name;
  final String adminWallet;
  final String dateStart;
  final String dateEnd;
  final int teamSize;
  final int maxTeams;
  final int entryFee;
  final bool isPrivate;
  final bool isLocked;
  final List<SupportedSport> sports;
  final String winner;
  final String prizePoolAddress;

  Map<String, dynamic> toJson() => _$LeagueToJson(this);
}
