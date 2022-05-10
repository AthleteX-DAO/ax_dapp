

part of 'package:ax_dapp/dialogs/sell/bloc/SellDialogBloc.dart';

abstract class SellDialogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDialog extends SellDialogEvent {
  final String currentTokenAddress;
  @override
  List<Object?> get props => [currentTokenAddress];
  LoadDialog({required this.currentTokenAddress});
}

class NewAptInput extends SellDialogEvent {
  final double aptInputAmount;
  @override
  List<Object?> get props => [aptInputAmount];
  NewAptInput({required this.aptInputAmount});
}

class MaxSellTap extends SellDialogEvent {
  @override
  List<Object?> get props => [];
}

class ConfirmSell extends SellDialogEvent {
  final double sellPrice;

  ConfirmSell({required this.sellPrice});

  @override
  List<Object?> get props => [sellPrice];
}
