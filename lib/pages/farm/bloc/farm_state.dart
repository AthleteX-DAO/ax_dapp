part of 'farm_bloc.dart';

class FarmState extends Equatable {
  const FarmState({
    this.status = BlocStatus.initial,
    this.isAllFarms = true,
    List<FarmModel>? farms,
    List<FarmModel>? stakedFarms,
    List<FarmModel>? filteredFarms,
    List<FarmModel>? filteredStakedFarms,
    required this.farmOwner,
    this.chain = EthereumChain.polygonMainnet,
  })  : farms = farms ?? const [],
        stakedFarms = stakedFarms ?? const [],
        filteredFarms = filteredFarms ?? const [],
        filteredStakedFarms = filteredStakedFarms ?? const [];

  final List<FarmModel> farms;
  final List<FarmModel> stakedFarms;
  final List<FarmModel> filteredFarms;
  final List<FarmModel> filteredStakedFarms;
  final BlocStatus status;
  final bool isAllFarms;
  final String farmOwner;
  final EthereumChain chain;

  @override
  List<Object?> get props => [
        farms,
        stakedFarms,
        filteredFarms,
        filteredStakedFarms,
        isAllFarms,
        status,
        farmOwner,
        chain,
      ];

  FarmState copy({
    List<FarmModel>? farms,
    List<FarmModel>? stakedFarms,
    List<FarmModel>? filteredFarms,
    List<FarmModel>? filteredStakedFarms,
    BlocStatus? status,
    bool? isAllFarms,
    EthereumChain? chain,
  }) {
    return FarmState(
      farms: farms ?? this.farms,
      stakedFarms: stakedFarms ?? this.stakedFarms,
      filteredFarms: filteredFarms ?? this.filteredFarms,
      filteredStakedFarms: filteredStakedFarms ?? this.filteredStakedFarms,
      status: status ?? this.status,
      isAllFarms: isAllFarms ?? this.isAllFarms,
      farmOwner: farmOwner,
      chain: chain ?? this.chain,
    );
  }

  FarmState copyWith({
    List<FarmModel>? farms,
    List<FarmModel>? stakedFarms,
    List<FarmModel>? filteredFarms,
    List<FarmModel>? filteredStakedFarms,
    BlocStatus? status,
    bool? isAllFarms,
    String? farmOwner,
    EthereumChain? chain,
  }) {
    return FarmState(
      farms: farms ?? this.farms,
      stakedFarms: stakedFarms ?? this.stakedFarms,
      filteredFarms: filteredFarms ?? this.filteredFarms,
      filteredStakedFarms: filteredStakedFarms ?? this.filteredStakedFarms,
      status: status ?? this.status,
      isAllFarms: isAllFarms ?? this.isAllFarms,
      farmOwner: farmOwner ?? this.farmOwner,
      chain: chain ?? this.chain,
    );
  }
}
