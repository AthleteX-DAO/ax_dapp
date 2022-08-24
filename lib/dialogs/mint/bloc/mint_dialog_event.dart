part of 'mint_dialog_bloc.dart';

abstract class MintDialogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnAxAmountChanged extends MintDialogEvent {
  OnAxAmountChanged({required this.axAmount});

  final double axAmount;
}
