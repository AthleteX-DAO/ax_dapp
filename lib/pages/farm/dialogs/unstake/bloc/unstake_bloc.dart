import 'dart:async';

import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';

part 'unstake_event.dart';
part 'unstake_state.dart';

class UnStakeBloc extends Bloc<UnStakeEvent, UnStakeState> {
  UnStakeBloc({
    required FarmController farmController,
  })  : _farmController = farmController,
        super(const UnStakeState()) {
    on<UnStakeInput>(_onStakeInput);
    on<MaxButtonPressed>(_onMaxButtonPressed);
    on<FetchSelectedFarmInformation>(_onFetchSelectedFarmInformation);

    add(const FetchSelectedFarmInformation());
  }

  final FarmController _farmController;

  Future<void> _onStakeInput(
    UnStakeInput event,
    Emitter<UnStakeState> emit,
  ) async {
    final input = event.input;
    final selectedFarm = event.selectedFarm;
    if (input.isEmpty) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
        ),
      );
    }
    final parsedInput = double.parse(input);
    final totalStakedBalance =
        double.parse(selectedFarm.stakedInfo.value.viewAmount) + parsedInput;
    if (parsedInput > double.parse(selectedFarm.stakingInfo.value.viewAmount)) {
      emit(
        state.copyWith(
          status: BlocStatus.noData,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          newBalance: totalStakedBalance,
          fundsRemoved: parsedInput,
        ),
      );
    }
  }

  Future<void> _onMaxButtonPressed(
    MaxButtonPressed event,
    Emitter<UnStakeState> emit,
  ) async {
    final selectedFarm = event.selectedFarm;
    final input = event.input;
    final parsedInput = double.parse(input);
    final totalStakedBalance =
        double.parse(selectedFarm.stakedInfo.value.viewAmount) + parsedInput;
    emit(
      state.copyWith(
        status: BlocStatus.success,
        newBalance: totalStakedBalance,
        fundsRemoved: totalStakedBalance,
      ),
    );
  }

  Future<void> _onFetchSelectedFarmInformation(
    FetchSelectedFarmInformation event,
    Emitter<UnStakeState> emit,
  ) async {
    final currentBalance =
        double.parse(_farmController.stakingInfo.value.viewAmount);
    final currentStaked =
        double.parse(_farmController.stakedInfo.value.viewAmount);
    final stakedSymbol = _farmController.strStakedSymbol.value;
    final stakedAlias = _farmController.strStakedAlias.value;
    emit(
      state.copyWith(
        status: BlocStatus.success,
        currentBalance: currentBalance,
        currentStaked: currentStaked,
        stakedSymbol: stakedSymbol,
        stakedAlias: stakedAlias,
      ),
    );
  }
}
