part of 'pool_bloc.dart';

abstract class PoolEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PageRefreshEvent extends PoolEvent {}

class Token0SelectionChanged extends PoolEvent {
  Token0SelectionChanged({required this.token0});

  final Token token0;

  @override
  List<Object?> get props => [token0];
}

class Token1SelectionChanged extends PoolEvent {
  Token1SelectionChanged({required this.token1});

  final Token token1;

  @override
  List<Object?> get props => [token1];
}

class MaxToken0InputButtonClicked extends PoolEvent {}

class MaxToken1InputButtonClicked extends PoolEvent {}

class Token0InputChanged extends PoolEvent {
  Token0InputChanged(this.token0Input);

  final String token0Input;

  @override
  List<Object?> get props => [token0Input];
}

class Token1InputChanged extends PoolEvent {
  Token1InputChanged(this.token1Input);

  final String token1Input;

  @override
  List<Object?> get props => [token1Input];
}

class AddLiquidityButtonClicked extends PoolEvent {}

class SwapTokens extends PoolEvent {}
