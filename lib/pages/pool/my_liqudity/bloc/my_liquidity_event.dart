part of 'my_liquidity_bloc.dart';

abstract class MyLiquidityEvent extends Equatable {
  const MyLiquidityEvent();

  @override
  List<Object> get props => [];
}

class LoadEvent extends MyLiquidityEvent {}

class SearchBarInputEvent extends MyLiquidityEvent {
  const SearchBarInputEvent({
    required this.searchBarInput,
  });

  final String searchBarInput;

  @override
  List<Object> get props => [searchBarInput];
}
