part of 'redeem_dialog_bloc.dart';

abstract class RedeemDialogEvent extends Equatable {
  const RedeemDialogEvent();

  @override
  List<Object?> get props => [];
}

class WatchAptPairStarted extends RedeemDialogEvent {
  const WatchAptPairStarted(this.athleteId);

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}

class FetchRedeemInfo extends RedeemDialogEvent {
  const FetchRedeemInfo(this.athleteId);

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}

class OnShortRedeemInput extends RedeemDialogEvent {
  const OnShortRedeemInput({required this.redeemShortInputAmount});

  final double redeemShortInputAmount;

  @override
  List<Object?> get props => [redeemShortInputAmount];
}

class OnLongRedeemInput extends RedeemDialogEvent {
  const OnLongRedeemInput({required this.redeemLongInputAmount});

  final double redeemLongInputAmount;

  @override
  List<Object?> get props => [redeemLongInputAmount];
}

class OnMaxRedeemTap extends RedeemDialogEvent {
  const OnMaxRedeemTap({required this.athleteId});

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}
