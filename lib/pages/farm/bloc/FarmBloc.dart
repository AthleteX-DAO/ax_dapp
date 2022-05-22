import 'package:ax_dapp/pages/farm/usecases/GetFarmDataUseCase.dart';
import 'package:ax_dapp/service/Controller/usecases/GetWalletAddressUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/pages/farm/models/FarmModel.dart';
import 'package:ax_dapp/pages/farm/bloc/FarmState.dart';
import 'package:ax_dapp/pages/farm/bloc/FarmEvent.dart';

class FarmBloc extends Bloc<FarmEvent, FarmState> {
  // the address of farms' owner in the gysr platform
  static const String owner = "0xe1bf752fd7480992345629bf3866f6618d57a7da";

  final GetFarmDataUseCase repo;
  final GetWalletAddressUseCase controller;

  final List<FarmModel> farms = [];
  final List<FarmModel> stakedFarms = [];

  FarmBloc({required this.repo, required this.controller})
      : super(const FarmState()) {
    on<OnLoadFarms>(_mapLoadFarmsEventToState);
    on<OnLoadStakedFarms>(_mapLoadStakedFarmsEventToState);
    on<OnSearchFarms>(_mapSearchEventToState);
    on<OnChangeFarmTab>(_mapChangeTabEventToState);
  }

  void _mapLoadFarmsEventToState(
      OnLoadFarms event, Emitter<FarmState> emit) async {
    try {
      print("load farms");
      emit(state.copy(status: BlocStatus.loading));
      final List<FarmModel> farms = await repo.fetchAllFarms(owner);
      if (farms.length > 0)
        emit(state.copy(farms: farms, status: BlocStatus.success));
      else
        emit(state.copy(status: BlocStatus.no_data));
    } catch (e) {
      print("[Console] Farm Page -> Failed to load farms list: $e");
      emit(state.copy(status: BlocStatus.error));
    }
  }

  void _mapLoadStakedFarmsEventToState(
      OnLoadStakedFarms event, Emitter<FarmState> emit) async {
    try {
      print("load staked farms");
      emit(state.copy(status: BlocStatus.loading));
      final String? account = controller.getWalletAddress();
      print("account address: $account");
      if (account != null) {
        final stakedFarms = await repo.fetchStakedFarms(account);
        if (stakedFarms.length > 0)
          emit(
              state.copy(stakedFarms: stakedFarms, status: BlocStatus.success));
        else
          emit(state.copy(status: BlocStatus.no_data));
      } else {
        emit(state.copy(status: BlocStatus.no_wallet));
        print("no wallet");
      }
    } catch (e) {
      print("[Console] Farm Page -> Failed to load staked farms list: $e");
      emit(state.copy(status: BlocStatus.error));
    }
  }

  void _mapSearchEventToState(OnSearchFarms event, Emitter<FarmState> emit) {
    emit(state.copy(
        farms: state.farms
            .where((farm) => farm.strName
                .toUpperCase()
                .contains(event.searchedName.toUpperCase()))
            .toList(),
        stakedFarms: state.stakedFarms
            .where((farm) => farm.strName
                .toUpperCase()
                .contains(event.searchedName.toUpperCase()))
            .toList(),
        status: BlocStatus.success));
  }

  void _mapChangeTabEventToState(
      OnChangeFarmTab event, Emitter<FarmState> emit) {
    print("Change Tab Event: ${event.isAllFarms}");
    emit(state.copy(isAllFarms: event.isAllFarms, status: BlocStatus.initial));
  }
}
