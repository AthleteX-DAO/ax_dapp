part of 'farm_bloc.dart';

class FarmState extends Equatable {
  const FarmState({
    this.status = BlocStatus.initial,
    this.isAllFarms = true,
    List<FarmModel>? farms,
    List<FarmModel>? stakedFarms,
    List<FarmModel>? filteredFarms,
    List<FarmModel>? filteredStakedFarms,
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

  @override
  List<Object?> get props => [
        farms,
        stakedFarms,
        filteredFarms,
        filteredStakedFarms,
        isAllFarms,
        status
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
    );
  }
}
