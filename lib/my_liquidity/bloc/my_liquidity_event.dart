part of 'my_liquidity_bloc.dart';

abstract class MyLiquidityEvent extends Equatable {
  const MyLiquidityEvent();

  @override
  List<Object> get props => [];
}

class WatchAppDataChangesStarted extends MyLiquidityEvent {
  const WatchAppDataChangesStarted();
}

class FetchAllLiquidityPositionsRequested extends MyLiquidityEvent {
  const FetchAllLiquidityPositionsRequested();
}

class SearchTermChanged extends MyLiquidityEvent {
  const SearchTermChanged({
    required this.searchTerm,
  });

  final String searchTerm;

  @override
  List<Object> get props => [searchTerm];
}
