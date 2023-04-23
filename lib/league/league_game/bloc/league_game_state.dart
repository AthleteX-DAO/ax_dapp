part of 'league_game_bloc.dart';

class LeagueGameState extends Equatable {
  const LeagueGameState({
    this.status = BlocStatus.initial,
    this.userTeams = const [],
    this.leagueTeams = const [],
    this.rosters = const {},
    this.athletes = const [],
    this.filteredAthletes = const [],
    this.selectedChain = EthereumChain.polygonMainnet,
    this.startDate = '',
    this.endDate = '',
    this.differenceInDays = 0,
    this.differenceInHours = 0,
    this.differenceInMinutes = 0,
    this.differenceInSeconds = 0,
    this.timerStatus = TimerStatus.initial,
    this.selectedSport = SupportedSport.all,
  });

  final BlocStatus status;
  final List<UserTeam> userTeams;
  final List<LeagueTeam> leagueTeams;
  final Map<String, Map<String, double>> rosters;
  final List<AthleteScoutModel> athletes;
  final List<AthleteScoutModel> filteredAthletes;
  final EthereumChain selectedChain;
  final String startDate;
  final String endDate;
  final int differenceInDays;
  final int differenceInHours;
  final int differenceInMinutes;
  final int differenceInSeconds;
  final TimerStatus timerStatus;
  final SupportedSport selectedSport;

  LeagueGameState copyWith({
    BlocStatus? status,
    List<UserTeam>? userTeams,
    List<LeagueTeam>? leagueTeams,
    Map<String, Map<String, double>>? rosters,
    List<AthleteScoutModel>? athletes,
    List<AthleteScoutModel>? filteredAthletes,
    EthereumChain? selectedChain,
    String? startDate,
    String? endDate,
    int? differenceInDays,
    int? differenceInHours,
    int? differenceInMinutes,
    int? differenceInSeconds,
    TimerStatus? timerStatus,
    SupportedSport? selectedSport,
  }) {
    return LeagueGameState(
      status: status ?? this.status,
      userTeams: userTeams ?? this.userTeams,
      leagueTeams: leagueTeams ?? this.leagueTeams,
      rosters: rosters ?? this.rosters,
      athletes: athletes ?? this.athletes,
      filteredAthletes: filteredAthletes ?? this.filteredAthletes,
      selectedChain: selectedChain ?? this.selectedChain,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      differenceInDays: differenceInDays ?? this.differenceInDays,
      differenceInHours: differenceInHours ?? this.differenceInHours,
      differenceInMinutes: differenceInMinutes ?? this.differenceInMinutes,
      differenceInSeconds: differenceInSeconds ?? this.differenceInSeconds,
      timerStatus: timerStatus ?? this.timerStatus,
      selectedSport: selectedSport ?? this.selectedSport,
    );
  }

  LeagueGameState copyWithTimerDuration(DurationStatus durationStatus) =>
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
        leagueTeams,
        rosters,
        athletes,
        filteredAthletes,
        selectedChain,
        startDate,
        endDate,
        differenceInDays,
        differenceInHours,
        differenceInMinutes,
        differenceInSeconds,
        timerStatus,
        selectedSport,
      ];
}
