part of 'mint_dialog_bloc.dart';

abstract class MintDialogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnLoading extends MintDialogEvent {
  OnLoading({required this.isLoading});

  final bool isLoading;
}

class OnAxAmountChanged extends MintDialogEvent {
  OnAxAmountChanged({required this.axAmount});

  final double axAmount;
}
