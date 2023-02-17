import 'dart:async';

import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';

part 'stake_event.dart';
part 'stake_state.dart';

class StakeBloc extends Bloc<StakeEvent, StakeState> {
  StakeBloc({
    required FarmController farmController,
  })  : _farmController = farmController,
        super(const StakeState()) {
    on<StakeInput>(_onStakeInput);
    on<MaxButtonPressed>(_onMaxButtonPressed);
    on<FetchSelectedFarmInformation>(_onFetchSelectedFarmInformation);

    add(const FetchSelectedFarmInformation());
  }

  final FarmController _farmController;

  Future<void> _onStakeInput(
    StakeInput event,
    Emitter<StakeState> emit,
  ) async {
    final input = event.input;
    final totalStakedBalance =
        double.parse(_farmController.stakedInfo.value.viewAmount) + input;
    emit(state.copyWith(newBalance: totalStakedBalance, fundsAdded: input));
  }

  Future<void> _onMaxButtonPressed(
    MaxButtonPressed event,
    Emitter<StakeState> emit,
  ) async {
    final selectedFarm = event.selectedFarm;
    final input = event.input;
    final totalStakedBalance =
        double.parse(selectedFarm.stakedInfo.value.viewAmount) + input;
    emit(
      state.copyWith(
        newBalance: totalStakedBalance,
        fundsAdded: totalStakedBalance,
      ),
    );
  }

  Future<void> _onFetchSelectedFarmInformation(
    FetchSelectedFarmInformation event,
    Emitter<StakeState> emit,
  ) async {
    final balance = double.parse(_farmController.stakingInfo.value.viewAmount);
    final currentStaked =
        double.parse(_farmController.stakedInfo.value.viewAmount);
    emit(state.copyWith(balance: balance, currentStaked: currentStaked));
  }
}
