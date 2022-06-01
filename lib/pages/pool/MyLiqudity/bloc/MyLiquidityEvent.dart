part of 'MyLiquidityBloc.dart';

abstract class MyLiquidityEvent extends Equatable {
  const MyLiquidityEvent();

  @override
  List<Object> get props => [];
}

class LoadEvent extends MyLiquidityEvent {
  @override
  List<Object> get props => [];
}

class SearchBarInputEvent extends MyLiquidityEvent {
  final String searchBarInput;
  SearchBarInputEvent({
    required this.searchBarInput,
  });
  @override
  List<Object> get props => [this.searchBarInput];
}
