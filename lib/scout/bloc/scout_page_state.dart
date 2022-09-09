part of 'scout_page_bloc.dart';

class ScoutPageState extends Equatable {
  const ScoutPageState({
    this.status = BlocStatus.initial,
    this.athletes = const [],
    this.filteredAthletes = const [],
    this.selectedSport = SupportedSport.all,
    this.selectedChain = EthereumChain.polygonMainnet,
    this.axPrice = 0.0,
  });

  final List<AthleteScoutModel> athletes;
  final List<AthleteScoutModel> filteredAthletes;
  final SupportedSport selectedSport;
  final BlocStatus status;
  final EthereumChain selectedChain;
  final double axPrice;

  ScoutPageState copyWith({
    List<AthleteScoutModel>? filteredAthletes,
    SupportedSport? selectedSport,
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
    EthereumChain? selectedChain,
    double? axPrice,
  }) {
    return ScoutPageState(
      athletes: athletes ?? this.athletes,
      filteredAthletes: filteredAthletes ?? this.filteredAthletes,
      status: status ?? this.status,
      selectedSport: selectedSport ?? this.selectedSport,
      selectedChain: selectedChain ?? this.selectedChain,
      axPrice: axPrice ?? this.axPrice,
    );
  }

  @override
  List<Object> get props =>
      [athletes, filteredAthletes, selectedSport, axPrice, status, selectedChain];
}
