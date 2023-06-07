part of 'unstake_bloc.dart';

abstract class UnStakeEvent extends Equatable {
  const UnStakeEvent();

  @override
  List<Object> get props => [];
}

class UnStakeInput extends UnStakeEvent {
  const UnStakeInput({required this.selectedFarm, required this.input});

  final FarmController selectedFarm;
  final String input;

  @override
  List<Object> get props => [selectedFarm, input];
}

class MaxButtonPressed extends UnStakeEvent {
  const MaxButtonPressed({required this.selectedFarm, required this.input});

  final FarmController selectedFarm;
  final String input;

  @override
  List<Object> get props => [selectedFarm, input];
}

class FetchSelectedFarmInformation extends UnStakeEvent {
  const FetchSelectedFarmInformation();
}
