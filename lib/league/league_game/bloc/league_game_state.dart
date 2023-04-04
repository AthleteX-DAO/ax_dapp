part of 'league_game_bloc.dart';

class LeagueGameState extends Equatable {
  const LeagueGameState({
    this.status = BlocStatus.initial,
    this.userTeams = const [],
    this.rosters = const {},
    this.selectedChain = EthereumChain.polygonMainnet,
    this.startDate = '',
    this.endDate = '',
    this.differenceInDays = 0,
    this.differenceInHours = 0,
    this.differenceInMinutes = 0,
    this.differenceInSeconds = 0,
    this.timerStatus = TimerStatus.initial,
  });

  final BlocStatus status;
  final List<UserTeam> userTeams;
  final Map<String, Map<String, double>> rosters;
  final EthereumChain selectedChain;
  final String startDate;
  final String endDate;
  final int differenceInDays;
  final int differenceInHours;
  final int differenceInMinutes;
  final int differenceInSeconds;
  final TimerStatus timerStatus;

  LeagueGameState copyWith({
    BlocStatus? status,
    List<UserTeam>? userTeams,
    Map<String, Map<String, double>>? rosters,
    EthereumChain? selectedChain,
    String? startDate,
    String? endDate,
    int? differenceInDays,
    int? differenceInHours,
    int? differenceInMinutes,
    int? differenceInSeconds,
    TimerStatus? timerStatus,
  }) {
    return LeagueGameState(
      status: status ?? this.status,
      userTeams: userTeams ?? this.userTeams,
      rosters: rosters ?? this.rosters,
      selectedChain: selectedChain ?? this.selectedChain,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      differenceInDays: differenceInDays ?? this.differenceInDays,
      differenceInHours: differenceInHours ?? this.differenceInHours,
      differenceInMinutes: differenceInMinutes ?? this.differenceInMinutes,
      differenceInSeconds: differenceInSeconds ?? this.differenceInSeconds,
      timerStatus: timerStatus ?? this.timerStatus,
    );
  }

  LeagueGameState coptWithTimerDuration(DurationStatus durationStatus) =>
      copyWith(
        differenceInDays: durationStatus.days,
        differenceInHours: durationStatus.hours,
        differenceInMinutes: durationStatus.minutes,
        differenceInSeconds: durationStatus.seconds,
        timerStatus: durationStatus.timerStatus,
      );

  @override
  List<Object> get props => [
        status,
        userTeams,
        rosters,
        selectedChain,
        startDate,
        endDate,
        differenceInDays,
        differenceInHours,
        differenceInMinutes,
        differenceInSeconds,
        timerStatus,
      ];
}
