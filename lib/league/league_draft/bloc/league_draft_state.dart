part of 'league_draft_bloc.dart';

class LeagueDraftState extends Equatable {
  const LeagueDraftState({
    this.status = BlocStatus.initial,
    this.ownedApts = const [],
    this.myAptTeam = const [],
    this.athleteCount = 0,
    this.athletes = const [],   
  });

  final BlocStatus status;
  final List<AthleteScoutModel> ownedApts;
  final List<AthleteScoutModel> myAptTeam;
  final int athleteCount;
  final List<AthleteScoutModel> athletes;

  LeagueDraftState copyWith({
    BlocStatus? status,
    List<AthleteScoutModel>? ownedApts,
    List<AthleteScoutModel>? myAptTeam,
    int? athleteCount,
    List<AthleteScoutModel>? athletes,
  }) {
    return LeagueDraftState(
      status: status ?? this.status,
      ownedApts: ownedApts ?? this.ownedApts,
      myAptTeam: myAptTeam ?? this.myAptTeam,
      athleteCount: athleteCount ?? this.athleteCount,
      athletes: athletes ?? this.athletes,
    );
  }

  @override
  List<Object> get props => [
        status,
        ownedApts,
        myAptTeam,
        athleteCount,
        athletes,
      ];
}
