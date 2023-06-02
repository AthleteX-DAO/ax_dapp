part of 'edit_rules_bloc.dart';

class EditRulesState extends Equatable {
  const EditRulesState({
    this.status = BlocStatus.initial,
    this.leagueID = '',
    this.name = '',
    this.adminWallet = '',
    this.dateStart = '',
    this.dateEnd = '',
    this.teamSize = 0,
    this.maxTeams = 0,
    this.entryFee = 0,
    this.isPrivate = false,
    this.isLocked = false,
    this.sports = const [],
    this.winner = '',
    this.prizePoolAddress = '',
    this.league = League.empty,
  });

  final BlocStatus status;
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
  final League league;

  EditRulesState copyWith({
    BlocStatus? status,
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
    League? league,
  }) {
    return EditRulesState(
      status: status ?? this.status,
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
      league: league ?? this.league,
    );
  }

  EditRulesState copyWithLeague(League league) => copyWith(
        leagueID: league.leagueID,
        name: league.name,
        adminWallet: league.adminWallet,
        dateStart: league.dateStart,
        dateEnd: league.dateEnd,
        teamSize: league.teamSize,
        maxTeams: league.maxTeams,
        entryFee: league.entryFee,
        isLocked: league.isLocked,
        isPrivate: league.isPrivate,
        sports: league.sports,
        winner: league.winner,
        prizePoolAddress: league.prizePoolAddress,
      );

  @override
  List<Object> get props => [
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
        league,
      ];
}
