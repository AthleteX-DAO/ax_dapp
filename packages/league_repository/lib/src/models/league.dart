import 'package:ethereum_api/tokens_api.dart';
import 'package:shared/shared.dart';

part 'league.g.dart';

@JsonSerializable()

/// {@template league}
/// Holds data related a league.
/// {@endtemplate}
class League extends Equatable {
  /// {@macro league}
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

  /// Constructs a new [League] from a [Map] structure.
  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  /// Represents an empty [League].
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

  /// League id.
  final String leagueID;

  /// League name.
  final String name;

  /// League admin/owner.
  final String adminWallet;

  /// Starting date for the league.
  final String dateStart;

  /// Ending date for the league.
  final String dateEnd;

  /// Maximum amount of APTs that can be added to a team.
  final int teamSize;

  /// Maximum amount of teams in a league.
  final int maxTeams;

  /// League entry fee.
  final int entryFee;

  /// Private league.
  final bool isPrivate;

  /// Locked league.
  final bool isLocked;

  /// Supported sports for a league.
  final List<SupportedSport> sports;

  /// Winner of the league.
  final String winner;

  /// Address of a league from the deployed SC (Smart Contract).
  final String prizePoolAddress;

  /// Converts a [League] instance to a [Map].
  Map<String, dynamic> toJson() => _$LeagueToJson(this);

  /// copyWith
  League copyWith({
    String? leagueID,
    String? name,
    String? adminWallet,
    String? dateStart,
    String? dateEnd,
    int? teamSize,
    int? maxTeams,
    int? entryFee,
    bool? isPrivate,
    bool? isLocked,
    List<SupportedSport>? sports,
    String? winner,
    String? prizePoolAddress,
  }) {
    return League(
      leagueID: leagueID ?? this.leagueID,
      name: name ?? this.name,
      adminWallet: adminWallet ?? this.adminWallet,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      teamSize: teamSize ?? this.teamSize,
      maxTeams: maxTeams ?? this.maxTeams,
      entryFee: entryFee ?? this.entryFee,
      isPrivate: isPrivate ?? this.isPrivate,
      isLocked: isLocked ?? this.isLocked,
      sports: sports ?? this.sports,
      winner: winner ?? this.winner,
      prizePoolAddress: prizePoolAddress ?? this.prizePoolAddress,
    );
  }

  @override
  List<Object?> get props => [
        leagueID,
        name,
        adminWallet,
        dateStart,
        dateEnd,
        teamSize,
        maxTeams,
        entryFee,
        isPrivate,
        isLocked,
        sports,
        winner,
        prizePoolAddress,
      ];

  @override
  String toString() {
    return '''League(leagueID: $leagueID, name: $name, adminWallet: $adminWallet, startDate: $dateStart, endDate: $dateEnd, teamSize: $teamSize, maxTeams: $maxTeams, entryFee: $entryFee, isPrivate: $isPrivate, isLocked: $isLocked, sports: $sports, winner: $winner, prizePoolAddress: $prizePoolAddress)''';
  }
}

/// [League] extensions.
extension LeagueListX on List<League> {
  /// Retrieves the [League] from the [leagueID].
  League findLeague(String leagueID) {
    final league = firstWhere(
      (league) => league.leagueID == leagueID,
      orElse: () => League.empty,
    );
    return league;
  }
}
