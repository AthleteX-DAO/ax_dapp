part of 'edit_rules_bloc.dart';

abstract class EditRulesEvent extends Equatable {
  const EditRulesEvent();

  @override
  List<Object> get props => [];
}

class UpdateLeague extends EditRulesEvent {}

class UpdateName extends EditRulesEvent {
  const UpdateName({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}

class UpdateStartDate extends EditRulesEvent {
  const UpdateStartDate({required this.startDate});
  final String startDate;

  @override
  List<Object> get props => [startDate];
}

class UpdateEndDate extends EditRulesEvent {
  const UpdateEndDate({required this.endDate});
  final String endDate;

  @override
  List<Object> get props => [endDate];
}

class UpdateTeamSize extends EditRulesEvent {
  const UpdateTeamSize({required this.teamSize});
  final int teamSize;

  @override
  List<Object> get props => [teamSize];
}

class UpdateParticipants extends EditRulesEvent {
  const UpdateParticipants({required this.participants});
  final int participants;

  @override
  List<Object> get props => [participants];
}

class UpdateEntryFee extends EditRulesEvent {
  const UpdateEntryFee({required this.entryFee});
  final int entryFee;

  @override
  List<Object> get props => [entryFee];
}

class UpdatePrivateToggle extends EditRulesEvent {
  const UpdatePrivateToggle({required this.privateToggleValue});
  final bool privateToggleValue;

  @override
  List<Object> get props => [privateToggleValue];
}

class UpdateLockToggle extends EditRulesEvent {
  const UpdateLockToggle({required this.lockedToggleValue});
  final bool lockedToggleValue;

  @override
  List<Object> get props => [lockedToggleValue];
}

class UpdateSports extends EditRulesEvent {
  const UpdateSports({required this.selectedSports});
  final List<SupportedSport> selectedSports;

  @override
  List<Object> get props => [selectedSports];
}
