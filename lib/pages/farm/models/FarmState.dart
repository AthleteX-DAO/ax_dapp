import 'package:equatable/equatable.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/pages/farm/models/FarmModel.dart';

class FarmState extends Equatable {
  final List<FarmModel> farms;
  final BlocStatus status;

  const FarmState({this.status = BlocStatus.initial, List<FarmModel>? farms})
      : farms = farms ?? const [];

  @override
  List<Object?> get props => [farms];

  FarmState copy({List<FarmModel>? athletes, BlocStatus? status}) {
    return FarmState(
        farms: athletes ?? this.farms, status: status ?? BlocStatus.initial);
  }
}
