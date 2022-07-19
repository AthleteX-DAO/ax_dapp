part of 'scout_page_bloc.dart';

class ScoutPageState extends Equatable {
  const ScoutPageState({
    required this.athletes,
    required this.filteredAthletes,
    required this.selectedSport,
    required this.status,
  });

  factory ScoutPageState.initial() {
    return const ScoutPageState(
      athletes: [],
      filteredAthletes: [],
      status: BlocStatus.initial,
      selectedSport: SupportedSport.all,
    );
  }

  final List<AthleteScoutModel> athletes;
  final List<AthleteScoutModel> filteredAthletes;
  final SupportedSport selectedSport;
  final BlocStatus status;

  ScoutPageState copyWith({
    List<AthleteScoutModel>? filteredAthletes,
    SupportedSport? selectedSport,
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
  }) {
    return ScoutPageState(
      athletes: athletes ?? this.athletes,
      filteredAthletes: filteredAthletes ?? this.filteredAthletes,
      status: status ?? this.status,
      selectedSport: selectedSport ?? this.selectedSport,
    );
  }

  @override
  List<Object> get props => [athletes, filteredAthletes, selectedSport, status];

  @override
  String toString() =>
      '''ScoutPageState(cards: $athletes, status: $status, filteredAthletes: $filteredAthletes, selectedSport: $selectedSport)''';
}
