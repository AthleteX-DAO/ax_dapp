part of 'buy_dialog_bloc.dart';

abstract class BuyDialogEvent extends Equatable {
  const BuyDialogEvent();

  @override
  List<Object?> get props => [];
}

class WatchAptPairStarted extends BuyDialogEvent {
  const WatchAptPairStarted(this.athleteId);

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}

class AptTypeSelectionChanged extends BuyDialogEvent {
  const AptTypeSelectionChanged(this.aptType);

  final AptType aptType;

  @override
  List<Object?> get props => [aptType];
}

class FetchAptBuyInfoRequested extends BuyDialogEvent {
  const FetchAptBuyInfoRequested();
}

class OnNewAxInput extends BuyDialogEvent {
  const OnNewAxInput({required this.axInputAmount});

  final double axInputAmount;
}

class OnMaxBuyTap extends BuyDialogEvent {}

class OnConfirmBuy extends BuyDialogEvent {
  const OnConfirmBuy({required this.buyPrice});
  final double buyPrice;

  @override
  List<Object?> get props => [buyPrice];
}
