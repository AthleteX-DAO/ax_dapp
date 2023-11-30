part of 'markets_page_bloc.dart';

class MarketsPageState extends Equatable {
  const MarketsPageState({
    this.status = BlocStatus.initial,
    this.athletes = const [],
    this.liveSports = const [],
    this.filteredAthletes = const [],
    this.selectedMarket = SupportedMarkets.all,
    this.selectedSport = SupportedSport.all,
    this.selectedChain = EthereumChain.polygonMainnet,
    this.axPrice = 0.0,
  });

  final List<AthleteScoutModel> athletes;
  final List<SportsMarketsModel> liveSports;
  final List<AthleteScoutModel> filteredAthletes;
  final SupportedMarkets selectedMarket;
  final SupportedSport selectedSport;
  final BlocStatus status;
  final EthereumChain selectedChain;
  final double axPrice;

  MarketsPageState copyWith({
    List<AthleteScoutModel>? filteredAthletes,
    List<SportsMarketsModel>? liveSports,
    SupportedMarkets? selectedMarket,
    SupportedSport? selectedSport,
    BlocStatus? status,
    List<AthleteScoutModel>? athletes,
    EthereumChain? selectedChain,
    double? axPrice,
  }) {
    return MarketsPageState(
      athletes: athletes ?? this.athletes,
      liveSports: liveSports ?? this.liveSports,
      filteredAthletes: filteredAthletes ?? this.filteredAthletes,
      status: status ?? this.status,
      selectedMarket: selectedMarket ?? this.selectedMarket,
      selectedSport: selectedSport ?? this.selectedSport,
      selectedChain: selectedChain ?? this.selectedChain,
      axPrice: axPrice ?? this.axPrice,
    );
  }

  @override
  List<Object> get props => [
        athletes,
        liveSports,
        filteredAthletes,
        selectedMarket,
        selectedSport,
        axPrice,
        status,
        selectedChain
      ];
}
