import 'package:equatable/equatable.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/pages/farm/models/FarmModel.dart';

class FarmState extends Equatable {
  final List<FarmModel> farms;
  final List<FarmModel> stakedFarms;
  final BlocStatus status;
  final bool isAllFarms;

  const FarmState(
      {this.status = BlocStatus.initial,
      this.isAllFarms = true,
      List<FarmModel>? farms,
      List<FarmModel>? stakedFarms})
      : farms = farms ?? const [],
        stakedFarms = stakedFarms ?? const [];

  @override
  List<Object?> get props => [farms, stakedFarms, isAllFarms, status];

  FarmState copy(
      {List<FarmModel>? farms,
      List<FarmModel>? stakedFarms,
      BlocStatus? status,
      bool? isAllFarms}) {
    return FarmState(
        farms: farms ?? this.farms,
        stakedFarms: stakedFarms ?? this.stakedFarms,
        status: status ?? this.status,
        isAllFarms: isAllFarms ?? this.isAllFarms);
  }
}
