import 'package:equatable/equatable.dart';

class BuyDialogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnLoadDialog extends BuyDialogEvent {
  final String initialTokenAddress;
  @override
  List<Object?> get props => [];
  OnLoadDialog({required this.initialTokenAddress});
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
