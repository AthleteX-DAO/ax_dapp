part of 'sell_dialog_bloc.dart';

abstract class SellDialogEvent extends Equatable {
  const SellDialogEvent();

  @override
  List<Object?> get props => [];
}

class WatchAptPairStarted extends SellDialogEvent {
  const WatchAptPairStarted(this.athleteId);

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}

class AptTypeSelectionChanged extends SellDialogEvent {
  const AptTypeSelectionChanged(this.aptType);

  final AptType aptType;

  @override
  List<Object?> get props => [aptType];
}

class UpdateSwapController extends SellDialogEvent {
  const UpdateSwapController();

  @override
  List<Object?> get props => [];
}

class FetchAptSellInfoRequested extends SellDialogEvent {
  const FetchAptSellInfoRequested();
}

class NewAptInput extends SellDialogEvent {
  const NewAptInput({required this.aptInputAmount});

  final double aptInputAmount;

  @override
  List<Object?> get props => [aptInputAmount];
}

class MaxSellTap extends SellDialogEvent {}

class ConfirmSell extends SellDialogEvent {
  const ConfirmSell({required this.sellPrice});

  final double sellPrice;

  @override
  List<Object?> get props => [sellPrice];
}
