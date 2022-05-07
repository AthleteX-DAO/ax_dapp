import 'package:equatable/equatable.dart';

abstract class BuyDialogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnLoadDialog extends BuyDialogEvent {
  final String currentTokenAddress;
  @override
  List<Object?> get props => [];
  OnLoadDialog({required this.currentTokenAddress});
}

class OnNewAxInput extends BuyDialogEvent {
  final double axInputAmount;
  @override
  List<Object?> get props => [];
  OnNewAxInput({required this.axInputAmount});
}

class OnMaxBuyTap extends BuyDialogEvent {
  @override
  List<Object?> get props => [];
}

class OnConfirmBuy extends BuyDialogEvent {
  final double buyPrice;

  OnConfirmBuy({required this.buyPrice});

  @override
  List<Object?> get props => [buyPrice];
}
