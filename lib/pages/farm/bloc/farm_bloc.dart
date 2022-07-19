import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ax_dapp/pages/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/service/controller/usecases/get_wallet_address_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'farm_event.dart';
part 'farm_state.dart';

class FarmBloc extends Bloc<FarmEvent, FarmState> {
  FarmBloc({required this.repo, required this.controller})
      : super(const FarmState()) {
    on<OnLoadFarms>(_mapLoadFarmsEventToState);
    on<OnLoadStakedFarms>(_mapLoadStakedFarmsEventToState);
    on<OnSearchFarms>(_mapSearchEventToState);
    on<OnChangeFarmTab>(_mapChangeTabEventToState);
  }
  // the address of farms' owner in the gysr platform
  static const String owner = '0xe1bf752fd7480992345629bf3866f6618d57a7da';

  final GetFarmDataUseCase repo;
  final GetWalletAddressUseCase controller;

  final List<FarmModel> farms = [];
  final List<FarmModel> stakedFarms = [];

  Future<void> _mapLoadFarmsEventToState(
    OnLoadFarms event,
    Emitter<FarmState> emit,
  ) async {
    try {
      emit(
        state.copy(status: BlocStatus.loading, farms: [], filteredFarms: []),
      );
      final farms = await repo.fetchAllFarms(owner);
      if (farms.isNotEmpty) {
        emit(
          state.copy(
            farms: farms,
            filteredFarms: farms,
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(state.copy(status: BlocStatus.noData));
      }
    } catch (_) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  Future<void> _mapLoadStakedFarmsEventToState(
    OnLoadStakedFarms event,
    Emitter<FarmState> emit,
  ) async {
    try {
      emit(
        state.copy(
          status: BlocStatus.loading,
          stakedFarms: [],
          filteredStakedFarms: [],
        ),
      );
      final account = controller.getWalletAddress();
      if (account != null) {
        final stakedFarms = await repo.fetchStakedFarms(account);
        if (stakedFarms.isNotEmpty) {
          emit(
            state.copy(
              stakedFarms: stakedFarms,
              filteredStakedFarms: stakedFarms,
              status: BlocStatus.success,
            ),
          );
        } else {
          emit(state.copy(status: BlocStatus.noData));
        }
      } else {
        emit(state.copy(status: BlocStatus.noWallet));
      }
    } catch (_) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  void _mapSearchEventToState(OnSearchFarms event, Emitter<FarmState> emit) {
    emit(
      state.copy(
        filteredFarms: state.farms
            .where(
              (farm) => farm.strName
                  .toUpperCase()
                  .contains(event.searchedName.toUpperCase()),
            )
            .toList(),
        filteredStakedFarms: state.stakedFarms
            .where(
              (farm) => farm.strName
                  .toUpperCase()
                  .contains(event.searchedName.toUpperCase()),
            )
            .toList(),
        status: BlocStatus.success,
      ),
    );
  }

  void _mapChangeTabEventToState(
    OnChangeFarmTab event,
    Emitter<FarmState> emit,
  ) {
    emit(state.copy(isAllFarms: event.isAllFarms, status: BlocStatus.initial));
  }
}
