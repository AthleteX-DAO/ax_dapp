import 'dart:async';
import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ax_dapp/pages/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:config_repository/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'farm_event.dart';

part 'farm_state.dart';

class FarmBloc extends Bloc<FarmEvent, FarmState> {
  FarmBloc({
    required this.walletRepository,
    required this.tokensRepository,
    required this.configRepository,
    required this.streamAppDataChanges,
    required this.repo,
  }) : super(
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

  final WalletRepository walletRepository;
  final TokensRepository tokensRepository;
  final ConfigRepository configRepository;
  final StreamAppDataChangesUseCase streamAppDataChanges;
  final GetFarmDataUseCase repo;

  final List<FarmModel> farms = [];
  final List<FarmModel> stakedFarms = [];

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted event,
    Emitter<FarmState> emit,
  ) async {
    await emit.onEach<AppData>(
      streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final currentChain = appData.chain;
        debugPrint('Farms chain set to ${currentChain.chainName}');
        if (!isChainSupported(currentChain)) {
          emitUnsupportedChain(emit, currentChain);
          return;
        }
        emit(
          state.copyWith(
            status: BlocStatus.loading,
            chain: currentChain,
            farmOwner: currentChain.getFarmOwner(),
          ),
        );
        if (state.isAllFarms) {
          add(OnLoadFarms());
        } else {
          add(OnLoadStakedFarms());
        }
        debugPrint(
          'Farms onAppDataChanges emitted status ${state.status} on chain ${state.chain.chainName}',
        );
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
      debugPrint('Farms loading all for owner ${state.farmOwner}');
      if (!isChainSupported(walletRepository.currentWallet.chain)) {
        emit(
          state.copyWith(
            farms: [],
            stakedFarms: [],
            filteredFarms: [],
            chain: walletRepository.currentWallet.chain,
            status: BlocStatus.unsupportedChain,
          ),
        );
        return;
      }
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
      final currentWallet = walletRepository.currentWallet;
      final account = currentWallet.address;
      final isSupportedChain =
          isChainSupported(walletRepository.currentWallet.chain);
      if (account.isNotEmpty && isSupportedChain) {
        debugPrint(
          'Farms loading staked for owner ${state.farmOwner} for chain ${currentWallet.chain.chainName}',
        );
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
          if (isSupportedChain) {
            emit(state.copy(status: BlocStatus.noData));
          } else {
            emit(state.copy(status: BlocStatus.unsupportedChain));
          }
        }
      } else {
        if (isSupportedChain) {
          emit(state.copy(status: BlocStatus.noWallet));
        } else {
          emit(state.copy(status: BlocStatus.unsupportedChain));
        }
      }
    } catch (_) {
      emit(state.copy(status: BlocStatus.error));
    }
  }

  void _mapSearchEventToState(OnSearchFarms event, Emitter<FarmState> emit) {
    final currentApts = tokensRepository.currentApts;
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
    final BlocStatus status;
    final currentWallet = walletRepository.currentWallet;
    final isSupportedChain = isChainSupported(currentWallet.chain);
    if (currentWallet.isConnected) {
      if (isSupportedChain) {
        status = BlocStatus.loading;
      } else {
        status = BlocStatus.unsupportedChain;
      }
    } else {
      if (isSupportedChain) {
        status = BlocStatus.noWallet;
      } else {
        status = BlocStatus.unsupportedChain;
      }
    }
    emit(state.copy(isAllFarms: event.isAllFarms, status: status));

    if (event.isAllFarms) {
      add(OnLoadFarms());
    } else {
      add(OnLoadStakedFarms());
    }
  }

  void emitUnsupportedChain(Emitter<FarmState> emit, EthereumChain chain) {
    if (!isChainSupported(chain)) {
      emit(
        state.copyWith(
          farms: [],
          stakedFarms: [],
          filteredFarms: [],
          chain: chain,
          status: BlocStatus.unsupportedChain,
        ),
      );
      return;
    }
  }

  bool isChainSupported(EthereumChain chain) =>
      chain.chainId == EthereumChain.polygonMainnet.chainId ||
      chain.chainId == EthereumChain.goerliTestNet.chainId ||
      chain.chainId == EthereumChain.none.chainId;
}
