part of 'sell_dialog_bloc.dart';

abstract class SellDialogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDialog extends SellDialogEvent {
  LoadDialog({required this.currentTokenAddress});

  final String currentTokenAddress;

  @override
  List<Object?> get props => [currentTokenAddress];
}

class NewAptInput extends SellDialogEvent {
  NewAptInput({required this.aptInputAmount});

  final double aptInputAmount;

  @override
  List<Object?> get props => [aptInputAmount];
}

class MaxSellTap extends SellDialogEvent {}

class ConfirmSell extends SellDialogEvent {
  ConfirmSell({required this.sellPrice});

  final double sellPrice;

  @override
  List<Object?> get props => [sellPrice];
}
