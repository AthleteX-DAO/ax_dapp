part of 'swap_page_bloc.dart';

abstract class SwapPageEvent extends Equatable {
  const SwapPageEvent();
  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends SwapPageEvent {}

class FetchSwapInfoRequested extends SwapPageEvent {}

class NewTokenFromInputEvent extends SwapPageEvent {
  const NewTokenFromInputEvent({required this.tokenInputFromAmount});

  final double tokenInputFromAmount;

  @override
  List<Object?> get props => [tokenInputFromAmount];
}

class NewTokenToInputEvent extends SwapPageEvent {
  const NewTokenToInputEvent({required this.tokenInputToAmount});

  final double tokenInputToAmount;

  @override
  List<Object?> get props => [tokenInputToAmount];
}

class ConfirmSwapEvent extends SwapPageEvent {}

class ApproveSwapEvent extends SwapPageEvent {}

class MaxSwapTapEvent extends SwapPageEvent {}

class SetTokenFrom extends SwapPageEvent {
  const SetTokenFrom({required this.tokenFrom});

  final Token tokenFrom;

  @override
  List<Object?> get props => [tokenFrom];
}

class SetTokenTo extends SwapPageEvent {
  const SetTokenTo({required this.tokenTo});

  final Token tokenTo;

  @override
  List<Object?> get props => [tokenTo];
}

class SwapTokens extends SwapPageEvent {
  const SwapTokens({required this.tokenFromBalance, required this.tokenToBalance});

  final String tokenFromBalance;
  final String tokenToBalance;

  @override
  List<Object?> get props => [tokenFromBalance, tokenToBalance];
}
