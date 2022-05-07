import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:equatable/equatable.dart';

class TradePageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PageRefreshEvent extends TradePageEvent {
  @override
  List<Object?> get props => [];
  PageRefreshEvent();
}

class NewTokenFromInputEvent extends TradePageEvent {
  final double tokenInputFromAmount;

  @override
  List<Object?> get props => [];
  NewTokenFromInputEvent({required this.tokenInputFromAmount});
}

class NewTokenToInputEvent extends TradePageEvent {
  final double tokenInputToAmount;

  @override
  List<Object?> get props => [];
  NewTokenToInputEvent({required this.tokenInputToAmount});
}

class ConfirmSwapEvent extends TradePageEvent {
  @override
  List<Object?> get props => [];
}

class ApproveSwapEvent extends TradePageEvent {
  @override
  List<Object?> get props => [];
}

class MaxSwapTapEvent extends TradePageEvent {
  @override
  List<Object?> get props => [];
}

class SetTokenFrom extends TradePageEvent {
  final Token tokenFrom;

  @override
  List<Object?> get props => [];
  SetTokenFrom({required this.tokenFrom});
}

class SetTokenTo extends TradePageEvent {
  final Token tokenTo;

  @override
  List<Object?> get props => [];
  SetTokenTo({required this.tokenTo});
}

class SwapTokens extends TradePageEvent {
  @override
  List<Object?> get props => [];
}
