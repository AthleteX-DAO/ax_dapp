import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/pages/farm/models/FarmModel.dart';
import 'package:ax_dapp/pages/farm/bloc/FarmState.dart';
import 'package:ax_dapp/pages/farm/bloc/FarmEvent.dart';

class FarmBloc extends Bloc<FarmEvent, FarmState> {
  final List<FarmModel> farms = [];

  FarmBloc() : super(const FarmState()) {
    on<OnLoadFarms>(_mapLoadEventToState);
    on<OnSearchFarms>(_mapSearchEventToState);
  }

  void _mapLoadEventToState(OnLoadFarms event, Emitter<FarmState> emit) async {}

  void _mapSearchEventToState(
      OnSearchFarms event, Emitter<FarmState> emit) async {
    emit(state.copy(
        farms: state.farms
            .where((farm) => farm.strName
                .toUpperCase()
                .contains(event.searchedName.toUpperCase()))
            .toList(),
        status: BlocStatus.success));
  }
}
