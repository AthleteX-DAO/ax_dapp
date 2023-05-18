part of 'league_draft_bloc.dart';

class LeagueDraftState extends Equatable {
  const LeagueDraftState({
    this.status = BlocStatus.initial,
    this.ownedApts = const [],
    this.myAptTeam = const [],
    this.existingAptTeam = const [],
    this.availableOwnedApts = const [],
    this.athleteCount = 0,
    this.athletes = const [],
    this.league = League.empty,
  });

  final BlocStatus status;
  final List<DraftApt> ownedApts;
  final List<DraftApt> myAptTeam;
  final List<DraftApt> existingAptTeam;
  final List<DraftApt> availableOwnedApts;
  final int athleteCount;
  final List<AthleteScoutModel> athletes;
  final League league;

  LeagueDraftState copyWith({
    BlocStatus? status,
    List<DraftApt>? ownedApts,
    List<DraftApt>? myAptTeam,
    List<DraftApt>? existingAptTeam,
    List<DraftApt>? availableOwnedApts,
    int? athleteCount,
    List<AthleteScoutModel>? athletes,
    League? league,
  }) {
    return LeagueDraftState(
      status: status ?? this.status,
      ownedApts: ownedApts ?? this.ownedApts,
      myAptTeam: myAptTeam ?? this.myAptTeam,
      existingAptTeam: existingAptTeam ?? this.existingAptTeam,
      availableOwnedApts: availableOwnedApts ?? this.availableOwnedApts,
      athleteCount: athleteCount ?? this.athleteCount,
      athletes: athletes ?? this.athletes,
      league: league ?? this.league,
    );
  }

  @override
  List<Object> get props => [
        status,
        ownedApts,
        myAptTeam,
        existingAptTeam,
        availableOwnedApts,
        athleteCount,
        athletes,
        league,
      ];
}
