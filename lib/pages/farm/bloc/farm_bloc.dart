import 'dart:async';

import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ax_dapp/pages/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'farm_event.dart';
part 'farm_state.dart';

class FarmBloc extends Bloc<FarmEvent, FarmState> {
  FarmBloc({
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required this.repo,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _streamAppDataChanges = streamAppDataChanges,
        super(
          FarmState(
            farmOwner: walletRepository.defaultChain.getFarmOwner(),
          ),
        ) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<OnLoadFarms>(_mapLoadFarmsEventToState);
    on<OnLoadStakedFarms>(_mapLoadStakedFarmsEventToState);
    on<OnSearchFarms>(_mapSearchEventToState);
    on<OnChangeFarmTab>(_mapChangeTabEventToState);

    if (state.isAllFarms) {
      add(OnLoadFarms());
    } else {
      add(OnLoadStakedFarms());
    }
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final GetFarmDataUseCase repo;

  final List<FarmModel> farms = [];
  final List<FarmModel> stakedFarms = [];

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted event,
    Emitter<FarmState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        emit(state.copyWith(farmOwner: appData.chain.getFarmOwner()));
        if (state.isAllFarms) {
          add(OnLoadFarms());
        } else {
          add(OnLoadStakedFarms());
        }
      },
    );
  }

  Future<void> _mapLoadFarmsEventToState(
    OnLoadFarms event,
    Emitter<FarmState> emit,
  ) async {
    try {
      emit(
        state.copy(status: BlocStatus.loading, farms: [], filteredFarms: []),
      );
      final farms = await repo.fetchAllFarms(state.farmOwner);
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
      final account = _walletRepository.currentWallet.address;
      if (account.isNotEmpty) {
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
    final currentApts = _tokensRepository.currentApts;
    emit(
      state.copy(
        filteredFarms: state.farms
            .where(
              (farm) => (currentApts.findAptNameByAlias(farm.strStakedAlias) ??
                      farm.strName)
                  .toUpperCase()
                  .contains(event.searchedName.toUpperCase()),
            )
            .toList(),
        filteredStakedFarms: state.stakedFarms
            .where(
              (farm) => (currentApts.findAptNameByAlias(farm.strStakedAlias) ??
                      farm.strName)
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
