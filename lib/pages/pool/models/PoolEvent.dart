import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:equatable/equatable.dart';

abstract class PoolEvent extends Equatable {}

class PageRefreshEvent extends PoolEvent {
  @override
  List<Object?> get props => [];
  PageRefreshEvent();
}

class Token0SelectionChanged extends PoolEvent {
  final Token token0;

  Token0SelectionChanged({required this.token0});

  @override
  List<Object?> get props => [token0];
}

class Token1SelectionChanged extends PoolEvent {
  final Token token1;

  Token1SelectionChanged({required this.token1});

  @override
  List<Object?> get props => [token1];
}

class MaxToken0InputButtonClicked extends PoolEvent {
  @override
  List<Object?> get props => [];
}

class MaxToken1InputButtonClicked extends PoolEvent {
  @override
  List<Object?> get props => [];
}

class Token0InputChanged extends PoolEvent {
  final double token0Input;

  Token0InputChanged(this.token0Input);

  @override
  List<Object?> get props => [token0Input];
}

class Token1InputChanged extends PoolEvent {
  final double token1Input;

  Token1InputChanged(this.token1Input);

  @override
  List<Object?> get props => [token1Input];
}

class AddLiquidityButtonClicked extends PoolEvent {
  @override
  List<Object?> get props => [];
}

class SwapTokens extends PoolEvent {
  SwapTokens();
  @override
  List<Object?> get props => [];
}
