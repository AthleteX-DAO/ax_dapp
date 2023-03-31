part of 'league_draft_bloc.dart';

class LeagueDraftState extends Equatable {
  const LeagueDraftState({
    this.status = BlocStatus.initial,
    this.ownedApts = const [],
    this.myAptTeam = const [],
    this.athleteCount = 0,
  });

  final BlocStatus status;
  final List<Apt> ownedApts;
  final List<Apt> myAptTeam;
  final int athleteCount;

  LeagueDraftState copyWith({
    BlocStatus? status,
    List<Apt>? ownedApts,
    List<Apt>? myAptTeam,
    int? athleteCount
  }) {
    return LeagueDraftState(
      status: status ?? this.status,
      ownedApts: ownedApts ?? this.ownedApts,
      myAptTeam: myAptTeam ?? this.myAptTeam,
      athleteCount: athleteCount ?? this.athleteCount,
    );
  }

  @override
  List<Object> get props => [
        status,
        ownedApts,
        myAptTeam,
        athleteCount,
      ];
}
