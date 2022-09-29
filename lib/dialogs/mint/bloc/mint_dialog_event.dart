part of 'mint_dialog_bloc.dart';

abstract class MintDialogEvent extends Equatable {
  const MintDialogEvent();

  @override
  List<Object?> get props => [];
}

class WatchAptPairStarted extends MintDialogEvent {
  const WatchAptPairStarted(this.athleteId);

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}

class FetchMintInfo extends MintDialogEvent {
  const FetchMintInfo(this.athleteId);

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}

class OnNewMintInput extends MintDialogEvent {
  const OnNewMintInput({required this.mintInputAmount});

  final double mintInputAmount;

  @override
  List<Object?> get props => [mintInputAmount];
}

class OnMaxMintTap extends MintDialogEvent {}
