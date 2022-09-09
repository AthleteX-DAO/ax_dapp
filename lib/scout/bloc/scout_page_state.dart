part of 'scout_page_bloc.dart';

class ScoutPageState extends Equatable {
  const ScoutPageState({
    this.status = BlocStatus.initial,
    this.athletes = const [],
    this.filteredAthletes = const [],
    this.selectedSport = SupportedSport.all,
    this.selectedChain = EthereumChain.polygonMainnet,
  });

  final List<AthleteScoutModel> athletes;
  final List<AthleteScoutModel> filteredAthletes;
  final SupportedSport selectedSport;
  final BlocStatus status;
  final EthereumChain selectedChain;

  ScoutPageState copyWith({
    List<AthleteScoutModel>? filteredAthletes,
    SupportedSport? selectedSport,
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
    EthereumChain? selectedChain,
  }) {
    return ScoutPageState(
      athletes: athletes ?? this.athletes,
      filteredAthletes: filteredAthletes ?? this.filteredAthletes,
      status: status ?? this.status,
      selectedSport: selectedSport ?? this.selectedSport,
      selectedChain: selectedChain ?? this.selectedChain,
    );
  }

  @override
  List<Object> get props =>
      [athletes, filteredAthletes, selectedSport, status, selectedChain];
}
