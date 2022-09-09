part of 'add_liquidity_bloc.dart';

abstract class AddLiquidityEvent extends Equatable {
  const AddLiquidityEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends AddLiquidityEvent {
  const WatchAppDataChangesStarted();
}

class FetchPairInfoRequested extends AddLiquidityEvent {
  const FetchPairInfoRequested();
}

class Token0SelectionChanged extends AddLiquidityEvent {
  const Token0SelectionChanged({required this.token0});

  final Token token0;

  @override
  List<Object?> get props => [token0];
}

class Token1SelectionChanged extends AddLiquidityEvent {
  const Token1SelectionChanged({required this.token1});

  final Token token1;

  @override
  List<Object?> get props => [token1];
}

class Token0AmountChanged extends AddLiquidityEvent {
  const Token0AmountChanged(this.amount);

  final String amount;

  @override
  List<Object?> get props => [amount];
}

class Token1AmountChanged extends AddLiquidityEvent {
  const Token1AmountChanged(this.amount);

  final String amount;

  @override
  List<Object?> get props => [amount];
}

class SwapTokensRequested extends AddLiquidityEvent {
  const SwapTokensRequested();
}
