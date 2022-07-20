part of 'trade_page_bloc.dart';

abstract class TradePageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PageRefreshEvent extends TradePageEvent {}

class NewTokenFromInputEvent extends TradePageEvent {
  NewTokenFromInputEvent({required this.tokenInputFromAmount});

  final double tokenInputFromAmount;

  @override
  List<Object?> get props => [tokenInputFromAmount];
}

class NewTokenToInputEvent extends TradePageEvent {
  NewTokenToInputEvent({required this.tokenInputToAmount});

  final double tokenInputToAmount;

  @override
  List<Object?> get props => [tokenInputToAmount];
}

class ConfirmSwapEvent extends TradePageEvent {}

class ApproveSwapEvent extends TradePageEvent {}

class MaxSwapTapEvent extends TradePageEvent {}

class SetTokenFrom extends TradePageEvent {
  SetTokenFrom({required this.tokenFrom});

  final Token tokenFrom;

  @override
  List<Object?> get props => [tokenFrom];
}

class SetTokenTo extends TradePageEvent {
  SetTokenTo({required this.tokenTo});

  final Token tokenTo;

  @override
  List<Object?> get props => [tokenTo];
}

class SwapTokens extends TradePageEvent {}
