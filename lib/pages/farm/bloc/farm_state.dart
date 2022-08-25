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

  @override
  List<Object?> get props => [
        farms,
        stakedFarms,
        filteredFarms,
        filteredStakedFarms,
        isAllFarms,
        status,
        farmOwner,
      ];

  FarmState copy({
    List<FarmModel>? farms,
    List<FarmModel>? stakedFarms,
    List<FarmModel>? filteredFarms,
    List<FarmModel>? filteredStakedFarms,
    BlocStatus? status,
    bool? isAllFarms,
  }) {
    return FarmState(
      farms: farms ?? this.farms,
      stakedFarms: stakedFarms ?? this.stakedFarms,
      filteredFarms: filteredFarms ?? this.filteredFarms,
      filteredStakedFarms: filteredStakedFarms ?? this.filteredStakedFarms,
      status: status ?? this.status,
      isAllFarms: isAllFarms ?? this.isAllFarms,
      farmOwner: farmOwner,
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
  }) {
    return FarmState(
      farms: farms ?? this.farms,
      stakedFarms: stakedFarms ?? this.stakedFarms,
      filteredFarms: filteredFarms ?? this.filteredFarms,
      filteredStakedFarms: filteredStakedFarms ?? this.filteredStakedFarms,
      status: status ?? this.status,
      isAllFarms: isAllFarms ?? this.isAllFarms,
      farmOwner: farmOwner ?? this.farmOwner,
    );
  }
}
