import 'package:equatable/equatable.dart';

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

class ConfirmBuy extends SellDialogEvent {
  final double sellPrice;

  ConfirmBuy({required this.sellPrice});

  @override
  List<Object?> get props => [sellPrice];
}
