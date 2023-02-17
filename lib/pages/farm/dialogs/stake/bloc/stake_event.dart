part of 'stake_bloc.dart';

abstract class StakeEvent extends Equatable {
  const StakeEvent();

  @override
  List<Object> get props => [];
}

class StakeInput extends StakeEvent {
  const StakeInput({required this.input});

  final double input;

  @override
  List<Object> get props => [input];
}

class MaxButtonPressed extends StakeEvent {
  const MaxButtonPressed({required this.selectedFarm, required this.input});

  final FarmController selectedFarm;
  final double input;

  @override
  List<Object> get props => [selectedFarm];
}

class FetchSelectedFarmInformation extends StakeEvent {
  const FetchSelectedFarmInformation();
}
